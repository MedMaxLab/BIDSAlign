
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
% Usage example:
%   EEG = rereference(EEG, struct('channel_reference', 'A1'), struct('standard_ref', 'COMMON'), '.bvef', B);
%
% Notes:
%   - This function supports different reference schemes, as listed in "Table III"
%     in the associated paper.
%   - If the desired reference channel is not present in the EEG data, an error
%     will be raised.
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]

% Helper Function: list_chan
% Description: Creates a list of channel labels from the provided EEG channel
%              structure.
%
% Input:
%   - B: A data structure containing information about EEG channels.
%
% Output:
%   - NchanB: Number of channels in the EEG channel structure.
%   - listB: A string array containing the labels of EEG channels.
%
% Usage example:
%   [NchanB, listB] = list_chan(B);
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]

function [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B)

    dataset_reference  = data_info.channel_reference; %Current EEG Ref
    standard_reference = params_info.standard_ref;    %Desired New Ref

    %% Create list of available channels --------------------------------
    [~,listB] = list_chan(B);

    %% Reref the data to average reference ------------------------------
    if strcmp(standard_reference,"COMMON")
        if strcmp(dataset_reference,"COMMON")
            disp('Rereference case: H');
            %Table III: H) nothing to do                                                            
        else
            %Table III: G) common reref + if required interpolate channel T and/or channel S  
            disp('Rereference case: G');
            EEG = pop_reref( EEG, [],'keepref','on');                      
            EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' convertStringsToChars(standard_reference) ];
        end

    else
        %% Check if ref. is in the channel location -------------------------
        if isequal(channel_location_file_extension,'.bvef')
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
        %disp(['A: ' num2str(A)]);
        %disp(['C: ' num2str(C)]);

        %% Reref the data to a specific channel------------------------------
        if isempty(C) && ~strcmp(dataset_reference,standard_reference)    
            disp('Rereference case: D');
            %Table III: D) error: channel T not present
            error('ERROR: NEW REFERENCE CHANNEL NOT REGISTERED');
    
        elseif strcmp(dataset_reference,standard_reference)                  
            %Table III: B)-C) nothing to do
            disp('Rereference case: B-C');
        else     
            %Table III: A)-F) rereference the data
            disp('Rereference case: A-F');
            
            EEG = pop_reref( EEG, C,'keepref','on');
            EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' convertStringsToChars(standard_reference) '(keepref: on)'];
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
