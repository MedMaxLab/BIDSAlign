
function [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, L, template_info, channel_to_remove)

    channel_system = convertCharsToStrings(data_info.channel_system);
 
    if ~strcmp(data_info.channel_location_filename, "loaded")
        if ~isempty(data_info.channel_folder)
    
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
            processedLabels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), B, 'UniformOutput', false);
            [B.labels] = processedLabels{:};
            listB = {B.labels};
            
            processedLabels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), EEG.chanlocs, 'UniformOutput', false);
            [EEG.chanlocs.labels] = processedLabels{:};
            listE = {EEG.chanlocs.labels};

            % Keep in consideration if some channels have been removed
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
            if isempty(L)
                
                EEG = rename_channels(EEG, data_info);
                L = create_chan_loc(EEG, data_info, [], template_info);
            end
            B = L;
            EEG.chanlocs = B;
            if channel_system == "10_10" || channel_system == "10_20"
                channel_location_file_extension = "locs"; %CHANGE
            else
                channel_location_file_extension = "sfp"; %CHANGE
            end
        end
    else
        B = EEG.chanlocs;
        channel_location_file_extension = "nan";
        L = [];
    end

end




