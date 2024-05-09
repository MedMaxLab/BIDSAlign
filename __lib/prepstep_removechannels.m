
function [EEG] = prepstep_removechannels(EEG, data_info, params_info, verbose)
    % FUNCTION: prepstep_removechannels
    %
    % Description: Removes specified channels from EEG data 
    %              if specified in the preprocessing parameters.
    %
    % Syntax:
    %   [EEG] = prepstep_removechannels(EEG, data_info, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - data_info (struct): Struct containing information about data, 
    %                         including channels to remove.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - verbose (logical): Setting the verbosity level.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [16/02/2024]

    if ~isempty(data_info.channel_to_remove{1}) && params_info.prep_steps.rmchannels
        if verbose
            [EEG] = pop_select(EEG, 'rmchannel', data_info.channel_to_remove);
        else
            cmd2run = "pop_select(EEG, 'rmchannel', data_info.channel_to_remove);";
            [ ~, EEG] = evalc(cmd2run);
        end
        EEG.history = [EEG.history newline 'REMOVE CHANNELS: ' ...
            strjoin(data_info.channel_to_remove)];
    end

end