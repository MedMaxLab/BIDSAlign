function [] = remove_settings( setting_to_remove)
    % FUNCTION: remove_settings
    %
    % Description: Removes one or more stored settings.
    %
    % Syntax:
    %   remove_settings(setting_to_remove)
    %
    % Input:
    %   - setting_to_remove: Name or cell array of names of the settings to be removed.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %

    %check if cell array is of char vectors
    if iscell(setting_to_remove)
        if ~iscellstr(setting_to_remove)
            error(['if given as cell array, ' ...
                'setting_to_remove must be a cell array of char vector'])
        end
    end

    % string to char for next concatenation (in case)
    if isstring(setting_to_remove)
        setting_to_remove= char(setting_to_remove);
    end
    
    %get current setting names
    filePath = mfilename('fullpath');
    filePath = filePath(1:length(filePath)-15);
    current_setting_names = get_stored_settings();
    
    if isempty(current_setting_names)
        return 
    end
    
    % check that any of the given names actually exist in 
    if ~any(ismember(setting_to_remove, current_setting_names))
        allowed_names = join(current_setting_names, ', ');
        error(['no valid setting name given as input' ...
            ' (default cannot be deleted with this function).' ...
            'Please use any of the following: ', allowed_names{1}])
    end
    
    % if there is only a setting to remove try to do it
    if ischar(setting_to_remove)
        if strcmp(setting_to_remove, 'default')
            error(['cannot delete default setting. ' ...
                'It can cause a strange behaviour. ' ...
                'If you want to reset parameters inside the default setting, ' ...
                'please use the reset_default_settings() function']);
        end
        rmdir([filePath '/default_settings/' setting_to_remove], 's');
    end

    % if the input is a cell array try to remove each element
    if iscell(setting_to_remove)
        for i = 1:length(setting_to_remove)
            try
                rmdir([filePath '/default_settings/' setting_to_remove{i}], 's');
            catch
                continue
            end
        end
    end

end