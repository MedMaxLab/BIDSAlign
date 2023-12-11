
function [EEG,L] = preprocess_single_file(L, obj_info, data_info, params_info, path_info, template_info, save_info)
    % Function: preprocess_single_file
    % Description: Preprocesses a single EEG data file, including loading raw data,
    % importing events, managing channel locations, filtering, resampling, and applying
    % various preprocessing steps such as ASR and ICA.
    %
    % Input:
    %   - L: Structure containing information about channel locations.
    %   - obj_info: Structure containing information about the EEG data file.
    %   - data_info: Structure containing information about the EEG dataset.
    %   - params_info: Structure containing preprocessing parameters.
    %   - path_info: Structure containing paths for saving preprocessed data.
    %   - template_info: Structure containing template information for channel selection.
    %   - save_info: Structure containing information about saving preprocessed data.
    %
    % Output:
    %   - EEG: EEG data structure after preprocessing.
    %   - L: Updated structure containing information about channel locations.
    %
    % Notes:
    %   - This function performs various preprocessing steps on a single EEG data file,
    %     including loading, filtering, resampling, ASR, ICA, and saving the preprocessed file.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]
    
    %% Load raw file 
    [EEG] = import_data(obj_info.raw_filename, obj_info.raw_filepath);

    %% Trye to Import Event
    try
        [EEG] = pop_importevent(EEG,'event', obj_info.event_filename);
    catch
        if isempty(obj_info.event_filename)
            disp('No Event file loaded.');
        else
            warning('EVENT NOT IMPORTED DUE TO ERROR');
        end
    end

    if ~isempty(EEG)
        EEG.history = ['DATASET: ' data_info.dataset_name];
        EEG.history = [EEG.history newline 'IMPORT DATA: ' obj_info.raw_filepath obj_info.raw_filename];
    
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
            warning('NANS ARE PRESENT IN THE RECORDED FILE');
        end
    
        %% Remove Channels
        if ~isempty(data_info.channel_to_remove) && params_info.prep_steps.rmchannels
            [EEG] = pop_select(EEG, 'rmchannel', data_info.channel_to_remove);
            EEG.history = [EEG.history newline 'REMOVE CHANNELS: '  data_info.channel_to_remove];
        end

        %% Remove initial and final part of the recording
        if params_info.prep_steps.rmsegments

            if params_info.dt_i>0 && params_info.dt_f>0
                if EEG.xmax - params_info.dt_i - params_info.dt_f>0
                    [EEG] = pop_select(EEG, 'rmtime', [0 params_info.dt_i; EEG.xmax-params_info.dt_f EEG.xmax]);
                    EEG.history = [EEG.history newline 'Removed first ' num2str(params_info.dt_i) ' and last ' num2str(params_info.dt_f) ' s'];
                
                elseif EEG.xmax - params_info.dt_f>0
                    [EEG] = pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);
                    EEG.history = [EEG.history newline 'Removed last ' num2str(params_info.dt_f) ' s'];
                else
                    warning('dt_f and dt_i NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING'); 
                end

            elseif params_info.dt_i==0 && params_info.dt_f>0
                if EEG.xmax - params_info.dt_f>0
                    [EEG] = pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);
                    EEG.history = [EEG.history newline 'Removed last ' num2str(params_info.dt_f) ' s'];
                else
                    warning('dt_f NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING');
                end

            elseif params_info.dt_i>0 && params_info.dt_f==0
                if EEG.xmax - params_info.dt_i>0
                    [EEG] = pop_select(EEG, 'rmtime', [0 params_info.dt_i]);
                    EEG.history = [EEG.history newline 'Removed first ' num2str(params_info.dt_i) ' s'];
                else
                    warning('dt_i NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING');
                end
            end
        end
    
        %% Remove baseline 
        if params_info.prep_steps.rmbaseline
            [EEG] = pop_rmbase(EEG, [], []);
            EEG.history = [EEG.history newline 'REMOVE BASELINE FOR EACH CHANNEL'];
        end

        %% Resampling 
        if params_info.prep_steps.resampling
            if params_info.sampling_rate ~= data_info.samp_rate && mod(EEG.srate, 1) == 0
                 [EEG] = pop_resample( EEG, params_info.sampling_rate);
                 EEG.history = [EEG.history newline 'RESAMPLING TO: '  num2str(params_info.sampling_rate) 'Hz'];
                 
            elseif params_info.sampling_rate ~= data_info.samp_rate 
                %This is useful when the sampling rate in the file is
                %corrupted, but the sampling rate expected is known.
                 EEG.srate = data_info.samp_rate;
                 EEG.xmax = EEG.pnts/data_info.samp_rate;
                 [EEG] = pop_resample( EEG, params_info.sampling_rate);
                 EEG.history = [EEG.history newline 'RESAMPLING TO: '  num2str(params_info.sampling_rate) 'Hz'];
            end
        end

        %% Filter the data 
        if params_info.prep_steps.filtering
            [EEG] = pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);
            EEG.history = [EEG.history newline 'FIR FILTERING: '  num2str(params_info.low_freq) '-' num2str(params_info.high_freq) 'Hz'];
        end

        %% Import or generate channel location  
        %It is important to remove the channels first, because the
        %following function eventually uses create_chan_loc.m; here
        %conversion files are used, but non-physiological channels are not
        %present.

        [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, obj_info, L, template_info);

        %% Rereference the data
        if params_info.prep_steps.rereference
            [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B);
        end

        %% ICA
        if params_info.prep_steps.ICA
            [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity, 'lastEig', params_info.n_ica, 'verbose','off');
            EEG.history = [EEG.history newline 'ICA performed'];
        end

        %% ASR 
        if params_info.prep_steps.ASR
            fprintf(' \t\t\t\t\t\t\t\t --- SOFT ASR APPLIED ---\n');
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

            EEG.history = [EEG.history newline 'ASR: FlatLineCriterion ' num2str(params_info.flatlineC) ...
                           ', ChannelCriterion ' num2str(params_info.channelC) ', LineNoiseCriterion ' num2str(params_info.lineC)];

            if max(max(abs(EEG.data)))>params_info.th_reject 
                fprintf(' \t\t\t\t\t\t\t\t --- REMOVE BURST ASR APPLIED ---\n');
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

                EEG.history = [EEG.history newline 'Another ASR: BurstCriterion ' num2str(params_info.burstC) ...
                               ', WindowCriterion ' num2str(params_info.windowC), ', BurstRejection', num2str(params_info.burstR)];

            end
        end

        %% Remove file if after aggressive ASR, still
        if max(max(abs(EEG.data)))>params_info.th_reject 
            %EEG = [];
            %warning(['EEG FILE REJECTED BECAUSE ' num2str(c) ' ASR WERE NOT ENOUGH TO REACH ' num2str(params_info.th_reject/1000) ' mV']);
            warning(['EEG FILE STILL GREATER THAN ' num2str(params_info.th_reject/1000) ' mV']);
        end

        %% Save the .set file 
        if save_info.save_set
           [EEG] = pop_saveset( EEG, 'filename',obj_info.set_preprocessed_filename,'filepath', path_info.set_folder);
           EEG.history = [EEG.history newline 'SAVE .SET FILE: ' path_info.set_folder obj_info.set_preprocessed_filename];        
        end
    end
end
