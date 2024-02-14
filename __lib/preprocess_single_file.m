
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
            EEG.history = [EEG.history newline 'RENAME CHANNEL NAMES ACCORDING TO: ' obj_info.channels_filename];
        end

        %% Manually remove NaN 
        M = any(isnan(EEG.data));
        if M
            EEG.data = EEG.data(:,not(M));
            EEG.history = [EEG.history newline 'REMOVED DATA WITH NANS: ' num2str(sum(M)) ' time stpes.'];
            if verbose
                warning('NANS ARE PRESENT IN THE RECORDED FILE');
            end
        end
    
        %% Remove Channels
        if ~isempty(data_info.channel_to_remove{1}) && params_info.prep_steps.rmchannels
            if verbose
                [EEG] = pop_select(EEG, 'rmchannel', data_info.channel_to_remove);
            else
                [ ~, EEG] = evalc( "pop_select(EEG, 'rmchannel', data_info.channel_to_remove)");
            end
            EEG.history = [EEG.history newline 'REMOVE CHANNELS: '  strjoin(data_info.channel_to_remove)];
        end

        %% Remove initial and final part of the recording
        if params_info.prep_steps.rmsegments

            if params_info.dt_i>0 && params_info.dt_f>0
                if EEG.xmax - params_info.dt_i - params_info.dt_f>0
                    if verbose
                        [EEG] = pop_select(EEG, 'rmtime', [0 params_info.dt_i; EEG.xmax-params_info.dt_f EEG.xmax]);
                    else
                         [~,EEG] = evalc("pop_select(EEG, 'rmtime', [0 params_info.dt_i; EEG.xmax-params_info.dt_f EEG.xmax]);");
                    end
                    EEG.history = [EEG.history newline 'REMOVED FIRST ' num2str(params_info.dt_i) 's AND LAST ' num2str(params_info.dt_f) 's'];
                
                elseif EEG.xmax - params_info.dt_f>0
                    if verbose
                        [EEG] = pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);
                    else
                        [~,EEG] = evalc("pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);");
                    end
                    EEG.history = [EEG.history newline 'REMOVED LAST ' num2str(params_info.dt_f) 's'];
                else
                    if verbose
                        warning('dt_f and dt_i NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING'); 
                    end
                end

            elseif params_info.dt_i==0 && params_info.dt_f>0
                if EEG.xmax - params_info.dt_f>0
                    if verbose
                        [EEG] = pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);
                    else
                        [~, EEG] = evalc("pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);");
                    end
                    EEG.history = [EEG.history newline 'REMOVED LAST ' num2str(params_info.dt_f) 's'];
                else
                    if verbose
                        warning('dt_f NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING');
                    end
                end

            elseif params_info.dt_i>0 && params_info.dt_f==0
                if EEG.xmax - params_info.dt_i>0
                    if verbose
                        [EEG] = pop_select(EEG, 'rmtime', [0 params_info.dt_i]);
                    else
                        [EEG] = evalc("pop_select(EEG, 'rmtime', [0 params_info.dt_i]);");
                    end
                    EEG.history = [EEG.history newline 'REMOVED FIRST ' num2str(params_info.dt_i) 's'];
                else
                    if verbose
                        warning('dt_i NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING');
                    end
                end
            end
        end
    
        %% Remove baseline 
        if params_info.prep_steps.rmbaseline
            if verbose
                [EEG] = pop_rmbase(EEG, [], []);
            else
                [~,EEG] = evalc("pop_rmbase(EEG, [], []);");
            end
            EEG.history = [EEG.history newline 'REMOVE BASELINE FOR EACH CHANNEL'];
        end

        %% Resampling 
        if params_info.prep_steps.resampling
            if params_info.sampling_rate ~= data_info.samp_rate && mod(EEG.srate, 1) == 0
                if verbose
                    [EEG] = pop_resample( EEG, params_info.sampling_rate);
                else
                    [~, EEG] = evalc("pop_resample( EEG, params_info.sampling_rate);");
                end
                 EEG.history = [EEG.history newline 'RESAMPLING TO: '  num2str(params_info.sampling_rate) 'Hz'];
                 
            elseif params_info.sampling_rate ~= data_info.samp_rate 
                %This is useful when the sampling rate in the file is
                %corrupted, but the sampling rate expected is known.
                 EEG.srate = data_info.samp_rate;
                 EEG.xmax = EEG.pnts/data_info.samp_rate;
                 if verbose
                    [EEG] = pop_resample( EEG, params_info.sampling_rate);
                 else
                    [~,EEG] = evalc("pop_resample( EEG, params_info.sampling_rate);");
                 end
                 EEG.history = [EEG.history newline 'RESAMPLING TO: '  num2str(params_info.sampling_rate) 'Hz'];
            end
        end

        %% Filter the data 
        if params_info.prep_steps.filtering
            if verbose
                [EEG] = pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);
            else
                [~,EEG] = evalc("pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);");
            end
            EEG.history = [EEG.history newline 'FIR FILTERING: '  num2str(params_info.low_freq) '-' num2str(params_info.high_freq) 'Hz'];
        end

        %% Import or generate channel location  
        %It is important to remove the channels first, because the
        %following function eventually uses create_chan_loc.m; here
        %conversion files are used, but non-physiological channels are not
        %present.

        [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, obj_info, L, template_info, verbose);

        %% ICA
        if params_info.prep_steps.ICA || params_info.prep_steps.ICrejection

            if params_info.n_ica ~= 0
                
                if verbose
                    [EEG, ~] = pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity, 'lastEig', min(EEG.nbchan,params_info.n_ica));
                else
                    [~,EEG] = evalc("pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity, 'lastEig', min(EEG.nbchan,params_info.n_ica));");
                end
                EEG.history = [EEG.history newline 'ICA DECOMPOSITION: ' params_info.ica_type ', ' num2str(params_info.n_ica) ...
                                ' ICs, NON-LINEARITY: ' params_info.non_linearity];
            else
                if verbose
                    [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity);
                else
                    [~,EEG] = evalc("pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity);");
                end
                EEG.history = [EEG.history newline 'ICA DECOMPOSITION: ' params_info.ica_type ', NON-LINEARITY: ' params_info.non_linearity];
            end

        end

        %% ICLabel Rejection
        if params_info.prep_steps.ICrejection && ~isempty(params_info.ic_rej_type)
            if isequal(params_info.ic_rej_type,'iclabel')
                if verbose
                    [EEG] = iclabel(EEG);
                    [EEG] = pop_icflag(EEG,params_info.iclabel_thresholds);
                    ics = 1:length(EEG.reject.gcompreject);
                    rejected_comps = ics(EEG.reject.gcompreject);
                    disp(rejected_comps)
                    [EEG] = pop_subcomp(EEG, rejected_comps);
                else
                    [~, EEG] = evalc("iclabel(EEG);");
                    [~, EEG] = evalc("pop_icflag(EEG,params_info.iclabel_thresholds);");
                    ics = 1:length(EEG.reject.gcompreject);
                    rejected_comps = ics(EEG.reject.gcompreject);
                    [~, EEG] = evalc("pop_subcomp(EEG, rejected_comps);");
                end
                EEG.history = [EEG.history newline 'ICLabel REJECTION.' newline 'Thresholds applied: '];

                labels_art = {'Brain', 'Muscle', 'Eye', 'Heart', 'Line Noise', 'Channel Noise', 'Other'};
                for i=1:length(labels_art)
                    EEG.history = [EEG.history labels_art{i} ': ' num2str(params_info.iclabel_thresholds(2,1)) ' - '  num2str(params_info.iclabel_thresholds(2,2)) '; '];
                end 

            elseif isequal(params_info.ic_rej_type,'mara')
                if verbose
                    [rejected_comps, info] = MARA(EEG);
                    ics = 1:length(info.posterior_artefactprob);
                    rejected_comps = ics(info.posterior_artefactprob>params_info.mara_threshold);
                    [EEG] = pop_subcomp(EEG, rejected_comps);
                else
                    [~, rejected_comps, info] = evalc("MARA(EEG);");
                    ics = 1:length(info.posterior_artefactprob);
                    rejected_comps = ics(info.posterior_artefactprob>params_info.mara_threshold);
                    [~, EEG] = evalc("pop_subcomp(EEG, rejected_comps);");
                end
                EEG.history = [EEG.history newline 'MARA REJECTION.'];
            else
                warning('CHECK params_info.ic_rej_type: METHOD NOT ALREADY IMPLEMENTED OR MISPELLED');
            end
        end

        nchan_preASR = EEG.nbchan;
        %% ASR 
        if params_info.prep_steps.ASR
            if verbose
                fprintf(' \t\t\t\t\t\t\t\t --- SOFT ASR APPLIED ---\n');
            end
            [EEG,~,~] = clean_artifacts(EEG, 'ChannelCriterion', params_info.channelC, ...
                                             'LineNoiseCriterion', params_info.lineC, ...
                                             'BurstCriterion', 'off', ...                  %default
                                             'WindowCriterion', 'off', ...                 %default
                                             'Highpass','off', ...
                                             'FlatlineCriterion', params_info.flatlineC,...
                                             'NumSamples', 50,...                          %default
                                             'ChannelCriterionMaxBadTime', 0.2,...         %default 
                                             'BurstCriterionRefMaxBadChns', 0.075 ,...     %default
                                             'BurstCriterionRefTolerances', [-inf 5.5],... %default
                                             'Distance', 'euclidian',...                   %default
                                             'WindowCriterionTolerances','off',...         %default
                                             'BurstRejection','off',...                    %default
                                             'NoLocsChannelCriterion', 0.45,...            %default
                                             'NoLocsChannelCriterionExcluded', 0.1,...     %default
                                             'MaxMem', 4096, ...                           %default
                                             'availableRAM_GB', NaN);                      %default);

            EEG.history = [EEG.history newline '1° ASR CHANNELS CORRECTION: FlatLineCriterion ' num2str(params_info.flatlineC) ...
                           ', ChannelCriterion ' num2str(params_info.channelC) ', LineNoiseCriterion ' num2str(params_info.lineC)];

            if max(abs(EEG.data),[],'all') > params_info.th_reject 
                if verbose
                    fprintf(' \t\t\t\t\t\t\t\t --- REMOVE BURST ASR APPLIED ---\n');
                end
                [EEG,~,~] = clean_artifacts(EEG, 'ChannelCriterion', 'off', ...
                                                 'LineNoiseCriterion', 'off', ...
                                                 'BurstCriterion', params_info.burstC, ...     %default
                                                 'WindowCriterion', params_info.windowC, ...   %default
                                                 'Highpass','off', ...
                                                 'FlatlineCriterion', 'off',...
                                                 'NumSamples', 50,...                          %default
                                                 'ChannelCriterionMaxBadTime', 0.2,...         %default 
                                                 'BurstCriterionRefMaxBadChns', 0.075 ,...     %default
                                                 'BurstCriterionRefTolerances', [-inf 5.5],... %default
                                                 'Distance', 'euclidian',...                   %default
                                                 'WindowCriterionTolerances','off',...         %default
                                                 'BurstRejection',params_info.burstR,...       %changed from off -> on
                                                 'NoLocsChannelCriterion', 0.45,...            %default
                                                 'NoLocsChannelCriterionExcluded', 0.1,...     %default
                                                 'MaxMem', 4096, ...                           %default
                                                 'availableRAM_GB', NaN);                      %default

                EEG.history = [EEG.history newline '2° ASR WINDOWS REMOVAL: BurstCriterion ' num2str(params_info.burstC) ...
                               ', WindowCriterion ' num2str(params_info.windowC), ', BurstRejection', num2str(params_info.burstR)];

            end
        end

        %% Remove file if after aggressive ASR, still
        if max(abs(EEG.data),[],'all') > params_info.th_reject 
            if verbose
                warning(['EEG FILE STILL GREATER THAN ' num2str(params_info.th_reject/1000) ' mV']);
            end
        end
        
        %% Interpolate if some channels are missing
        if nchan_preASR>EEG.nbchan
            if verbose
                [EEG] = pop_interp(EEG, B, params_info.interpol_method); 
            else
                [~, EEG] = evalc('pop_interp(EEG, B, params_info.interpol_method);');
            end
            EEG.history = [EEG.history newline 'INTERPOLATION OF REMOVED CHANNELS BY ASR - method: ' params_info.interpol_method];
        end

        %% Rereference the data
        if params_info.prep_steps.rereference
            [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B, verbose);
        end

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
