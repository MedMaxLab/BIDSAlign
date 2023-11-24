
% Function: load_channel_location
% Description: Loads channel location information for EEG data. 
% It either reads channel locations from a file or generates them based on the
% channel system information.
%
% Inputs:
%   - EEG: EEG structure containing channel information.
%   - data_info: Struct containing dataset-specific information.
%   - L: Channel location structure (optional).
%   - template_info: Struct containing channel template information.
%   - channel_to_remove: List of channels to remove (optional).
%   - channel_systems: Cell array of supported channel systems.
%
% Outputs:
%   - EEG: EEG structure with updated channel locations.
%   - L: Channel location structure.
%   - channel_location_file_extension: File extension of the loaded channel location file.
%   - B: Channel location structure containing only the specified channels.
%
% Usage example:
%   [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, L, template_info, channel_to_remove, channel_systems);
%
% Notes:
%   - This function either loads channel locations from a file or generates
%     them based on the channel system information, and updates the EEG structure.
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]

% Function: list_chan
% Description: Extract channel labels from a channel location structure.
%
% This function extracts the channel labels from a given channel location structure.
%
% Inputs:
%   - B: Channel location structure.
%
% Outputs:
%   - NchanB: Number of channels in the structure.
%   - listB: Cell array of channel labels.
%
% Usage example:
%   [NchanB, listB] = list_chan(B);
%
% Notes:
%   - This function retrieves channel labels from a channel location structure.
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]

function [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, L, template_info, channel_to_remove, channel_systems)

    if ~strcmp(data_info.channel_location_filename, "loaded")
        if ~isempty(data_info.electrodes_filename)
    
            %Fig 4. 4)
            %% Import Channels Location -----------------------------------------
            [~,~,channel_location_file_extension] = fileparts(data_info.electrodes_filename);

            %I = find(channel_location_filepath=='.');
            %channel_location_file_extension = channel_location_filepath(I+1:end);
    
            if isequal(channel_location_file_extension,'.bvef')
                C = loadbvef(data_info.electrodes_filename);
                B = C(3:end); %first 2 labels are REF and GND           %CHECK THIS PART !!!
            else
                B = readlocs(data_info.electrodes_filename,'filetype',channel_location_file_extension(2:end),'importmode','native');
            end

            % Keep in consideration if some channels have strange name from
            % the channel location file
            [B] = rename_channels(B, data_info, channel_systems, false, []);     
            [~,listB] = list_chan(B);

            % Keep in consideration if some channels have strange name from
            % the channel location field of EEG struct          
            %Note that EEG.history should be true, if EEG.chanlocs is
            %passed; in such a way we can update the EEG.history
            [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems, true, EEG);

            [~,listE] = list_chan(EEG.chanlocs);
            
            % Keep in consideration if some channels have been removed, and
            % update the list of channels read from chanloc file
            Nremove = length(channel_to_remove{1});
            if Nremove > 0
                [~, ind_remove] = ismember(channel_to_remove, listB);
                
                B(ind_remove(ind_remove ~= 0)) = [];
                [~,listB] = list_chan(B);
            end

            matching_labels = ismember(listE, listB);
            
            % Filter EEG.chanlocs using the logical index array
            B =  B(matching_labels);
            EEG.chanlocs = B;
            if ~isempty(data_info.nose_dir)
                EEG = pop_chanedit(EEG, 'nosedir', data_info.nose_dir);
            end
            EEG.history = [EEG.history newline 'LOAD CHANNEL LOCATION FROM: ' data_info.electrodes_filename];
            
            
        else
            %Fig 4. 3)
            %If the channel location is not provided, we can generate one
            %from the channel system. Thus this condition is useful to
            %generate L only one time
            if isempty(L)
                
                [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems, true, EEG);
                [L] = create_chan_loc(EEG, data_info, [], template_info, channel_systems);
            end
            B = L;
            
            EEG.chanlocs = B;
            EEG.history = [EEG.history newline 'LOAD CHANNEL LOCATION FROM: ' data_info.standard_chanloc];
            [~,~,channel_location_file_extension] = fileparts(data_info.standard_chanloc);
            %channel_location_file_extension = ext(2:end);
        end
    else
        %Fig 4. 1)
        [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems, true, EEG);
        B = EEG.chanlocs;
        channel_location_file_extension = "nan";
        L = [];
    end

end

function [NchanB,listB] = list_chan(B)
    NchanB = length(B);
    listB = strings(NchanB,1);
    for t = 1:NchanB
        listB(t) = B(t).labels;
    end
end


