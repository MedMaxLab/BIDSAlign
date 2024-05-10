function save_info = set_save_info(varargin)
    % FUNCTION: set_save_info
    %
    % Description: Sets or updates the save information for the EEG processing pipeline.
    %
    % Syntax:
    %   save_info = set_save_info(varargin)
    %
    % Input:
    %   - varargin (optional): A list of parameter-value pairs for customizing 
    %                          the save information.
    %
    % Output:
    %   - save_info (struct): A struct containing the save information.
    %
    % Parameters:
    %   - save_data (logical): A flag indicating whether to save data (default: true).
    %   - save_data_as (char): File format for saving data (default: 'matrix').
    %   - save_set (logical): A flag indicating whether to save the eeglab dataset,
    %                         thus files in .set format (default: false).
    %   - save_struct (logical): A flag indicating whether to save data 
    %                            as a struct or not (default: false).
    %   - save_marker (logical): A flag indicating whether to save event 
    %                            markers or not (default: false).
    %   - store_settings (logical): A flag indicating whether to store 
    %                               the settings or not (default: false).
    %   - setting_name (char): Name of the setting if storing settings 
    %                          (default: 'default').
    %
    % Author: [Federico Del Pup]
    % Date: [27/01/2024]
    %

    defaultSaveData = true;
    defaultSaveType = 'matrix';
    defaultSaveSet = false;
    defaultSaveStruct = false;
    defaultSaveMarker = false;
    defaultSetLabel = '';
    
    defaultStoreSettings= false;
    defaultSettingName = 'default';
    defaultSaveInfo = struct;
    
    
    p = inputParser;
    validStringChar= @(x) isstring(x) || ischar(x);
    validBool= @(x) islogical(x);
    validStruct = @(x) isstruct(x);
    
    p.addOptional('save_info', defaultSaveInfo, validStruct);
    p.addParameter('save_data', defaultSaveData, validBool);
    p.addParameter('save_data_as', defaultSaveType, validStringChar);
    p.addParameter('save_set', defaultSaveSet, validBool);
    p.addParameter('save_struct', defaultSaveStruct, validBool);
    p.addParameter('save_marker', defaultSaveMarker, validBool);
    p.addParameter('set_label', defaultSetLabel, validStringChar);
    p.addParameter('store_settings', defaultStoreSettings, validBool);
    p.addParameter('setting_name', defaultSettingName, validStringChar);
    parse(p, varargin{:});

    % Create a struct to store the save information
    if  ~isempty(fieldnames(p.Results.save_info)) &&  ...
        isempty( setdiff(fieldnames(p.Results.save_info), p.Parameters' ) )

    param2set = setdiff( p.Parameters(1:end-2), [p.UsingDefaults 'save_info']);
    save_info = p.Results.save_info;
    for i = 1:length(param2set)
        save_info.(param2set{i}) = p.Results.(param2set{i});
    end     

    else
        save_info = struct('save_data',p.Results.save_data, ...
                           'save_data_as', p.Results.save_data_as, ...
                           'save_set', p.Results.save_set,...
                           'save_struct',p.Results.save_struct, ...
                           'save_marker',p.Results.save_marker, ...
                           'set_label', p.Results.set_label ...
                           );
    end
    
    if save_info.save_struct && ~save_info.save_data
        save_info.save_data = true;
    end

    check_save_info(save_info);

    % store settings if asked to do so
    if p.Results.store_settings
        filePath = mfilename('fullpath');
        if not( isfolder( [filePath(1:length(filePath)-13) ...
                filesep 'default_settings' filesep p.Results.setting_name]) )
            mkdir( [filePath(1:length(filePath)-13)  ...
                filesep 'default_settings' filesep] , p.Results.setting_name)
        end
        save( [ filePath(1:length(filePath)-13)  filesep 'default_settings' filesep ...
            p.Results.setting_name filesep 'save_info.mat'], 'save_info');
    end

end