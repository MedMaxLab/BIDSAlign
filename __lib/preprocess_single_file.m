
function [EEG,L] = preprocess_single_file(L, obj_info, data_info, params_info, path_info, template_info, save_info, verbose)
    % FUNCTION: preprocess_single_file
    %
    % Description: Preprocesses a single EEG data file based on specified parameters.
    %
    % Syntax:
    %   [EEG, L] = preprocess_single_file(L, obj_info, data_info, params_info, path_info, template_info, save_info, verbose)
    %
    % Input:
    %   - L: Structure containing information about channel locations.
    %   - obj_info: Structure containing information about the EEG data file.
    %   - data_info: Structure containing general information about the dataset.
    %   - params_info: Structure containing preprocessing parameters.
    %   - path_info: Structure specifying paths for different components.
    %   - template_info: Structure containing template information.
    %   - save_info: Structure specifying the data saving options.
    %   - verbose: Boolean setting the verbosity level.
    %
    % Output:
    %   - EEG: EEG data structure after preprocessing.
    %   - L: Updated structure containing information about channel locations.
    %
    % Notes:
    %   - This function performs various preprocessing steps on a single EEG data file,
    %     including loading, importing events, managing channel locations, renaming channels,
    %     removing NaN values, removing channels, removing segments, removing baseline,
    %     resampling, filtering, importing or generating channel locations, rereferencing,
    %     performing Independent Component Analysis (ICA), and applying Artifact Subspace
    %     Reconstruction (ASR).
    %
    % Author: [Andrea Zanola, Federico Del Pup]
    % Date: [25/01/2024]

    if nargin <8
        verbose = false;
    end
    
    %% Load raw file
    if verbose
        [EEG] = import_data(obj_info.raw_filename, obj_info.raw_filepath, verbose);
    else
        [ ~, EEG] = evalc("import_data(obj_info.raw_filename, obj_info.raw_filepath, verbose);");
    end

    %% Trye to Import Event
    try
        if verbose
            [EEG] = pop_importevent(EEG,'event', obj_info.event_filename);
        else
            [~, EEG] = evalc("pop_importevent(EEG,'event', obj_info.event_filename);");
        end
    catch
        if isempty(obj_info.event_filename)
            if verbose
                disp('No Event file loaded.');
            end
        else
            if verbose
                warning('EVENT NOT IMPORTED DUE TO ERROR');
            end
        end
    end

    if ~isempty(EEG)
        EEG.history = ['--- PREVIOUS HISTORY ---' EEG.history newline '--- PREPROCESSED WITH BIDS-ALIGN ---'];
        EEG.history = [EEG.history newline 'DATASET: ' data_info.dataset_name];
        EEG.history = [EEG.history newline 'IMPORT DATA: ' obj_info.raw_filepath '\' obj_info.raw_filename];
    
        %% CHANLOCS MANAGMENT
        %(1) CHANLOCS MANAGMENT
        if  isempty(EEG.chanlocs) && isempty(obj_info.electrodes_filename) && isempty(obj_info.channels_filename)
            %Fig 4. 2)
            error('IMPOSSIBLE TO LOAD CHANNEL LOCATION');
        end
    
        %% Rename the labels of the channels accorgind to the channels filename
        if ~isempty(obj_info.channels_filename) && ~isequal(obj_info.channel_location_filename, 'loaded')
            T = readtable(obj_info.channels_filename,'FileType','text');
            for i=1:EEG.nbchan
                EEG.chanlocs(i).labels = char(T{i,1});
            end
            EEG.history = [EEG.history newline 'RENAME CHANNELS NAMES ACCORDING TO: ' obj_info.channels_filename];
        end

        %% Manually remove NaN 
        M = any(isnan(EEG.data));
        if any(M)
            EEG.data = EEG.data(:,not(M));
            EEG.history = [EEG.history newline 'REMOVED DATA WITH NANS: ' num2str(sum(M)) ' time stpes.'];
            if verbose
                warning('NANS ARE PRESENT IN THE RECORDED FILE');
            end
        end
    
        %% Remove Channels
        [EEG] = prepstep_removechannels(EEG, data_info, params_info, verbose);


        %% Import or generate channel location  
        %It is important to remove the channels first, because the
        %following function eventually uses create_chan_loc.m; here
        %conversion files are used, but non-physiological channels are not
        %present.
        [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, obj_info, L, template_info, verbose);


        %% Remove initial and final part of the recording
        [EEG] = prepstep_removesegments(EEG, params_info, verbose);
    
        %% Remove baseline 
        [EEG] = prepstep_removebaseline(EEG, params_info, verbose);

        %% Resampling 
        [EEG] = prepstep_resampling(EEG, data_info, params_info, verbose);

        %% Filter the data 
        [EEG] = prepstep_filtering(EEG, params_info, verbose);

        %% ICA
        [EEG] = prepstep_ICA(EEG, params_info, verbose);

        %% ICLabel Rejection
        if isfield(EEG,'reject')
            if isfield(EEG.reject,'gcompreject')
                EEG.reject.gcompreject = [];
            end
        end
        [EEG] = prepstep_ICArejection(EEG, params_info, verbose);


        %% 1˚ ASR channel correction
        nchan_preASR = EEG.nbchan;
        [EEG] = prepstep_1ASR(EEG, params_info, verbose);

        %% Interpolate if some channels are missing
        [EEG] = prepstep_interpolation(EEG, params_info, B, nchan_preASR, verbose);

        %% Rereference the data
        [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B, verbose);

        %% 2˚ ASR windows removal (ASR)
        [EEG] = prepstep_2ASR(EEG, params_info, verbose);
        
        %% Warning if file after aggressive ASR, still have values over threshold
        if max(abs(EEG.data),[],'all') > params_info.th_reject 
            if verbose
                warning(['EEG FILE STILL GREATER THAN ' num2str(params_info.th_reject/1000) ' mV']);
            end
        end

        %% FINAL ICA DECOMPOSITION
        if verbose
            if isequal(params_info.ica_type,'fastica')
                [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity);
            elseif isequal(params_info.ica_type,'runica')
                [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type);
            end
            [EEG] = iclabel(EEG);
        else
            if isequal(params_info.ica_type,'fastica')
                [~,EEG] = evalc("pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity);");
            elseif isequal(params_info.ica_type,'runica')
                [~,EEG] = evalc("pop_runica(EEG, 'icatype', params_info.ica_type);");
            end
            [~,EEG] = evalc("iclabel(EEG);");
        end
        EEG.history = [EEG.history newline 'FINAL ICA DECOMPOSITION: ' params_info.ica_type ', NON-LINEARITY: ' params_info.non_linearity];


        %% Save the .set file 
        if save_info.save_set
            EEG.history = [EEG.history newline 'SAVE .SET FILE: ' path_info.set_folder obj_info.set_preprocessed_filename]; 
            if verbose
                pop_saveset( EEG, 'filename', obj_info.set_preprocessed_filename,'filepath', path_info.set_folder);
            else
                evalc("pop_saveset( EEG, 'filename',obj_info.set_preprocessed_filename,'filepath', path_info.set_folder);");
            end       
        end
    end
end
