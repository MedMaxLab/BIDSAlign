function params_info = set_preprocessing_info(varargin)
    % FUNCTION: set_preprocessing_info
    %
    % Description: Sets or updates the preprocessing parameters for the 
    %              EEG processing pipeline.
    %
    % Syntax:
    %   params_info = set_preprocessing_info(varargin)
    %
    % Input:
    %   - varargin (optional): A list of parameter-value pairs for customizing 
    %                          the preprocessing parameters.
    %
    % Output:
    %   - params_info (struct): A struct containing the preprocessing parameters.
    %
    % Parameters:
    %   - low_freq (scalar): Low-pass filter frequency(default: 0.1 Hz).
    %   - high_freq (scalar): High-pass filter frequency (default: 49 Hz).
    %   - sampling_rate (scalar): EEG data sampling rate (default: 250 Hz).
    %   - standard_ref (char): Standard reference type (default: 'COMMON').
    %   - interpol_method (char): Interpolation method (default: 'spherical').
    %   - flatlineC (scalar): Flatline detection threshold for ASR (default: 5).
    %   - channelC (scalar): Channel correlation threshold for ASR (default: 0.8).
    %   - lineC (scalar): Line noise correlation threshold for ASR (default: 4).
    %   - burstC (scalar): Burst correction threshold for ASR (default: 20).
    %   - windowC (scalar): Window length for ASR burst correction (default: 0.25).
    %   - burstR (char): Burst correction rule for ASR (default: 'on').
    %   - th_reject (scalar): Amplitude threshold for ASR (default: 1000 uV).
    %   - ica_type (char): ICA algorithm type (default: 'fastica').
    %   - non_linearity (char): Non-linearity option for ICA (default: 'tanh').
    %   - n_ica (scalar): Number of components for ICA (default: 20).
    %   - ic_rej_type (char): IC rejection algorithm. Can be 'mara' or
    %                                  'iclabel' (default: 'iclabel')
    %   - mara_thresholds (scalar): scalar with the MARA's rejection threshold 
    %                               (default: 0.5)
    %   - iclabel_thresholds (matrix): 7x2 array with threshold values with limits to include 
    %                         for selection as artifacts
    %   - dt_i (scalar): Start time for segment removal (default: 0 s).
    %   - dt_f (scalar): End time for segment removal (default: 0 s).
    %   - rmchannels (logical): Flag for channel removal (default: true).
    %   - rmsegments (logical): Flag for segment removal (default: true).
    %   - rmbaseline (logical): Flag for baseline removal (default: true).
    %   - resampling (logical): Flag for resampling (default: true).
    %   - filtering (logical): Flag for filtering (default: true).
    %   - rereference (logical): Flag for rereferencing (default: true).
    %   - ICA (logical): Flag for performing ICA (default: false).
    %   - ICrejection (logical): Flag for performing IC rejection via ICLabel 
    %                            (default: false).
    %   - ASR (logical): Flag for performing ASR (default: false).
    %   - store_settings (logical): Flag for storing settings (default: false).
    %   - setting_name (char): Name of the setting if storing settings 
    %                          (default: 'default').
    %
    % Author: [Federico Del Pup]
    % Date: [27/01/2024]
    %

    defaultFilterLow = 0.1;
    defaultFilterHigh = 49;
    defaultSamplingRate = 250;
    defaultStandardRef = 'COMMON';
    defaultInterpolation = 'spherical';
    
    defaultASRflatlineC= 5;
    defaultASRchannelC= 0.8;
    defaultASRlineC = 4;
    defaultASRburstC = 20;
    defaultASRwindowC = 0.25;
    defaultASRburstR = 'on';
    defaultASRamplitude = 1000;
    
    defaultICAtype = 'fastica';
    defaultICAnonLinearity= 'tanh';
    defaultICAnica = 20;
    defaultICRejType = 'mara';
    defaultMaraThresh = 0.5;
    defaultIClabelthresh = [0 0; 0.9 1; 0.9 1;  0.9 1;  0.9 1;  0.9 1;  0.9 1];
    
    defaultwICA_level = 5;
    defaultwICA_type = 'coif5';
    
    defaultdtstart = 0;
    defaultdtend = 0;
    
    defaultDoChannelRemoval = true;
    defaultDoSegmentsRemoval = true;
    defaultDoResampling = true;
    defaultDoBaselineRemoval= true;
    defaultDoFiltering = true;
    defaultDoRereferencing = true;
    defaultDoICA = false;
    defaultDoICrejection = false;
    defaultDowICA = false;
    defaultDoASR = false;
    
    defaultStoreSettings= false;
    defaultSettingName = 'default';
    defaultParamInfo= struct;

    
    p = inputParser;
    validStringChar= @(x) isstring(x) || ischar(x);
    validBool= @(x) islogical(x);
    validScalar = @(x) isscalar(x);
    validScalarInt = @(x) isscalar(x) && mod(x,1)==0;
    validStruct = @(x) isstruct(x);
    validNumeric72= @(x) isnumeric(x) && isequal(size(x), [7 2]);
    validICEntry = @(x) strcmpi(x, 'mara') || strcmpi(x, 'iclabel');
    
    p.addOptional('params_info',         defaultParamInfo,         validStruct);
    
    p.addParameter('low_freq',           defaultFilterLow,         validScalar);
    p.addParameter('high_freq',          defaultFilterHigh,        validScalar);
    p.addParameter('sampling_rate',      defaultSamplingRate,      validScalar);
    p.addParameter('standard_ref',       defaultStandardRef,       validStringChar);
    p.addParameter('interpol_method',    defaultInterpolation,     validStringChar);
    
    p.addParameter('flatlineC',          defaultASRflatlineC,      validScalar);
    p.addParameter('channelC',           defaultASRchannelC,       validScalar);
    p.addParameter('lineC',              defaultASRlineC,          validScalar);
    p.addParameter('burstC',             defaultASRburstC,         validScalar);
    p.addParameter('windowC',            defaultASRwindowC,        validScalar);
    p.addParameter('burstR',             defaultASRburstR,         validStringChar);
    p.addParameter('th_reject',          defaultASRamplitude,      validScalar);
      
    p.addParameter('ica_type',           defaultICAtype,           validStringChar);
    p.addParameter('non_linearity',      defaultICAnonLinearity,   validStringChar);
    p.addParameter('n_ica',              defaultICAnica,           validScalarInt);
    p.addParameter('ic_rej_type',        defaultICRejType,         validICEntry);
    p.addParameter('mara_threshold',     defaultMaraThresh,        validScalar);
    p.addParameter('iclabel_thresholds', defaultIClabelthresh,     validNumeric72);

    p.addParameter('wavelet_type',       defaultwICA_type,         validStringChar);
    p.addParameter('wavelet_level',      defaultwICA_level,        validScalarInt);
    
    p.addParameter('dt_i',               defaultdtstart,           validScalar);
    p.addParameter('dt_f',               defaultdtend,             validScalar);
    
    p.addParameter('rmchannels',         defaultDoChannelRemoval,  validBool);
    p.addParameter('rmsegments',         defaultDoSegmentsRemoval, validBool);
    p.addParameter('rmbaseline',         defaultDoBaselineRemoval, validBool);
    p.addParameter('resampling',         defaultDoResampling,      validBool);
    p.addParameter('filtering',          defaultDoFiltering,       validBool);
    p.addParameter('rereference',        defaultDoRereferencing,   validBool);
    p.addParameter('ICA',                defaultDoICA,             validBool);
    p.addParameter('ICrejection',        defaultDoICrejection,     validBool);
    p.addParameter('ASR',                defaultDoASR,             validBool);
    p.addParameter('wICA',               defaultDowICA,            validBool);
    
    p.addParameter('store_settings',     defaultStoreSettings,     validBool);
    p.addParameter('setting_name',       defaultSettingName,       validStringChar);
    parse(p, varargin{:});

    % Create a struct to store the save information                            
    % Set the parameters for preprocessing
    if  ~isempty(fieldnames(p.Results.params_info)) &&  ...
            isempty( setdiff(fieldnames(p.Results.params_info),...
            [p.Parameters'; 'prep_steps']) )
        
        prepsteps = { 
            'rmchannels', ...
            'rmsegments'  , ...
            'rmbaseline' , ...
            'resampling', ...
            'filtering', ...
            'rereference', ...
            'ICA', ...
            'ICrejection', ...
            'ASR', ...
            'wICA'
        };

        param2set = setdiff( setdiff( p.Parameters, ...
            {'setting_name' 'store_settings'}), [p.UsingDefaults 'params_info']);
        params_info = p.Results.params_info;
        
        for i = 1:length(param2set)
            if ~any(strcmp(prepsteps,param2set{i}))
                params_info.(param2set{i}) = p.Results.(param2set{i});
            else
                params_info.prep_steps.(param2set{i}) = p.Results.(param2set{i});
            end   
        end     
        
    else
        params_info = struct( ...
            'low_freq',                p.Results.low_freq,...           % filtering                              
            'high_freq',               p.Results.high_freq , ...        % filtering
            'sampling_rate',           p.Results.sampling_rate , ...    % resampling
            'standard_ref',            p.Results.standard_ref , ...     % standardref
            'interpol_method',         p.Results.interpol_method ,...   % interp
            'flatlineC',               p.Results.flatlineC ,...         % 1 ASR
            'channelC',                p.Results.channelC ,...          % 1 ASR
            'lineC',                   p.Results.lineC , ...            % 1 ASR
            'burstC',                  p.Results.burstC ,...            % 2 ASR
            'windowC',                 p.Results.windowC ,...           % 2 ASR
            'burstR',                  p.Results.burstR ,...            % 2 ASR
            'th_reject',               p.Results.th_reject ,...         % ASR threshold
            'ica_type',                p.Results.ica_type ,...          % ICA
            'non_linearity',           p.Results.non_linearity ,...     % ICA
            'n_ica',                   p.Results.n_ica ,...             % ICA
            'ic_rej_type',             p.Results.ic_rej_type ,...       % ICA
            'mara_threshold',          p.Results.mara_threshold, ...    % ICA
            'iclabel_thresholds',      p.Results.iclabel_thresholds,... % ICA
            'wavelet_type',            p.Results.wavelet_type, ...      % wICA
            'wavelet_level',           p.Results.wavelet_level, ...     % wICA
            'dt_i',                    p.Results.dt_i ,...              % start removal
            'dt_f',                    p.Results.dt_f ,...              % end removal
            'prep_steps', struct( ...  % preprocessing steps to do
                       'rmchannels'  , p.Results.rmchannels ,...
                       'rmsegments'  , p.Results.rmsegments ,...
                       'rmbaseline'  , p.Results.rmbaseline ,...
                       'resampling'  , p.Results.resampling ,...
                       'filtering'   , p.Results.filtering,...
                       'rereference' , p.Results.rereference,...
                       'ICA'         , p.Results.ICA,...
                       'ICrejection' , p.Results.ICrejection, ...
                       'wICA'        , p.Results.wICA, ...  
                       'ASR'         , p.Results.ASR ) ...
        );
    end
    
    % additional conversion for chars with upper or lower
    params_info.wavelet_type    = lower( params_info.wavelet_type );
    params_info.ic_rej_type     = lower( params_info.ic_rej_type );
    params_info.standard_ref    = upper( params_info.standard_ref);
    params_info.ica_type        = lower( params_info.ica_type);
    params_info.non_linearity   = lower(params_info.non_linearity);
    params_info.interpol_method = lower(params_info.interpol_method);

    % run check to assess if everything is ok
    check_preprocessing_info(params_info);
    
    % store settings if asked to do so
    if p.Results.store_settings
        filePath = mfilename('fullpath');
        if not( isfolder( [filePath(1:length(filePath)-22) ...
                filesep 'default_settings' filesep p.Results.setting_name]) )
            mkdir( [filePath(1:length(filePath)-22) ...
                filesep 'default_settings' filesep] , p.Results.setting_name)
        end
        save( [ filePath(1:length(filePath)-22)  filesep 'default_settings' filesep ...
            p.Results.setting_name filesep 'preprocessing_info.mat'], 'params_info');
    end

end
