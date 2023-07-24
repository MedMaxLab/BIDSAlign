
function [C] = create_chan_loc(EEG, data_info, list_ref, template_info)

    channel_system = convertCharsToStrings(data_info.channel_system);
    
    S = readlocs(data_info.standard_chanloc);
    NchanS = length(S);
    listS = strings(NchanS,1);
    for t = 1:length(S)
        S(t).labels = upper(erase(S(t).labels, ["." ".."]));
        listS(t) = S(t).labels;
    end

    if channel_system == "GSN129" || channel_system == "GSN257"
        listS(listS=="CZ") = convertCharsToStrings(['E' data_info.channel_system(end-2:end)]);
    end

    if isempty(list_ref) 
        Z = EEG.chanlocs;
        NchanZ = length(Z);
        
        % Convert channel labels to uppercase using arrayfun
        Z_labels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), Z, 'UniformOutput', false);
        listZ = string(Z_labels);
    else
        if channel_system == "GSN129" || channel_system == "GSN257"
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

%     
%     if channel_system == "GSN129" || channel_system == "GSN257"
% 
%         listC = strings(NchanZ,1);
%         for i=1:NchanZ
%             listC(i) = upper(C(i).labels);
%         end
%         C(listC=="CZ").labels = ['E' data_info.channel_system(end-2:end)];
%     end


end

