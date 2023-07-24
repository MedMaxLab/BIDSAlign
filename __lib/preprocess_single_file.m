%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       Function for processing one single file with EEGLAB           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [EEG,L] = preprocess_single_file(raw_filepath, raw_filename, raw_channels_filename, set_preprocessed_filename, ...
                                          data_info, channel_to_remove, params_info, template_info, L)

    %% Load raw file ----------------------------------------------------
    EEG = import_data(raw_filename, raw_filepath, data_info);

    %% Rename the labels of the channels accorgind to the channels filename
    if isfile(raw_channels_filename) && ~strcmp(data_info.channel_location_filename, "loaded")
        T = readtable(raw_channels_filename,"FileType","delimitedtext");
        for i=1:EEG.nbchan
            EEG.chanlocs(i).labels = char(T{i,1});
        end
    end

    %% Remove Channels --------------------------------------------------
    [EEG] = pop_select(EEG, 'rmchannel', channel_to_remove);

    %% Import channel location and rerefence the data -------------------
    [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, L, template_info, channel_to_remove);

    %% Rereference the data
    [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B);

    %% Uniform the Nomenclature -----------------------------------------
    if ~isempty(data_info.channel_folder)
        [EEG] = rename_channels(EEG, data_info);
    end

    %% Resampling -------------------------------------------------------
    if params_info.sampling_rate ~= data_info.samp_rate
         [EEG] = pop_resample( EEG, params_info.sampling_rate);
    end

    %% Filter the dat ---------------------------------------------------
    [EEG] = pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);
    
    %% ICA Decomposition ------------------------------------------------
     %EEG = pop_runica(EEG, 'icatype', 'fastica', 'g', params_info.non_linearity_ica, 'lastEig', params_info.n_ica, 'verbose','off');
    
    %% Save the .set file -----------------------------------------------
    [EEG] = pop_saveset( EEG, 'filename',set_preprocessed_filename,'filepath',data_info.set_folder);

end
