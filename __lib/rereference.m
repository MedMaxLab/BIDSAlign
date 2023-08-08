
function [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B)

    channel_reference = data_info.channel_reference;
    standard_ref_ch   = params_info.standard_ref;

    %% Create list of available channels --------------------------------
    B_labels = arrayfun(@(x) upper(erase(x.labels, ["." ".."])), B, 'UniformOutput', false);
    listB = string(B_labels);

    %% Reref the data to average reference ------------------------------
    if strcmp(standard_ref_ch,"COMMON")
        if strcmp(channel_reference,"COMMON")
                                                                           %GRAY Nothing to do
        else
            EEG = pop_reref( EEG, [],'keepref','on');                      %BLUE Avg REF.
        end

    else
        %% Check if ref. is in the channel location -------------------------

        if channel_location_file_extension == "bvef"
            A = find(listB=="REF");                                        %A is the index of the dataset channel reference
            if  strcmp(channel_reference,standard_ref_ch)                  %check if they are equal
                C = find(listB=="REF");                                    %C is the index of the standard channel reference
            else
                C = find(listB==standard_ref_ch);
            end
        else
            A = find(listB==channel_reference);
            C = find(listB==standard_ref_ch);
        end

        %% Reref the data to a specific channel------------------------------
        if isempty(C) && ~strcmp(channel_reference,standard_ref_ch)        %RED if current ref is not Cz and Cz is not a present channel => error!
            error("ERROR: NEW REFERENCE CHANNEL NOT REGISTERED");
    
        elseif strcmp(channel_reference,standard_ref_ch)                   %ORANGE if current ref == Cz independently if the channel is present or not => nothing to do

        else                                                               %GREEN if current ref is not Cz, but Cz is a present channel, independently if it has or not the channel ref => reref
            EEG = pop_reref( EEG, C,'keepref','on');
        end

    end
end