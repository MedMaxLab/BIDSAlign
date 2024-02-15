function [EEG] = prepstep_interpolation(EEG, params_info, B, nchan_preASR, verbose)

    if nchan_preASR > EEG.nbchan
        if verbose
            [EEG] = pop_interp(EEG, B, params_info.interpol_method); 
        else
            [~, EEG] = evalc('pop_interp(EEG, B, params_info.interpol_method);');
        end
        EEG.history = [EEG.history newline 'INTERPOLATION OF REMOVED CHANNELS BY ASR - method: ' params_info.interpol_method];
    end
end