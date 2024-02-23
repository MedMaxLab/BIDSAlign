
function [C] = create_chan_loc(EEG, data_info, list_ref, template_info)
    % FUNCTION: create_chan_loc
    %
    % Description: Creates channel locations based on a 
    %              standard template and a list of channels.
    %
    % Syntax:
    %   [C] = create_chan_loc(EEG, data_info, list_ref, template_info)
    %
    % Input:
    %   - EEG: EEG data structure.
    %   - data_info: Structure containing general information about the dataset.
    %   - list_ref: List of channel names or indices for creating channel locations.
    %   - template_info: Structure containing template information.
    %
    % Output:
    %   - C: Structure containing channel locations.
    %
    % Notes:
    %   - This function creates channel locations by matching the given 
    %     list of channels with a standard template, ensuring compatibility 
    %     and consistency across datasets.
    %
    % Author: [Andrea Zanola]
    % Date: [04/10/2023]
    
    %% Create list of channels from chanloc standard template
    [~,~,ext] = fileparts(template_info.standard_chanloc);
    S = readlocs(template_info.standard_chanloc,'filetype',ext(2:end));
    [S] = rename_channels(S, data_info, false, []);

    [~,listS] = list_chan(S);

    %% Create list of channels from EEG.chanlocs or from list_ref
    if isempty(list_ref) 
        Z = EEG.chanlocs;
        [NchanZ,listZ] = list_chan(Z);
    else
        if isequal(data_info.channel_system, data_info.channel_systems{4}) || ...
                isequal(data_info.channel_system, data_info.channel_systems{5})
            NchanZ = length(list_ref);
            listZ = strings(NchanZ,1);
            for i = 1:NchanZ
                J = find(template_info.conversion(:,1)==list_ref(i));
                listZ(i) = template_info.conversion(J,2);
            end
        else
            listZ  = list_ref;
            NchanZ = length(listZ);
        end
    end

    %% At the end both listZ and listS, have channels name in 10-10 standard
    C = S([]);  
    for i=1:NchanZ
        J = find(listS == listZ(i));
        if isempty(J)
            disp(listZ(i))
            error('ERROR: CHANNEL NAME NOT FOUND IN THE STANDARD TEMPLATE.');
        else
            C(i) = S(J);
        end
    end
end
