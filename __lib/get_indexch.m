
function [list_index, ch_considered] = get_indexch(listB, list_channels)
    % FUNCTION: get_indexch
    %
    % Description: Get indices of channels from a list of channel names.
    %
    % Syntax:
    %   [list_index, ch_considered] = get_indexch(listB, list_channels)
    %
    % Input:
    %   - listB (cell array): List of all channel names.
    %   - list_channels (cell array): List of channel names to search for.
    %
    % Output:
    %   - list_index (numeric array): Indices of channels found in listB.
    %   - ch_considered (cell array): List of channel names found in both listB and list_channels.
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]
    %
    % Examples:
    %   [list_index, ch_considered] = get_indexch({'FZ', 'CZ', 'PZ'}, {'FZ', 'PZ'})

    list_index = [];
    ch_considered = [];
    for i = 1:length(list_channels)
        index = find(listB==list_channels(i));
        if ~isempty(index)
            list_index = [list_index,index];
            ch_considered = [ch_considered, list_channels(i)];
        end
    end
end