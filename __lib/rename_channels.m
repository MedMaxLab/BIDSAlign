
function [B] = rename_channels(B, data_info, EEG_history, EEG)
    % FUNCTION: rename_channels
    %
    % Description: Renames channels in a structure based on specified rules.
    %
    % Syntax:
    %   [B] = rename_channels(B, data_info, EEG_history, EEG)
    %
    % Input:
    %   - B: Structure containing information about channel locations.
    %   - data_info: Structure containing general information about the dataset.
    %   - EEG_history: Boolean indicating whether to update EEG.history.
    %   - EEG: EEG data structure (optional).
    %
    % Output:
    %   - B: Updated structure with renamed channel labels.
    %
    % Notes:
    %   - This function changes channel names 
    %     to uppercase and removes dots or double dots.
    %   - It also standardizes the nomenclature for certain channels.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]

    %% Change channels name using upper case and erase dots

    B_labels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), B, ...
        'UniformOutput', false);
    
    for i=1:length(B_labels)
        B(i).labels = B_labels{i};
        if EEG_history
            %Only when EEG file is modified then, update EEG.history 
            EEG.history = [EEG.history newline ...
                'CHANGE CHANNEL NAME: upper case and remove "." or ".." at the end.]'];
        end
    end

    listB = string(B_labels);

    %% Uniform the Nomenclature -----------------------------------------

    %Here specify the old or bad names to convert.
    old_names = ["TP9 LEFT EAR", "TP10 RIGHT EAR", "T6", "T5", "T4", "T3"];

    %Here specify the new name in upper-case.
    new_names = {'TP9', 'TP10', 'P8', 'P7', 'T8', 'T7'};

    % For 10-20, 10-10, 10-5 systems
    if isequal(data_info.channel_system,data_info.channel_systems{1}) || ...
            isequal(data_info.channel_system, data_info.channel_systems{2}) || ...
            isequal(data_info.channel_system, data_info.channel_systems{3})
        for i=1:length(old_names)
            A = find(listB==old_names(i));
            if ~isempty(A) %check if an old name is present
                B(A).labels = new_names{i};
                if EEG_history
                    EEG.history = [EEG.history newline 'CHANGE CHANNEL NAME:' ...
                        old_names(i) 'TO' new_names{i}];
                end
            end
        end
    end

    % For GSN129, GSN257 systems
    if isequal(data_info.channel_system, data_info.channel_systems{4}) || ...
            isequal(data_info.channel_system, data_info.channel_systems{5})
        J = find(listB=='CZ');
        if ~isempty(J)
            B(J).labels = ['E' data_info.channel_system(end-2:end)];
            if EEG_history
                EEG.history = [EEG.history newline ...
                    'CHANGE CHANNEL NAME: CZ TO' B(J).labels];
            end
        end
    end
end
