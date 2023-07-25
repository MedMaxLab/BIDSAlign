
function [EEG, DATA_STRUCT] = save_data_totemplate(raw_filepath, raw_filename, mat_preprocessed_filepath, EEG, template_info, ...
                                                   save_info, data_info, params_info, subj_info)

    channel_system    = convertCharsToStrings(data_info.channel_system);
    len_DATA_MATRIX   = length(EEG.data);  
    chans_DATA_MATRIX = length(template_info.template_matrix(:,1));

    standard_ref_ch   = params_info.standard_ref;
   
    %% Extract Channels Name --------------------------------------------
    B = EEG.chanlocs;
    NchanB = length(B);
    listB = strings(1,NchanB);
    if  channel_system == "10_5" || channel_system == "10_10" || channel_system == "10_20"
        for t=1:NchanB
            listB(t) = B(t).labels;
        end
    elseif channel_system == "GSN129" || channel_system == "GSN257"
        for t=1:NchanB
            mask = template_info.conversion(:,2) == B(t).labels;
            if any(mask) %in this way we neglect channels that are not present in the conversion file
                listB(t) = template_info.conversion(mask,1);
            end
        end
    end


    %% Check number of missing channels and save who --------------------
    pad_interpol_channels = false(chans_DATA_MATRIX,1);
    number_miss_ch = 0;

    for t=1:chans_DATA_MATRIX
        chan_name = template_info.template_matrix(t);
        if isempty(find(listB == chan_name,1)) %chan from template not present in the chanloc file
%             if chan_name ~= standard_ref_ch 
                number_miss_ch = number_miss_ch+1;
                pad_interpol_channels(t) = true;   %classified as interpolated
%             end
        end
    end

    %% Interpolation Step -----------------------------------------------
    if number_miss_ch ~= 0 %if there are missing channels respect the template => interpolate
        L1 = create_chan_loc(EEG, data_info, template_info.template_matrix, template_info);
        %disp('--INTERPOL DATA--')
        EEG1 = pop_interp(EEG, L1, params_info.interpol_method); %with POP_interp channel_location, coordinates are mixed. But chanlocs not used anymore.
        %Here if Cz is not present, is also interpolated, so then Cz should
        %be put as a vector of zeros.
    else
        EEG1 = EEG;
    end
       
    %% Update the list of channels after interpolation ------------------
    %% Extract Channels Name --------------------------------------------
    B = EEG1.chanlocs;
    NchanB = length(B);
    listB = strings(1,NchanB);
    if  channel_system == "10_5" || channel_system == "10_10" || channel_system == "10_20"
        for t=1:NchanB
            listB(t) = B(t).labels;
        end
    elseif channel_system == "GSN129" || channel_system == "GSN257"
        for t=1:NchanB
            if ~strcmp(B(t).labels, standard_ref_ch)
                mask = template_info.conversion(:,2) == B(t).labels;
                if any(mask) %in this way we neglect channels that are not present in the conversion file
                    listB(t) = template_info.conversion(mask,1);
                end
            else
                listB(t) = B(t).labels;
            end
        end
    end
 
    %% Set the standard ref channel as a vector of zeros ----------------
    if ~strcmp(standard_ref_ch,"COMMON")
        EEG1.data(listB==standard_ref_ch,:) = zeros(1,len_DATA_MATRIX);
    end

    %% Select only channels in the template -----------------------------
    NchanS = length(template_info.template_matrix);
    mask_ch = zeros(NchanS,1);
    for t=1:NchanS
        J = find(listB == template_info.template_matrix(t));
        if ~isempty(J)
            mask_ch(t) = J;
        end
    end


    %% Uniform Voltage Unit Channels ------------------------------------
    if strcmp(data_info.voltage_unit,'uV')
        DATA_MATRIX = EEG1.data(mask_ch,:)/1000;
    elseif strcmp(data_info.voltage_unit,'V')
        DATA_MATRIX = EEG1.data(mask_ch,:)*1000;
    elseif strcmp(data_info.voltage_unit,'mV')
        DATA_MATRIX = EEG1.data(mask_ch,:);
    else 
        warning("UNUSUAL SCALE UNIT");
    end

    %% Save and Create Tensor or Save Matrix standard template ----------
    data_tensor_size = size(template_info.template_tensor);

    DATA_STRUCT.filepath = [raw_filepath '\' raw_filename];
    DATA_STRUCT.pad_file = pad_interpol_channels; 
    DATA_STRUCT.subj_info = subj_info;
    
    if strcmp(save_info.save_data_as,'tensor')
        DATA_STRUCT.template = char(template_info.template_tensor); 

        DATA_TENSOR = zeros(data_tensor_size(1),data_tensor_size(2),len_DATA_MATRIX);
        for t=1:data_tensor_size(1)
            for u=1:data_tensor_size(2)
                K = template_info.template_tensor(t,u);
                DATA_TENSOR(t,u,:) = DATA_MATRIX(template_info.template_matrix(:,1)==K,:);
            end
        end
        if save_info.save_struct
            DATA_STRUCT.data = DATA_TENSOR;
            save(mat_preprocessed_filepath,'DATA_STRUCT');
        else
            save(mat_preprocessed_filepath,'DATA_TENSOR');
        end

    elseif strcmp(save_info.save_data_as,'matrix')
        DATA_STRUCT.template = char(template_info.template_matrix); 
        
        if save_info.save_struct
            DATA_STRUCT.data = DATA_MATRIX;

            save(mat_preprocessed_filepath,'DATA_STRUCT');
        else
            save(mat_preprocessed_filepath,'DATA_MATRIX');
        end
    else
        error("ERROR: UNSUPPORTED DATA ARCHITECTURE");
    end

end


