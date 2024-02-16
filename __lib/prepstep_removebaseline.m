function [EEG] = prepstep_removebaseline(EEG, params_info, verbose)
    % FUNCTION: prepstep_removebaseline
    %
    % Description: Removes baseline for each channel in EEG data if specified in the preprocessing parameters.
    %
    % Syntax:
    %   [EEG] = prepstep_removebaseline(EEG, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - verbose (logical): Verbosity flag indicating whether to display information during processing.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [16/02/2024]

    if params_info.prep_steps.rmbaseline
        if verbose
            [EEG] = pop_rmbase(EEG, [], []);
        else
            [~,EEG] = evalc("pop_rmbase(EEG, [], []);");
        end
        EEG.history = [EEG.history newline 'REMOVE BASELINE FOR EACH CHANNEL'];
    end
end