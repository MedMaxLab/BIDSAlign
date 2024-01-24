function save_info = set_save_info(varargin)

% Da completare la descrizione delle variabili

    defaultSaveData = true;
    defaultSaveType = 'matrix';
    defaultSaveSet = false;
    defaultSaveStruct = false;
    defaultSaveMarker = true;
    
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
                                      'save_marker',p.Results.save_marker);
    end
    
    check_save_info(save_info);
    % store settings if asked to do so
    if p.Results.store_settings
        filePath = mfilename('fullpath');
        if not( isfolder( [filePath(1:length(filePath)-13)  '/default_settings/' p.Results.setting_name]) )
            mkdir( [filePath(1:length(filePath)-13)  '/default_settings/'] , p.Results.setting_name)
        end
        save( [ filePath(1:length(filePath)-13)  '/default_settings/' p.Results.setting_name '/save_info.mat'], 'save_info');
    end

end