function [NchanB,listB] = list_chan(B)
% Function: list_chan
% Description: Extract channel labels from a channel location structure.
%
% This function extracts the channel labels from a given channel location structure.
%
% Inputs:
%   - B: Channel location structure.
%
% Outputs:
%   - NchanB: Number of channels in the structure.
%   - listB: Cell array of channel labels.
%
% Usage example:
%   [NchanB, listB] = list_chan(B);
%
% Notes:
%   - This function retrieves channel labels from a channel location structure.
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]

    NchanB = length(B);
    listB = strings(NchanB,1);
    for t = 1:NchanB
        listB(t) = B(t).labels;
    end
end