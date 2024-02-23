
function [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, obj_info, L, template_info, verbose)
    % FUNCTION: load_channel_location
    %
    % Description: Loads or generates channel locations for EEG data based on specified options.
    %
    % Syntax:
    %   [EEG, L, channel_location_file_extension, B] = load_channel_location(EEG, data_info, obj_info, L, template_info, verbose)
    %
    % Input:
    %   - EEG: EEG data structure.
    %   - data_info: Structure containing general information about the dataset.
    %   - obj_info: Structure containing information about the EEG data file.
    %   - L: Structure containing information about channel locations (optional).
    %   - template_info: Structure containing template information.
    %   - verbose: Boolean setting the verbosity level.
    %
    % Output:
    %   - EEG: Updated EEG data structure with loaded or generated channel locations.
    %   - L: Updated structure containing information about channel locations.
    %   - channel_location_file_extension: File extension of the loaded channel location file.
    %   - B: Structure containing loaded or generated channel locations.
    %
    % Notes:
    %   - This function either loads channel locations from a file, generates them based
    %     on the channel system or a template, or uses a preloaded structure.
    %
    % Author: [Andrea Zanola]
    % Date: [25/01/2024]
    if nargin < 6
        verbose = false;
    end

    if ~isequal(obj_info.channel_location_filename, 'loaded')
        if ~isempty(obj_info.electrodes_filename)
    
            %Fig 4. 4)
            %% Import Channels Location -----------------------------------------
            [~,~,channel_location_file_extension] = fileparts(obj_info.electrodes_filename);

            %I = find(channel_location_filepath=='.');
            %channel_location_file_extension = channel_location_filepath(I+1:end);
    
            if isequal(channel_location_file_extension,'.bvef')
                if verbose
                    C = loadbvef(obj_info.electrodes_filename);
                else
                    [~,C] = evalc("loadbvef(obj_info.electrodes_filename);");
                end
                B = C(3:end); %first 2 labels are REF and GND           %CHECK THIS PART !!!
            else
                if verbose
                    B = readlocs(obj_info.electrodes_filename,'filetype',channel_location_file_extension(2:end),'importmode','native');
                else
                    [~,B] = evalc("readlocs(obj_info.electrodes_filename,'filetype',channel_location_file_extension(2:end),'importmode','native');");
                end
                    % if ~isfield(B,'theta')
                %     B = readlocs(obj_info.electrodes_filename,'filetype',channel_location_file_extension(2:end),'importmode','eeglab');
                % end
            end

            % Keep in consideration if some channels have strange name from
            % the channel location file
            [B] = rename_channels(B, data_info, false, []);     
            [~,listB] = list_chan(B);

            % Keep in consideration if some channels have strange name from
            % the channel location field of EEG struct          
            %Note that EEG.history should be true, if EEG.chanlocs is
            %passed; in such a way we can update the EEG.history
            [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, true, EEG);

            [~,listE] = list_chan(EEG.chanlocs);
            
            % Keep in consideration if some channels have been removed, and
            % update the list of channels read from chanloc file
            Nremove = length(data_info.channel_to_remove{1});
            if Nremove > 0
                [~, ind_remove] = ismember(data_info.channel_to_remove, listB);
                B(ind_remove(ind_remove ~= 0)) = [];
                [~,listB] = list_chan(B);
            end
            matching_labels = ismember(listE, listB);
            
            % Filter EEG.chanlocs using the logical index array
            B = B(matching_labels);

            % Rotate axis on the basis of nosedirection (allow values
            % +X,-X,+Y,-Y
            if ~isempty(data_info.nose_direction)
                if isequal(data_info.nose_direction(2),'Y')
                    transformation = ['TMP = X; X = ' data_info.nose_direction '; Y = ' data_info.nose_direction(1) 'TMP'];
                else
                    transformation = ['TMP = X; X=' data_info.nose_direction(1) 'TMP'];
                end
                if verbose
                    B = pop_chanedit(B, 'transform', transformation);

                else
                    [~,B] = evalc("pop_chanedit(B, 'transform', transformation);");
                end
                EEG.history = [EEG.history newline 'CHANGED NOSE DIRECTION OF CHANLOC'];
            end

            % If automatic conversion failed, try with centering
            if ~isfield(B,'theta')
                if verbose
                    B = pop_chanedit(B,'convert','chancenter');
                else
                    [~,B] = evalc("pop_chanedit(B,'convert','chancenter');");
                end
            EEG.history = [EEG.history newline 'CENTERED XYZ COORDINATES OF CHANLOC'];
            end

            % theta coordinates are needed for spherical interpolation.
            if ~isfield(EEG.chanlocs,'theta')
                error('THETA COORDINATES NOT PRESENT');
            else
                EEG.chanlocs = B;
                EEG.history = [EEG.history newline 'LOAD CHANNEL LOCATION FROM: ' obj_info.electrodes_filename];
            end

            
        else
            %Fig 4. 3)
            %If the channel location is not provided, we can generate one
            %from the channel system. Thus this condition is useful to
            %generate L only one time
            if isempty(L)
                
                [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, true, EEG);
                [L] = create_chan_loc(EEG, data_info, [], template_info);
            end
            B = L;
            EEG.chanlocs = B;
            EEG.history = [EEG.history newline 'LOAD CHANNEL LOCATION FROM: ' template_info.standard_chanloc];
            [~,~,channel_location_file_extension] = fileparts(template_info.standard_chanloc);
        end
    else
        %Fig 4. 1)
        [EEG.chanlocs] = rename_channels(EEG.chanlocs, data_info, true, EEG);
        B = EEG.chanlocs;
        channel_location_file_extension = "nan";
        L = [];
    end

end



