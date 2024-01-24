function params_info = set_preprocessing_info(varargin)

% Da completare la descrizione delle variabili

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
    defaultASRamplitudeThresh = 1000;
    
    defaultICAtype = 'fastica';
    defaultICAnonLinearity= 'tanh';
    defaultICAnica = 20;
    
    defaultdtstart = 0;
    defaultdtend = 0;
    
    defaultDoChannelRemoval = true;
    defaultDoSegmentsRemoval = true;
    defaultDoResampling = true;
    defaultDoBaselineRemoval= true;
    defaultDoFiltering = true;
    defaultDoRereferencing = true;
    defaultDoICA = false;
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
    
    p.addOptional('params_info', defaultParamInfo, validStruct);
    
    p.addParameter('low_freq', defaultFilterLow, validScalar);
    p.addParameter('high_freq', defaultFilterHigh, validScalar);
    p.addParameter('sampling_rate', defaultSamplingRate, validScalar);
    p.addParameter('standard_ref', defaultStandardRef, validStringChar);
    p.addParameter('interpol_method', defaultInterpolation, validStringChar);
    
    p.addParameter('flatlineC', defaultASRflatlineC, validScalar);
    p.addParameter('channelC', defaultASRchannelC, validScalar);
    p.addParameter('lineC', defaultASRlineC, validScalar);
    p.addParameter('burstC', defaultASRburstC, validScalar);
    p.addParameter('windowC', defaultASRwindowC, validScalar);
    p.addParameter('burstR', defaultASRburstR, validStringChar);
    p.addParameter('th_reject', defaultASRamplitudeThresh, validScalar);
      
    p.addParameter('ica_type', defaultICAtype, validStringChar);
    p.addParameter('non_linearity', defaultICAnonLinearity, validStringChar);
    p.addParameter('n_ica', defaultICAnica, validScalarInt);
    
    p.addParameter('dt_i', defaultdtstart, validScalar);
    p.addParameter('dt_f', defaultdtend, validScalar);
    
    p.addParameter('rmchannels', defaultDoChannelRemoval, validBool);
    p.addParameter('rmsegments', defaultDoSegmentsRemoval, validBool);
    p.addParameter('rmbaseline', defaultDoBaselineRemoval, validBool);
    p.addParameter('resampling', defaultDoResampling, validBool);
    p.addParameter('filtering', defaultDoFiltering, validBool);
    p.addParameter('rereference', defaultDoRereferencing, validBool);
    p.addParameter('ICA', defaultDoICA, validBool);
    p.addParameter('ASR', defaultDoASR, validBool);
    
    p.addParameter('store_settings', defaultStoreSettings, validBool);
    p.addParameter('setting_name', defaultSettingName, validStringChar);
    parse(p, varargin{:});

    % Create a struct to store the save information                            
    % Set the parameters for preprocessing
    if  ~isempty(fieldnames(p.Results.params_info)) &&  ...
            isempty( setdiff(fieldnames(p.Results.params_info), [p.Parameters'; 'prep_steps']) )
        
        prepsteps = { 'rmchannels', 'rmsegments'  , 'rmbaseline' , 'resampling','filtering', 'rereference' , 'ICA' ,'ASR'  };
        param2set = setdiff( setdiff( p.Parameters, {'setting_name' 'standard_ref'}), ...
            [p.UsingDefaults 'params_info']);
        params_info = p.Results.params_info;
        for i = 1:length(param2set)
            if ~any(strcmp(prepsteps,param2set{i}))
                params_info.(param2set{i}) = p.Results.(param2set{i});
            else
                params_info.prep_steps.(param2set{i}) = p.Results.(param2set{i});
            end   
        end     
        
    else
        params_info = struct('low_freq', p.Results.low_freq,...                                    %filtering                              
                                         'high_freq',p.Results.high_freq , ...                                  %filtering
                                         'sampling_rate', p.Results.sampling_rate , ...                   %resampling
                                         'standard_ref', p.Results.standard_ref , ...                      %standard ref
                                         'interpol_method', p.Results.interpol_method ,...             %interpolation
                                         'flatlineC', p.Results.flatlineC ,...                                       %1° ASR
                                         'channelC', p.Results.channelC ,...                                   %1° ASR
                                         'lineC', p.Results.lineC , ...                                                %1° ASR
                                         'burstC',p.Results.burstC ,...                                           %2° ASR
                                         'windowC', p.Results.windowC ,...                                   %2° ASR
                                         'burstR', p.Results.burstR ,...                                          %2° ASR
                                         'th_reject',p.Results.th_reject ,...                                      %amplitude threshold uV
                                         'ica_type',p.Results.ica_type ,...                                       %ICA
                                         'non_linearity',p.Results.non_linearity ,...                          %ICA
                                         'n_ica',p.Results.n_ica ,...                                                 %ICA
                                         'dt_i',p.Results.dt_i ,...                                                      %segment removal [s]
                                         'dt_f',p.Results.dt_f ,...                                                     %segment removal [s]
                                         'prep_steps', struct( ...                                                     %preprocessing steps to do
                                                                'rmchannels'    , p.Results.rmchannels ,...
                                                                 'rmsegments'  , p.Results.rmsegments ,...
                                                                 'rmbaseline'     , p.Results.rmbaseline ,...
                                                                 'resampling'     , p.Results.resampling ,...
                                                                 'filtering'           , p.Results.filtering,...
                                                                 'rereference'    , p.Results.rereference,...
                                                                 'ICA'                 , p.Results.ICA,...
                                                                 'ASR'                , p.Results.ASR ) );
    end
         
    check_preprocessing_info(params_info);
    % store settings if asked to do so
    if p.Results.store_settings
        filePath = mfilename('fullpath');
        if not( isfolder( [filePath(1:length(filePath)-22)  '/default_settings/' p.Results.setting_name]) )
            mkdir( [filePath(1:length(filePath)-22)  '/default_settings/'] , p.Results.setting_name)
        end
        save( [ filePath(1:length(filePath)-22)  '/default_settings/' p.Results.setting_name '/preprocessing_info.mat'], 'params_info');
    end

end
