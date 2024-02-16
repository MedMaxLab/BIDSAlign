function [] = reset_default_settings( empty_path)
    % FUNCTION: reset_default_settings
    %
    % Description: Resets the default settings for preprocessing, saving, and selection.
    %
    % Syntax:
    %   reset_default_settings()
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %
    if nargin < 1
        empty_path = false;
    end
    [~] = set_preprocessing_info('store_settings', true);
    [~] = set_save_info('store_settings',true);
    [~] = set_selection_info('store_settings', true);
    if empty_path
        [~] = set_path_info( 'store_settings', true, 'silence_warn', true );
    else
        path_info = set_path_info( 'silence_warn', true );
        path_info.output_path = ''; 
        path_info.current_path= ''; 
        path_info.lib_path= ''; 
        path_info.git_path = '';
    end
    [~] = set_path_info( 'store_settings', true, 'silence_warn', true );
    
end