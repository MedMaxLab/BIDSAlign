
function [NchanB,listB] = list_chan(B)
    % FUNCTION: list_chan
    %
    % Description: Lists channel labels from a structure containing channel information.
    %
    % Syntax:
    %   [NchanB, listB] = list_chan(B)
    %
    % Input:
    %   - B: Structure containing information about channel locations.
    %
    % Output:
    %   - NchanB: Number of channels.
    %   - listB: List of channel labels.
    %
    % Author: [Andrea Zanola]
    % Date: [25/01/2024]
    %
    
    NchanB = length(B);
    listB = strings(NchanB,1);
    for t = 1:NchanB
        listB(t) = B(t).labels;
    end
end