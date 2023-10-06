
% Function: rename_channels
% Description: Renames EEG channel labels based on specified naming conventions
% and channel systems.
%
% Input:
%   - B: A data structure containing EEG channel information.
%   - data_info: A structure containing information about the EEG data,
%                including the channel system.
%   - channel_systems: Cell array containing supported channel systems.
%   - EEG_history: A boolean flag indicating whether to update EEG.history.
%   - EEG: EEG data structure (optional), used to update EEG.history.
%
% Output:
%   - B: Updated data structure with renamed channel labels.
%
% Usage example:
%   B = rename_channels(B, data_info_struct, channel_systems_cell, true, EEG_struct);
%
% Notes:
%   - This function renames EEG channel labels according to specified naming
%     conventions for different channel systems. It also updates EEG.history
%     when changes are made (if EEG_history is true).
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]


function [B] = rename_channels(B, data_info, channel_systems, EEG_history, EEG)


    %% Change channels name using upper case and erase dots

    B_labels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), B, 'UniformOutput', false);
    
    for i=1:length(B_labels)
        B(i).labels = B_labels{i};
        if EEG_history
            %Only when EEG file is modified then, update EEG.history 
            EEG.history = [EEG.history newline 'CHANGE CHANNEL NAME: upper case and remove "." or ".." at the end.]'];
        end
    end

    listB = string(B_labels);

    %% Uniform the Nomenclature -----------------------------------------
    old_names = ["TP9 LEFT EAR", "TP10 RIGHT EAR", "T6", "T5", "T4", "T3"]; %o9, o10?
    new_names = {'TP9', 'TP10', 'P8', 'P7', 'T8', 'T7'};

    % For 10-20, 10-10, 10-5 systems
    if isequal(data_info.channel_system,channel_systems{1}) || isequal(data_info.channel_system, channel_systems{2}) || isequal(data_info.channel_system, channel_systems{3})
        for i=1:length(old_names)
            A = find(listB==old_names(i));
            if ~isempty(A) %check if an old name is present
                B(A).labels = new_names{i};
                if EEG_history
                    EEG.history = [EEG.history newline 'CHANGE CHANNEL NAME:' old_names(i) 'TO' new_names{i}];
                end
            end
            
        end
    end

    % For GSN129, GSN257 systems
    if isequal(data_info.channel_system, channel_systems{4}) || isequal(data_info.channel_system, channel_systems{5})
        J = find(listB=='CZ');
        if ~isempty(J)
            B(J).labels = ['E' data_info.channel_system(end-2:end)];
            if EEG_history
                EEG.history = [EEG.history newline 'CHANGE CHANNEL NAME: CZ TO' B(J).labels];
            end
        end
    end
end
