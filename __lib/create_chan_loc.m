
% Function: create_chan_loc
% Description: Create a new channel location structure based on given inputs.
% This function generates a new channel location structure based on the
% provided EEG data, dataset-specific information, and reference channels.
%
% Inputs:
%   - EEG: EEG structure containing channel information.
%   - data_info: Struct containing dataset-specific information.
%   - list_ref: List of reference channels to use for creating the new channel location structure.
%   - template_info: Struct containing channel template information.
%   - channel_systems: Cell array of supported channel systems.
%
% Output:
%   - C: New channel location structure containing only the specified channels.
%
% Usage example:
%   C = create_chan_loc(EEG, data_info, list_ref, template_info, channel_systems);
%
% Notes:
%   - This function creates a new channel location structure based on the provided inputs
%     and ensures that the resulting structure contains only the specified channels.
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]

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

function [C] = create_chan_loc(EEG, data_info, list_ref, template_info, channel_systems)

    channel_system = convertCharsToStrings(data_info.channel_system);
    
    %% Create list of channels from chanloc standard template
    [~,~,ext] = fileparts(data_info.standard_chanloc);
    S = readlocs(data_info.standard_chanloc,'filetype',ext(2:end));
    [S] = rename_channels(S, data_info, channel_systems, false, []);

    [~,listS] = list_chan(S);

    %% Create list of channels from EEG.chanlocs or from list_ref
    if isempty(list_ref) 
        Z = EEG.chanlocs;
        [NchanZ,listZ] = list_chan(Z);
    else
        if strcmp(channel_system, channel_systems{4}) || strcmp(channel_system, channel_systems{5})
            NchanZ = length(list_ref);
            listZ = strings(NchanZ,1);
            for i = 1:NchanZ
                J = find(template_info.conversion(:,1)==list_ref(i));
                listZ(i) = template_info.conversion(J,2);
            end
        else
            listZ = list_ref;
            NchanZ = length(listZ);
        end
        
    end

    %% At the end both listZ and listS, have channels name in 10-10 standard
    C = S([]);  
    for i=1:NchanZ
        J = find(listS == listZ(i));
        if isempty(J)
            %disp(listZ(i));
            error('ERROR: CHANNEL NAME NOT FOUND IN THE STANDARD TEMPLATE: ');
        else
            C(i) = S(J);
        end
    end

end

function [NchanB,listB] = list_chan(B)
    NchanB = length(B);
    listB = strings(NchanB,1);
    for t = 1:NchanB
        listB(t) = B(t).labels;
    end
end
