
function [EEG, DATA_STRUCT] = save_data_totemplate(EEG, obj_info, template_info, ...
    save_info, path_info, data_info, params_info, subj_info, verbose)
    % FUNCTION: save_data_totemplate
    %
    % Description: Saves preprocessed EEG data based on a specified template.
    %
    % Syntax:
    %   [EEG, DATA_STRUCT] = save_data_totemplate(EEG, obj_info, template_info, ...
    %                             save_info, path_info, data_info, ...
    %                             params_info, subj_info, verbose)
    %
    % Input:
    %   - EEG: EEG data structure.
    %   - obj_info: Structure containing information about the EEG data file.
    %   - template_info: Structure containing template information.
    %   - save_info: Structure specifying the data saving options.
    %   - path_info: Structure containing paths to datasets and libraries.
    %   - data_info: Structure containing information about the EEG dataset.
    %   - params_info: Structure containing preprocessing parameters.
    %   - subj_info: Structure containing participant information.
    %   - verbose: Boolean setting the verbosity level.
    %
    % Output:
    %   - EEG: Updated EEG data structure.
    %   - DATA_STRUCT: Structure containing information about the saved data.
    %
    % Notes:
    %   - This function saves preprocessed EEG data based on a specified template.
    %   - It handles missing channels, interpolates if necessary, 
    %     and saves data in the requested format.
    %
    % Author: [Andrea Zanola]
    % Date: [25/01/2024]
    %
    % Subfunctions:
    %   - [listB] = list_chan_systems(B, channel_system, template_info, channel_systems)
    %
    % Subfunction Description:
    %   - Lists channels based on the specified channel system.
    %
    % Subfunction Input:
    %   - B: Structure containing information about channel locations.
    %   - channel_system: Current EEG channel system.
    %   - template_info: Structure containing template information.
    %   - channel_systems: Cell array containing supported channel systems.
    %
    % Subfunction Output:
    %   - listB: List of channels based on the specified channel system.

    if nargin < 9
        verbose = false;
    end

    chans_DATA_MATRIX = length(template_info.template_matrix(:,1));
    standard_ref_ch   = params_info.standard_ref;
   
    %% Extract Channels Name 
    B = EEG.chanlocs;
    [listB] = list_chan_systems(B,data_info.channel_system, ...
                                template_info,data_info.channel_systems, false);

    %% Handle Old Reference
    % if isempty(intersect(convertCharsToStrings(obj_info.old_reference),listB))
    %     old_reference_registered = false;
    % else
    %     old_reference_registered = true;
    % end

    %% Check number of missing channels and save who 
    pad_interpol_channels = false(chans_DATA_MATRIX,1);
    [val,pos] = setdiff(template_info.template_matrix,listB);
    % ref_ind = [];
    % for i=1:length(val)
    %     if isequal(val(i),obj_info.old_reference)
    %         ref_ind = i;
    %     end
    % end
    % if ~isempty(ref_ind)
    %     val(ref_ind) = [];
    %     pos(ref_ind) = [];
    % end
    pad_interpol_channels(pos) = 1;
    number_miss_ch = length(val);

    %% Interpolation Step 
    if number_miss_ch ~= 0 
        % if there are missing channels respect the template => interpolate
        L1 = create_chan_loc(EEG, data_info, ...
            template_info.template_matrix, template_info);
        
        % with pop_interp channel_location, coordinates are mixed. 
        % But chanlocs is not used anymore.
        if verbose
            EEG1 = pop_interp(EEG, L1, params_info.interpol_method); 
            %EEG1 channell order is changed!
        else
            [~, EEG1] = evalc('pop_interp(EEG, L1, params_info.interpol_method);');
        end
        % Update channel order and list of names
    else
        EEG1 = EEG;
    end

    B1 = EEG1.chanlocs;
    [listB1] = list_chan_systems(B1,data_info.channel_system, template_info,data_info.channel_systems, false);
       
    %% Set the standard ref channel as a vector of zeros 
    %Here if Cz is not present, is also interpolated, so then Cz should be 0.
    % if ~isequal(standard_ref_ch,'COMMON')
    %     EEG1.data(listB==standard_ref_ch,:) = zeros(1,length(EEG.data));
    % end

    %% Select only channels in the template 
    mask_ch = zeros(chans_DATA_MATRIX,1);
    for t=1:chans_DATA_MATRIX
        if  isequal(data_info.channel_system,data_info.channel_systems{1}) || ...
            isequal(data_info.channel_system,data_info.channel_systems{2}) || ...
            isequal(data_info.channel_system,data_info.channel_systems{3})

            J = find(listB1 == template_info.template_matrix(t));

        elseif isequal(data_info.channel_system, data_info.channel_systems{4}) || ...
               isequal(data_info.channel_system, data_info.channel_systems{5})

            K = find(template_info.conversion(:,1)==template_info.template_matrix(t));
            J = find(listB1 == template_info.conversion(K,2));
        end

        if ~isempty(J)
            mask_ch(t) = J;
        else
            error('MISSING CHANNEL FROM TEMPLATE');
        end
    end

    %% Convert from uV to mV
    %DATA_MATRIX = EEG1.data(mask_ch,:)/1000;
    DATA_MATRIX = EEG1.data(mask_ch,:);

    %% Save and Create Tensor or Save Matrix standard template 
    data_tensor_size = size(template_info.template_tensor);

    DATA_STRUCT.filepath  = [obj_info.raw_filepath '/' obj_info.raw_filename];
    DATA_STRUCT.pad_file  = pad_interpol_channels; 
    DATA_STRUCT.subj_info = subj_info;
    
    set_label = strsplit(save_info.set_label,'_');
    DATA_STRUCT.label_group = set_label{1};
    DATA_STRUCT.label_pipeline = set_label{2};

    if strcmp(save_info.save_data_as,'tensor')
        DATA_STRUCT.template = char(template_info.template_tensor); 

        DATA_TENSOR = zeros(data_tensor_size(1),data_tensor_size(2), length(EEG.data));
        for t=1:data_tensor_size(1)
            for u=1:data_tensor_size(2)
                K = template_info.template_tensor(t,u);
                if sum(template_info.template_matrix(:,1)==K)==1
                    DATA_TENSOR(t,u,:) =  ...
                        DATA_MATRIX( template_info.template_matrix(:,1)==K , : );
                end
            end
        end
        if save_info.save_struct
            DATA_STRUCT.data = DATA_TENSOR;
            save(obj_info.mat_preprocessed_filename,'DATA_STRUCT');
        else
            save(obj_info.mat_preprocessed_filename,'DATA_TENSOR');
        end

    elseif strcmp(save_info.save_data_as,'matrix')
        DATA_STRUCT.template = char(template_info.template_matrix); 
        
        if save_info.save_struct
            DATA_STRUCT.data = DATA_MATRIX;
            save(obj_info.mat_preprocessed_filename,'DATA_STRUCT');
        else
            save(obj_info.mat_preprocessed_filename,'DATA_MATRIX');
        end
    else
        error('ERROR: UNSUPPORTED SAVE FORMAT');
    end

end

function [listB] = list_chan_systems(B,channel_system,template_info,channel_systems, conversion)

    NchanB = length(B);
    listB = strings(1,NchanB);
    %10-20, 10-10, 10-5 channel systems
    if  isequal(channel_system,channel_systems{1}) || ...
            isequal(channel_system,channel_systems{2}) || ...
            isequal(channel_system,channel_systems{3})
        for t = 1:NchanB
            listB(t) = B(t).labels;
        end

    %GSN129, GSN257 channel systems
    elseif isequal(channel_system, channel_systems{4}) || ...
            isequal(channel_system, channel_systems{5})
        for t = 1:NchanB
            if conversion
                mask = template_info.conversion(:,2) == B(t).labels;
                if any(mask) 
                    % in this way we neglect channels 
                    % that are not present in the conversion file
                    listB(t) = template_info.conversion(mask,1);
                end
            else
                listB(t) = string(B(t).labels);
            end
        end
    end
    listB(strcmp(listB,"")) = [];
end

