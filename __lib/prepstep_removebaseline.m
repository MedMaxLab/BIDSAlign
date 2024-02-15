function [EEG] = prepstep_removebaseline(EEG, params_info, verbose)

    if params_info.prep_steps.rmbaseline
        if verbose
            [EEG] = pop_rmbase(EEG, [], []);
        else
            [~,EEG] = evalc("pop_rmbase(EEG, [], []);");
        end
        EEG.history = [EEG.history newline 'REMOVE BASELINE FOR EACH CHANNEL'];
    end
end