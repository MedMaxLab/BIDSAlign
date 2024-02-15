
function [EEG] = prepstep_removechannels(EEG, data_info, params_info, verbose)

    if ~isempty(data_info.channel_to_remove{1}) && params_info.prep_steps.rmchannels
        if verbose
            [EEG] = pop_select(EEG, 'rmchannel', data_info.channel_to_remove);
        else
            [ ~, EEG] = evalc("pop_select(EEG, 'rmchannel', data_info.channel_to_remove);");
        end
        EEG.history = [EEG.history newline 'REMOVE CHANNELS: '  strjoin(data_info.channel_to_remove)];
    end

end