
function [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B, verbose)
    % FUNCTION: rereference
    % 
    % Description: Rereferences EEG data based on specified parameters.
    %
    % Syntax:
    %   [EEG] = rereference(EEG, data_info, params_info, channel_location_file_extension, B, verbose)
    %
    % Input:
    %   - EEG: EEG data structure.
    %   - data_info: Structure containing information about the EEG dataset.
    %   - params_info: Structure containing preprocessing parameters.
    %   - channel_location_file_extension: File extension for channel location file.
    %   - B: List of available channels.
    %   - verbose: (Optional) Boolean setting the verbosity level.
    %
    % Output:
    %   - EEG: Updated EEG data structure after rereferencing.
    %
    % Notes:
    %   - This function performs rereferencing based on specified parameters.
    %
    % Author: [Andrea Zanola, Federico Del Pup]
    % Date: [25/01/2024]
    if nargin < 6
        verbose = false;
    end

    dataset_reference  = data_info.channel_reference; %Current EEG Ref
    standard_reference = params_info.standard_ref;    %Desired New Ref

    %% Create list of available channels --------------------------------
    [~,listB] = list_chan(B);

    %% Reref the data to average reference ------------------------------
    if isequal(upper(standard_reference),'COMMON')
        if isequal(upper(dataset_reference),'COMMON')
            if verbose
                disp('Rereference case: H');
            end
            %Table III: H) nothing to do                                                            
        else
            %Table III: G) common reref + if required interpolate channel T and/or channel S  
            if verbose
                disp('Rereference case: G');
                EEG = pop_reref( EEG, [],'keepref','on');      
            else
                [~,EEG] = evalc("pop_reref( EEG, [],'keepref','on');");
            end
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
            if verbose
                disp('Rereference case: D');
            end
            %Table III: D) error: channel T not present
            error('ERROR: NEW REFERENCE CHANNEL NOT REGISTERED');
    
        elseif isequal(dataset_reference,standard_reference)                  
            %Table III: B)-C) nothing to do
            if verbose
                disp('Rereference case: B-C');
            end
        else     
            %Table III: A)-F) rereference the data
            if verbose
                disp('Rereference case: A-F');
                EEG = pop_reref( EEG, C,'keepref','on');
            else
                [~,EEG] = evalc("pop_reref( EEG, C,'keepref','on');");
            EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' standard_reference '(keepref: on)'];
            end

        end
    end
end