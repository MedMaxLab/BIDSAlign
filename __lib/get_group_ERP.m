
function [ERP_group] = get_group_ERP(folder, filename, channels, listB, event_name, epoch_lims, LERP, exclude_subj, verbose)
    % FUNCTION: get_group_ERP
    %
    % Description: Extracts event-related potentials (ERPs) for a group of subjects from EEG data.
    %
    % Syntax:
    %   [ERP_group] = get_group_ERP(folder, filename, channels, listB, event_name, epoch_lims, LERP, exclude_subj, verbose)
    %
    % Input:
    %   - folder (string): Path to the folder containing EEG data files.
    %   - filename (string): Optional. Name of the EEG data file. If provided, only the file with this name will be loaded.
    %   - channels (cell array of strings): List of channel names for which ERPs will be extracted.
    %   - listB (cell array of strings): List of all channel names in the dataset.
    %   - event_name (string): Name of the event marker.
    %   - epoch_lims (vector): Epoch limits [start_time, end_time].
    %   - LERP (integer): Length of the ERP (in data points).
    %   - exclude_subj (cell array of strings): List of subjects to exclude from analysis.
    %   - verbose (logical): Flag indicating whether to display progress messages.
    %
    % Output:
    %   - ERP_group (3D array): Extracted average ERP for each subject and channel desired.
    %
    % Author: [Andrea Zanola]
    % Date: [08/03/2024]

    if isempty(filename)
        a = dir([folder '/*.set']);
    else
        a = dir([folder '/' filename '.set']);
    end
    out = size(a,1);

    ERP_group = zeros(length(event_name),out-length(exclude_subj),LERP,length(channels)); 

    t = 1;
    for i=1:length(a)
        path_file = [folder '/' a(i).name];
    
        c = true;
        for k = 1:length(exclude_subj)
            c = c && ~contains(path_file,exclude_subj{k});
        end
    
        if c
            if verbose
                EEG = pop_loadset(path_file);
                EEG = pop_epoch(EEG, event_name, epoch_lims, 'epochinfo', 'yes');
                EEG = pop_rmbase(EEG, [epoch_lims(1) 0] ,[]);
            else
                [~,EEG] = evalc("pop_loadset(path_file);");
                [~,EEG] = evalc("pop_epoch(EEG, event_name, epoch_lims, 'epochinfo', 'yes');");
                [~,EEG] = evalc("pop_rmbase(EEG, [epoch_lims(1) 0] ,[]);");  
            end

            list_events = [];
            for j=1:length(EEG.epoch)
                list_events = [list_events string(EEG.epoch(j).eventtype{1})];
            end

            for j=1:length(channels)
                [channel_index, ~] = get_indexch(listB, channels(j));
                for k=1:length(event_name)
                    mask_event = (list_events == convertCharsToStrings(event_name{k}));
                    ERP_group(k,t,:,j) = squeeze(mean(EEG.data(channel_index,:,mask_event),3));
                end
            end
        end
        t = t+1;
    end

end
