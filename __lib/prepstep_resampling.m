function [EEG] = prepstep_resampling(EEG, data_info, params_info, verbose)

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
end