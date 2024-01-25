
function [current_setting_names] = get_stored_settings( )
    % FUNCTION: get_stored_settings
    %
    % Description: Retrieves the names of stored settings folders.
    %
    % Syntax:
    %   current_setting_names = get_stored_settings()
    %
    % Output: 
    %   - current_setting_names: Cell array containing the names of stored settings folders.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %

    filePath = mfilename('fullpath');
    filePath = filePath(1:length(filePath)-19);
    d=dir([ filePath '/default_settings']);
    % remove all files (isdir property is 0)
    dfolders = d([d(:).isdir]);
    % remove '.' and '..' and 'default'
    dfolders = dfolders(~ismember({dfolders(:).name},{'.','..', 'default'}));
    current_setting_names = {dfolders.name};


end