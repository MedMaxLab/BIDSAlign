
function [EEG,L] = preprocess_single_file(raw_filepath, raw_filename, raw_channels_filename, set_preprocessed_filename, ...
                                          channel_systems, data_info, channel_to_remove, params_info, template_info, L)

    %% Load raw file ----------------------------------------------------
    %disp('--IMPORT DATA--')
    [EEG] = import_data(raw_filename, raw_filepath, data_info);
    EEG.history = ['DATASET:' data_info.dataset_name];
    EEG.history = [EEG.history newline 'IMPORT DATA: ' raw_filepath raw_filename];

    %(1) CHANLOCS MANAGMENT
    if  isempty(EEG.chanlocs) && isempty(data_info.channel_folder) && isempty(raw_channels_filename)
        error("IMPOSSIBLE TO LOAD CHANNEL LOCATION");
    end

    %% Rename the labels of the channels accorgind to the channels filename
    if ~isempty(raw_channels_filename) && ~strcmp(data_info.channel_location_filename, 'loaded')
        T = readtable(raw_channels_filename,"FileType","delimitedtext");
        for i=1:EEG.nbchan
            EEG.chanlocs(i).labels = char(T{i,1});
        end
        EEG.history = [EEG.history newline 'RENAME CHANNEL NAMES ACCORDING TO: ' raw_channels_filename];
    end

    %% Remove Channels --------------------------------------------------
    %disp('--REMOVE CHANNELS--')
    EEG.history = [EEG.history newline 'REMOVE CHANNELS: '  data_info.channel_to_remove];
    disp(EEG.history)
    [EEG] = pop_select(EEG, 'rmchannel', channel_to_remove);

    %% Import channel location and rerefence the data -------------------
    %disp('--IMPORT CHANLOC--')
    [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, L, template_info, channel_to_remove, channel_systems);

    %% Rereference the data
    %disp('--REREF DATA--')
    [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B);

    %% Uniform the Nomenclature -----------------------------------------
    %disp('--RENAME CHANNELS--')
%     if ~isempty(data_info.channel_folder)
%         [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, channel_systems);
%     end

    %% Resampling -------------------------------------------------------
    %disp('--RESAMPLE DATA--')
    if params_info.sampling_rate ~= data_info.samp_rate
         EEG.history = [EEG.history newline 'RESAMPLING TO: '  num2str(params_info.sampling_rate) 'Hz'];
         [EEG] = pop_resample( EEG, params_info.sampling_rate);
    end

    %% Filter the dat ---------------------------------------------------
    %disp('--FILTER DATA--')
    EEG.history = [EEG.history newline 'FIR FILTERING: '  num2str(params_info.low_freq) '-' num2str(params_info.high_freq) 'Hz'];
    [EEG] = pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);

    %% ASR --------------------------------------------------------------
    
    %% ICA Decomposition ------------------------------------------------
     %EEG = pop_runica(EEG, 'icatype', 'fastica', 'g', params_info.non_linearity_ica, 'lastEig', params_info.n_ica, 'verbose','off');
    
    %% Save the .set file -----------------------------------------------
    %disp('--SAVE .SET--')
    EEG.history = [EEG.history newline 'SAVE .SET FILE: ' data_info.set_folder set_preprocessed_filename];
    [EEG] = pop_saveset( EEG, 'filename',set_preprocessed_filename,'filepath',data_info.set_folder);

end
