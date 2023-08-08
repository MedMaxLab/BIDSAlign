
function [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, L, template_info, channel_to_remove, channel_systems)
 
    if ~strcmp(data_info.channel_location_filename, "loaded")
        if ~isempty(data_info.channel_folder)
    
            %(4) CHANLOCS MANAGMENT
            channel_location_filepath = data_info.channel_folder;
    
            %% Import Channels Location -----------------------------------------
            I = find(channel_location_filepath=='.');
            channel_location_file_extension = channel_location_filepath(I+1:end);
    
            if channel_location_file_extension == "bvef"
                C = loadbvef(channel_location_filepath);
                B = C(3:end); %first 2 labels are REF and GND           %CHECK THIS PART !!!
            else
                B = readlocs(channel_location_filepath,'filetype',channel_location_file_extension);
            end

            % Keep in consideration if some channels have strange name
%           processedLabels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), B, 'UniformOutput', false);
%           [B.labels] = processedLabels{:};
            [B] = rename_channels(B, data_info, channel_systems);
            listB = {B.labels};
            
%           processedLabels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), EEG.chanlocs, 'UniformOutput', false);
%           [EEG.chanlocs.labels] = processedLabels{:};
            [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems);
            listE = {EEG.chanlocs.labels};

            % Keep in consideration if some channels have been removed, and
            % update the list of channels read from chanloc file
            Nremove = length(channel_to_remove{1});
            if Nremove > 0
                [~, ind_remove] = ismember(channel_to_remove, listB);
                B(ind_remove(ind_remove ~= 0)) = [];
                listB = {B.labels};
            end

            matching_labels = ismember(listE, listB);
            
            % Filter EEG.chanlocs using the logical index array
            EEG.chanlocs = B(matching_labels);
            
        else
            %%(3) CHANLOCS MANAGMENT
            if isempty(L)
                
                [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems);
                L = create_chan_loc(EEG, data_info, [], template_info, channel_systems);
            end
            B = L;
            EEG.chanlocs = B;
            I = find(data_info.standard_chanloc=='.');
            channel_location_file_extension = data_info.standard_chanloch(I+1:end);
        end
    else
        %(1) CHANLOCS MANAGMENT
        B = EEG.chanlocs;
        channel_location_file_extension = "nan";
        L = [];
    end

end




