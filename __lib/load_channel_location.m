
function [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, L, template_info, channel_to_remove, channel_systems)
 
    if ~strcmp(data_info.channel_location_filename, "loaded")
        if ~isempty(data_info.channel_folder)
    
            %Fig 4. 4)
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
            [B] = rename_channels(B, data_info, channel_systems, false, []);            
            NchanB = length(B);
            listB = strings(NchanB,1);
            for t = 1:NchanB
                listB(t) = B(t).labels;
            end
            
            [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems, true, EEG);
            NchanE = length(EEG.chanlocs);
            listE = strings(NchanE,1);
            for t = 1:NchanE
                listE(t) = EEG.chanlocs(t).labels;
            end

            % Keep in consideration if some channels have been removed, and
            % update the list of channels read from chanloc file
            Nremove = length(channel_to_remove{1});
            if Nremove > 0
                [~, ind_remove] = ismember(channel_to_remove, listB);
                
                B(ind_remove(ind_remove ~= 0)) = [];
                NchanB = length(B);
                listB = strings(NchanB,1);
                for t = 1:NchanB
                    listB(t) = B(t).labels;
                end
            end

            matching_labels = ismember(listE, listB);
            
            % Filter EEG.chanlocs using the logical index array
            EEG.chanlocs = B(matching_labels);
            EEG.history = [EEG.history newline 'LOAD CHANNEL LOCATION FROM: ' channel_location_filepath];
            
            
        else
            %Fig 4. 3)
            if isempty(L)
                
                [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems, true, EEG);
                L = create_chan_loc(EEG, data_info, [], template_info, channel_systems);
            end
            B = L;
            
            EEG.chanlocs = B;
            EEG.history = [EEG.history newline 'LOAD CHANNEL LOCATION FROM: ' data_info.standard_chanloc];
            [~,~,ext] = fileparts(data_info.standard_chanloc);
            channel_location_file_extension = ext(2:end);
        end
    else
        %Fig 4. 1)
        [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems, true, EEG);
        B = EEG.chanlocs;
        channel_location_file_extension = "nan";
        L = [];
    end

end




