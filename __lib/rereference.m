
function [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B)

    dataset_reference  = data_info.channel_reference;
    standard_reference = params_info.standard_ref;

    %% Create list of available channels --------------------------------
    %disp(B(1))
    NchanB = length(B);
    listB = strings(NchanB,1);
    for t = 1:NchanB
        listB(t) = B(t).labels;
    end

    %% Reref the data to average reference ------------------------------
    if strcmp(standard_reference,"COMMON")
        if strcmp(dataset_reference,"COMMON")
            %Table III: H) nothing to do                                                            
        else
            %Table III: G) common reref + if required interpolate channel T and/or channel S  
            EEG = pop_reref( EEG, [],'keepref','on');                      
            EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' convertStringsToChars(standard_reference) ];
        end

    else
        %% Check if ref. is in the channel location -------------------------
        if channel_location_file_extension == "bvef"
            A = find(listB=="REF");                                        %A is the index of the dataset channel reference
            if  strcmp(dataset_reference,standard_reference)                  %check if they are equal
                C = find(listB=="REF");                                    %C is the index of the standard channel reference
            else
                C = find(listB==standard_reference);
            end
        else
            A = find(listB==dataset_reference);
            C = find(listB==standard_reference);
        end

        %% Reref the data to a specific channel------------------------------
        if isempty(C) && ~strcmp(dataset_reference,standard_reference)     
            %Table III: D) error: channel T not present
            error("ERROR: NEW REFERENCE CHANNEL NOT REGISTERED");
    
        elseif strcmp(dataset_reference,standard_reference)                  
            %Table III: B)-C) nothing to do
        else     
            %Table III: A)-F) rereference the data
            EEG = pop_reref( EEG, C,'keepref','on');
            EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' convertStringsToChars(standard_reference) '(keepref: on)'];
        end

    end
end
