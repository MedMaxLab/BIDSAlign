function [EEG] = prepstep_filtering(EEG, params_info, verbose)

    if params_info.prep_steps.filtering
        if verbose
            [EEG] = pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);
        else
            [~,EEG] = evalc("pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);");
        end
        EEG.history = [EEG.history newline 'FIR FILTERING: '  num2str(params_info.low_freq) '-' num2str(params_info.high_freq) 'Hz'];
    end
end