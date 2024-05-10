
function [EEG] = rereference(EEG, data_info, params_info, obj_info, ...
    channel_location_file_extension, B, verbose)
    % FUNCTION: rereference
    % 
    % Description: Rereferences EEG data based on specified parameters.
    %
    % Syntax:
    %   [EEG] = rereference(EEG, data_info, params_info, 
    %                       channel_location_file_extension, B, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - data_info (struct): Structure containing information about the EEG dataset.
    %   - params_info (struct): Structure containing preprocessing parameters.
    %   - obj_info (struct): Structure containing information about the EEG data file.
    %   - channel_location_file_extension (char): File extension for channel location file.
    %   - B (struct): Channel location structure.
    %   - verbose (logical): (Optional) Boolean setting the verbosity level.
    %
    % Output:
    %   - EEG: Updated EEG data structure after rereferencing.
    %
    % Notes:
    %   - This function performs rereferencing based on specified parameters.
    %
    % Author: [Andrea Zanola, Federico Del Pup]
    % Date: [25/01/2024]

    if params_info.prep_steps.rereference
        if nargin < 7
            verbose = false;
        end
    
        dataset_reference  = EEG.ref;
        standard_reference = params_info.standard_ref;    %Desired New Ref
    
        % Create list of available channels
        [~,listB] = list_chan(B);
    
        % Reref the data to average reference 
        if isequal(upper(standard_reference),'COMMON')
            if isequal(upper(dataset_reference),'COMMON')
                if verbose
                    disp('Rereference case: H');
                end
                %Table III: H) nothing to do                                                            
            else
                %Table III: G) common reref + if required interpolate 
                %                             channel T and/or channel S 
                if verbose
                    disp('Rereference case: G');
                    [EEG] = pop_reref(EEG, [],'keepref','on');      
                else
                    [~,EEG] = evalc("pop_reref( EEG, [],'keepref','on');");
                end
                EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' ...
                    standard_reference];
                
            end
        else
            %% Check if ref. is in the channel location -------------------------
            if isequal(channel_location_file_extension,'.bvef')
                % A is the index of the dataset channel reference
                A = find(listB=="REF"); %#ok                         
                if  isequal(dataset_reference,standard_reference) %check if are equal
                    % C is the index of the standard channel referenc
                    C = find(listB=="REF");                                    
                else
                    C = find(listB==standard_reference);
                end
            else
                A = find(listB==dataset_reference); %#ok
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
                EEG.history = [EEG.history newline 'RE-REFERENCE TO: ' ...
                    standard_reference '(keepref: on)'];
                end
    
            end
        end
    end
end