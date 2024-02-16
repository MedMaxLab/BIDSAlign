function [EEG] = prepstep_resampling(EEG, data_info, params_info, verbose)
% FUNCTION: prepstep_resampling
%
% Description: Resamples EEG data to the specified sampling rate if necessary.
%
% Syntax:
%   [EEG] = prepstep_resampling(EEG, data_info, params_info, verbose)
%
% Input:
%   - EEG (struct): EEG data structure.
%   - data_info (struct): Struct containing information about the data, including the original sampling rate.
%   - params_info (struct): Struct containing preprocessing parameters, including the target sampling rate.
%   - verbose (logical): Verbosity flag indicating whether to display information during processing.
%
% Output:
%   - EEG (struct): Processed EEG data structure.
%
% Author: [Andrea Zanola]
% Date: [16/02/2024]

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