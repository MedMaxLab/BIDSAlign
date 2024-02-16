function [EEG] = prepstep_filtering(EEG, params_info, verbose)
% FUNCTION: prepstep_filtering
%
% Description: Applies FIR filtering to EEG data.
%
% Syntax:
%   [EEG] = prepstep_filtering(EEG, params_info, verbose)
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

    if params_info.prep_steps.filtering
        if verbose
            [EEG] = pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);
        else
            [~,EEG] = evalc("pop_eegfiltnew(EEG, 'locutoff', params_info.low_freq, 'hicutoff', params_info.high_freq);");
        end
        EEG.history = [EEG.history newline 'FIR FILTERING: '  num2str(params_info.low_freq) '-' num2str(params_info.high_freq) 'Hz'];
    end
end