
function [EEG] = rename_channels(EEG, data_info)

    channel_system = convertCharsToStrings(data_info.channel_system);

    %% Update the list of available channels ---------------------------- CHECK IF THIS IS NECESSARY !!!
    B_labels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), EEG.chanlocs, 'UniformOutput', false);
    listB = string(B_labels);

    %% Uniform the Nomenclature -----------------------------------------
    old_names = ["TP9 LEFT EAR", "TP10 RIGHT EAR", "T6", "T5", "T4", "T3"]; %o9, o10?
    new_names = {'TP9', 'TP10', 'P8', 'P7', 'T8', 'T7'};

    if channel_system == "10_10" || channel_system == "10_5" || channel_system == "10_20"
        for i=1:length(old_names)
            A = find(listB==old_names(i));
            if ~isempty(A) %check if an old name is present
                EEG.chanlocs(A).labels = new_names{i};
            end
            
        end
    end

    if channel_system == "GSN129" || channel_system == "GSN257" 
        J = find(listB==['E' data_info.channel_system(end-2:end)]);
        if ~isempty(J)
            EEG.chanlocs(J).labels = 'CZ';
        end
    end
end