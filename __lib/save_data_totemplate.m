
function [EEG, DATA_STRUCT] = save_data_totemplate(EEG, obj_info, template_info, save_info, path_info, data_info, params_info, subj_info)
    % Function: save_data_totemplate
    % Description: Saves preprocessed EEG data to a standard template (tensor or matrix).
    %
    % Input:
    %   - EEG: EEG data structure.
    %   - obj_info: Structure containing information about the EEG data file.
    %   - template_info: Structure containing information about the channel template.
    %   - save_info: Structure with information about the saving process.
    %   - path_info: Structure containing paths for saving preprocessed data.
    %   - data_info: Structure containing information about the EEG dataset.
    %   - params_info: Structure containing preprocessing parameters.
    %   - subj_info: Structure containing information about the subject.
    %
    % Output:
    %   - EEG: Updated EEG data structure.
    %   - DATA_STRUCT: Structure containing information about the saved data.
    %
    % Notes:
    %   - This function interpolates missing channels, updates channel names, and saves data to a standard template.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]

    chans_DATA_MATRIX = length(template_info.template_matrix(:,1));
    standard_ref_ch   = params_info.standard_ref;
   
    %% Extract Channels Name 
    B = EEG.chanlocs;
    [listB] = list_chan_systems(B,data_info.channel_system,template_info,data_info.channel_systems);

    %% Check number of missing channels and save who 
    pad_interpol_channels = false(chans_DATA_MATRIX,1);
    number_miss_ch = 0;

    for t=1:chans_DATA_MATRIX
        chan_name = template_info.template_matrix(t);
        if isempty(find(listB == chan_name,1)) %chan from template not present in the chanloc file
            number_miss_ch = number_miss_ch+1;
            pad_interpol_channels(t) = true;   %classified as interpolated
        end
    end

    %% Interpolation Step 
    if number_miss_ch ~= 0 
        %if there are missing channels respect the template => interpolate
        L1 = create_chan_loc(EEG, data_info, template_info.template_matrix, template_info);
        
        %with pop_interp channel_location, coordinates are mixed. But chanlocs is not used anymore.
        EEG1 = pop_interp(EEG, L1, params_info.interpol_method); 
    else
        EEG1 = EEG;
    end
       
    %% Update Channels Name 
    B = EEG1.chanlocs;
    [listB] = list_chan_systems(B,data_info.channel_system,template_info,data_info.channel_systems);

    %% Set the standard ref channel as a vector of zeros 
    %Here if Cz is not present, is also interpolated, so then Cz should be 0.
    if ~isequal(standard_ref_ch,'COMMON')
        EEG1.data(listB==standard_ref_ch,:) = zeros(1,length(EEG.data));
    end

    %% Select only channels in the template 
    NchanS = length(template_info.template_matrix);
    mask_ch = zeros(NchanS,1);
    for t=1:NchanS
        J = find(listB == template_info.template_matrix(t));
        if ~isempty(J)
            mask_ch(t) = J;
        end
    end

    %% Convert from uV to mV
    DATA_MATRIX = EEG1.data(mask_ch,:)/1000;

    %% Save and Create Tensor or Save Matrix standard template 
    data_tensor_size = size(template_info.template_tensor);

    DATA_STRUCT.filepath  = [obj_info.raw_filepath '/' obj_info.raw_filename];
    DATA_STRUCT.pad_file  = pad_interpol_channels; 
    DATA_STRUCT.subj_info = subj_info;
    
    if strcmp(save_info.save_data_as,'tensor')
        DATA_STRUCT.template = char(template_info.template_tensor); 

        DATA_TENSOR = zeros(data_tensor_size(1),data_tensor_size(2), length(EEG.data));
        for t=1:data_tensor_size(1)
            for u=1:data_tensor_size(2)
                K = template_info.template_tensor(t,u);
                if sum(template_info.template_matrix(:,1)==K)==1
                    DATA_TENSOR(t,u,:) = DATA_MATRIX(template_info.template_matrix(:,1)==K,:);
                end
            end
        end
        if save_info.save_struct
            DATA_STRUCT.data = DATA_TENSOR;
            save(path_info.mat_preprocessed_filepath,'DATA_STRUCT');
        else
            save(path_info.mat_preprocessed_filepath,'DATA_TENSOR');
        end

    elseif strcmp(save_info.save_data_as,'matrix')
        DATA_STRUCT.template = char(template_info.template_matrix); 
        
        if save_info.save_struct
            DATA_STRUCT.data = DATA_MATRIX;
            save(path_info.mat_preprocessed_filepath,'DATA_STRUCT');
        else
            save(path_info.mat_preprocessed_filepath,'DATA_MATRIX');
        end
    else
        error('ERROR: UNSUPPORTED SAVE FORMAT');
    end

end

function [listB] = list_chan_systems(B,channel_system,template_info,channel_systems)

    NchanB = length(B);
    listB = strings(1,NchanB);
    %10-20, 10-10, 10-5 channel systems
    if  isequal(channel_system,channel_systems{1}) || isequal(channel_system,channel_systems{2}) || isequal(channel_system,channel_systems{3})
        for t = 1:NchanB
            listB(t) = B(t).labels;
        end

    %GSN129, GSN257 channel systems
    elseif isequal(channel_system, channel_systems{4}) || isequal(channel_system, channel_systems{5})
        for t = 1:NchanB
            mask = template_info.conversion(:,2) == B(t).labels;
            if any(mask) %in this way we neglect channels that are not present in the conversion file
                listB(t) = template_info.conversion(mask,1);
            end
        end
    end
    listB(strcmp(listB,"")) = [];
end

