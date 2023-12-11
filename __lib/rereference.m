
function [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B)
    % Function: rereference
    % Description: Rereferences EEG data to a new reference electrode channel
    % based on the specified standard reference or a specific channel.
    %
    % Input:
    %   - EEG: EEG data structure.
    %   - data_info: A structure containing information about the EEG data,
    %                including the current EEG reference (channel_reference).
    %   - params_info: A structure containing information about the desired new
    %                  reference (standard_ref).
    %   - channel_location_file_extension: File extension of channel location data
    %                                      (e.g., '.bvef').
    %   - B: A data structure containing information about EEG channels.
    %
    % Output:
    %   - EEG: EEG data structure with the reference changed as specified.
    %
    % Supported Standard References:
    %   - "COMMON": Use a common average reference.
    %   - Specific channel label: Reference EEG data to the specified channel.
    %
    % Notes:
    %   - This function supports different reference schemes, as listed in "Table III"
    %     in the associated paper.
    %   - If the desired reference channel is not present in the EEG data, an error
    %     will be raised.
    %
    % Author: [Andrea Zanola]
    % Date: [04/10/2023]

    dataset_reference  = data_info.channel_reference; %Current EEG Ref
    standard_reference = params_info.standard_ref;    %Desired New Ref

    %% Create list of available channels --------------------------------
    [~,listB] = list_chan(B);

    %% Reref the data to average reference ------------------------------
    if isequal(upper(standard_reference),'COMMON')
        if isequal(upper(dataset_reference),'COMMON')
            disp('Rereference case: H');
            %Table III: H) nothing to do                                                            
        else
            %Table III: G) common reref + if required interpolate channel T and/or channel S  
            disp('Rereference case: G');
            EEG = pop_reref( EEG, [],'keepref','on');                      
            EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' standard_reference];
        end
    else
        %% Check if ref. is in the channel location -------------------------
        if isequal(channel_location_file_extension,'.bvef')
            A = find(listB=="REF");                                        %A is the index of the dataset channel reference
            if  isequal(dataset_reference,standard_reference)              %check if they are equal
                C = find(listB=="REF");                                    %C is the index of the standard channel reference
            else
                C = find(listB==standard_reference);
            end
        else
            A = find(listB==dataset_reference);
            C = find(listB==standard_reference);
        end

        %% Reref the data to a specific channel------------------------------
        if isempty(C) && ~isequal(dataset_reference,standard_reference)    
            disp('Rereference case: D');
            %Table III: D) error: channel T not present
            error('ERROR: NEW REFERENCE CHANNEL NOT REGISTERED');
    
        elseif isequal(dataset_reference,standard_reference)                  
            %Table III: B)-C) nothing to do
            disp('Rereference case: B-C');
        else     
            %Table III: A)-F) rereference the data
            disp('Rereference case: A-F');
            
            EEG = pop_reref( EEG, C,'keepref','on');
            EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' standard_reference '(keepref: on)'];
        end

    end
end
