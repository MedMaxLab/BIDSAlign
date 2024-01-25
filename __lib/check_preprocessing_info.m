function [] = check_preprocessing_info(params_info)
    % FUNCTION: check_preprocessing_info
    %
    % Description: Validates the parameters provided in the params_info structure for preprocessing.
    %
    % Syntax:
    %   check_preprocessing_info(params_info)
    %
    % Input:
    %   - params_info: Structure containing parameters for preprocessing.
    %
    % Output: 
    %   - None. It throws an error if any parameter is invalid.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %

    bool_args = { 'rmchannels', 'rmsegments', 'rmbaseline', ...
                            'resampling', 'filtering',  'rereference','ICA','ASR'};
    channel_list = load('full_channel_list.mat');

    validScalarInt = @(x) isscalar(x) && mod(x,1)==0;
    validStringChar= @(x) isstring(x) || ischar(x);
    
    % check that filter params are ok
    if ~isscalar(params_info.low_freq) || ~isscalar(params_info.high_freq)
        error('low_req and high_freq must be scalar values')
    else
        if params_info.low_freq < 0 
            error(' low_freq must be bigger than 0')
        end

        if params_info.high_freq < 0 
            error(' high_freq must be bigger than 0')
        end

        if params_info.low_freq > params_info.low_freq 
            error(' high_freq must be bigger than low_freq')
        end

        if params_info.sampling_rate < 0 
            error(' sampling_rate must be bigger than 0')
        end
    end
    
    % check that standar rereferencing is ok
    if ~validStringChar(params_info.standard_ref)
        error('standard_ref must be a string or a char array')
    else
        if  ~ (strcmp(params_info.standard_ref, 'COMMON') || any(strcmp(params_info.standard_ref, channel_list )))
            error("standard_ref must be 'COMMON' or a valid channel ")
        end
    end
    
    % check that interpolation method is one of the three allowed
    if ~validStringChar(params_info.interpol_method)
        error('interpol_method must be a string or a char array')
    else
        if ~any(strcmp(params_info.interpol_method, {'invdist' 'spherical' 'spacetime'}))
            error("interpol_method args allowed are 'invdist', 'spherical', 'spacetime' ")
        end
    end
    
    if ~isscalar(params_info.flatlineC)
        error('flatlineC must be a scalar value')
    else
        if params_info.flatlineC < 0 
            error(' flatlineC must be bigger than 0')
        end
    end
    
    if ~isscalar(params_info.channelC)
        error('channelC must be a scalar value')
    else
        if params_info.channelC < 0 || params_info.channelC > 1
            error(' channelC must be in range [0 1]')
        end
    end
    
    if ~isscalar(params_info.lineC)
        error('lineC must be a scalar value')
    else
        if params_info.lineC < 0
            error(' lineC must be bigger than 0')
        end
    end
    
    if ~isscalar(params_info.burstC)
        error('burstC must be a scalar value')
    else
        if params_info.burstC < 0
            error(' burstC must be bigger than 0')
        end
    end
    
    if ~isscalar(params_info.windowC)
        error('windowC must be a scalar value')
    else
        if params_info.windowC < 0 || params_info.windowC > 1
            error(' windowC must be in range [0 1]')
        end
    end
    
    
    if ~validStringChar(params_info.burstR)
        error('burstR must be a string or a char array')
    else
        if ~any(strcmp(params_info.burstR, {'on', 'off'}))
            error("burstR args allowed are 'on', 'off' ")
        end
    end
    
    if ~isscalar(params_info.th_reject)
        error('th_reject must be a scalar value')
    else
        if params_info.th_reject < 0
            error(' th_reject must be bigger than 0')
        end
    end
    
    
    if ~validStringChar(params_info.ica_type)
        error('ica_type must be a string or a char array')
    else
        if ~any(strcmp(params_info.ica_type, {'runica', 'binica', 'jader', 'fastica'}))
            error("ica_type args allowed are 'runica', 'binica', 'jader', 'fastica' ")
        end
    end
    
    if ~validStringChar(params_info.non_linearity)
        error('non_linearity must be a string or a char array')
    else
        if ~any(strcmp(params_info.non_linearity, {'pow3', 'tanh', 'gauss', 'skew'}))
            error("non_linearity args allowed are  'pow3', 'tanh', 'gauss', 'skew' ")
        end
    end
    
    
    if ~validScalarInt(params_info.n_ica)
        error('n_ica must be a scalar integer value')
    else
        if params_info.n_ica < 0
            error(' n_ica must be bigger than 0')
        end
    end
    
    if ~isscalar(params_info.dt_i)
        error('dt_i must be a scalar value')
    else
        if params_info.dt_i < 0
            error(' dt_i must be bigger than 0')
        end
    end
    
    if ~isscalar(params_info.dt_f)
        error('dt_f must be a scalar value')
    else
        if params_info.dt_f < 0
            error(' dt_f must be bigger than 0')
        end
    end
    
    for i=1:length(bool_args)
        
        if ~islogical(params_info.prep_steps.( bool_args{i} ) )
            error([bool_args{i} ' must be a boolean'])
        end
        
    end
    
end