function [EEG] = prepstep_notchfiltering(EEG, params_info, data_info, obj_info, verbose)
    % FUNCTION: prepstep_notchfiltering
    %
    % Description: Applies Notch FIR filtering to EEG data.
    %
    % Syntax:
    %   [EEG] = prepstep_filtering(EEG, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - data_info (structure): Structure containing information about the EEG dataset.
    %   - obj_info (struct): Structure containing information about the EEG data file.
    %   - verbose (logical): Setting the verbosity level.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [09/07/2024]

    if params_info.prep_steps.notchfiltering

        if ~isnan(data_info.line_noise)
            linenoise = data_info.line_noise;

        elseif ~isnan(obj_info.PowerLineFrequency)
            linenoise = obj_info.PowerLineFrequency;

        elseif params_info.notchfreq>0
            linenoise = params_info.notchfreq;
        else
            error('Notch Filter required, but Notch Frequency missing.')
        end

        locutoff = linenoise-params_info.notchfreq_bw/2;
        hicutoff = linenoise+params_info.notchfreq_bw/2;

        if verbose
            [EEG] = pop_eegfiltnew(EEG,'revfilt',1,'locutoff',locutoff,'hicutoff',hicutoff);
        else
            cmd2run = "pop_eegfiltnew(EEG,'revfilt',1,'locutoff',locutoff,'hicutoff',hicutoff);";
            [~,EEG] = evalc(cmd2run);
        end
        EEG.history = [EEG.history newline 'FIR NOTCH FILTERING: ' ...
            num2str(locutoff) '-' num2str(hicutoff) 'Hz'];
    end
end

