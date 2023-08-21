
function [C] = create_chan_loc(EEG, data_info, list_ref, template_info, channel_systems)

    channel_system = convertCharsToStrings(data_info.channel_system);
    
    % Create list of channels from chanloc template
    [~,~,ext] = fileparts(data_info.standard_chanloc);
    S = readlocs(data_info.standard_chanloc,'filetype',ext(2:end));
%     NchanS = length(S);
%     listS = strings(NchanS,1);
%     for t = 1:NchanS
%         S(t).labels = upper(erase(S(t).labels, ["." ".."]));
%         listS(t) = S(t).labels;
%     end

    [S] = rename_channels(S, data_info, channel_systems, false, []);
    NchanS = length(S);
    listS = strings(NchanS,1);
    for t = 1:NchanS
        listS(t) = S(t).labels;
    end



    %convert channel name CZ to E129 or E257 because in conversion file, CZ
    %is mapped to E129/E257
%     if strcmp(channel_system, channel_systems{4}) || strcmp(channel_system, channel_systems{5})
%         listS(listS=="CZ") = convertCharsToStrings(['E' data_info.channel_system(end-2:end)]);
%     end

    % Create list of channels from EEG.chanlocs
    if isempty(list_ref) 
        Z = EEG.chanlocs;
        NchanZ = length(Z);
        listZ = strings(NchanZ,1);
        for t = 1:NchanZ
            listZ(t) = Z(t).labels;
        end
        NchanZ = length(Z);
        
        % Here there is no need for check the channel system, because
        % list_ref or it is empty or it is the template
        %Z_labels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), Z, 'UniformOutput', false);
        %listZ = string(Z_labels);
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

    %At the end both listZ and listS, have channels name in 10-10 standard
    C = S([]);  
    for i=1:NchanZ
        J = find(listS == listZ(i));
        if isempty(J)
            disp(listZ(i));
            error('ERROR: CHANNEL NAME NOT FOUND IN THE STANDARD TEMPLATE: ');
        else
            C(i) = S(J);
        end
    end


end

