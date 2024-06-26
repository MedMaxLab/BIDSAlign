function [EEG] = prepstep_interpolation(EEG, params_info, B, nchan_preASR, verbose)
    % FUNCTION: prepstep_interpolation
    %
    % Description: Applies channel interpolation to EEG data if the number of channels
    %              after ASR exceeds the original number of channels.
    %
    % Syntax:
    %   [EEG] = prepstep_interpolation(EEG, params_info, B, nchan_preASR, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - B (struct): Channel Location structure.
    %   - nchan_preASR (numeric): Number of channels before first step ASR (bad-channel removal).
    %   - verbose (logical): Setting the verbosity level.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [16/02/2024]

    if nchan_preASR > EEG.nbchan
        if verbose
            [EEG] = pop_interp(EEG, B, params_info.interpol_method); 
        else
            [~, EEG] = evalc('pop_interp(EEG, B, params_info.interpol_method);');
        end
        EEG.history = [EEG.history newline ...
            'INTERPOLATION OF REMOVED CHANNELS BY ASR - method: ' ...
            params_info.interpol_method];
    end
end