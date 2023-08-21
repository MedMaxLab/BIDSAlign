
function [B] = rename_channels(B, data_info, channel_systems, EEG_history, EEG)

    channel_system = convertCharsToStrings(data_info.channel_system);

    %% Update the list of available channels ---------------------------- CHECK IF THIS IS NECESSARY !!!

    B_labels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), B, 'UniformOutput', false);
    
    for i=1:length(B_labels)
        B(i).labels = B_labels{i};
        if EEG_history
            EEG.history = [EEG.history newline 'CHANGE CHANNEL NAME: upper case and remove "." or ".." at the end.]'];
        end
    end

     listB = string(B_labels);

    %% Uniform the Nomenclature -----------------------------------------
    old_names = ["TP9 LEFT EAR", "TP10 RIGHT EAR", "T6", "T5", "T4", "T3"]; %o9, o10?
    new_names = {'TP9', 'TP10', 'P8', 'P7', 'T8', 'T7'};

    if strcmp(channel_system,channel_systems{1}) || strcmp(channel_system, channel_systems{2}) || strcmp(channel_system, channel_systems{3})
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

    if strcmp(channel_system, channel_systems{4}) || strcmp(channel_system, channel_systems{5})
        J = find(listB=='CZ');
        if ~isempty(J)
            B(J).labels = ['E' data_info.channel_system(end-2:end)];
            if EEG_history
                EEG.history = [EEG.history newline 'CHANGE CHANNEL NAME:' CZ 'TO' B(J).labels];
            end
        end
    end
end
