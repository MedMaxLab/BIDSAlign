function [] = reset_default_settings()
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
    [~] = set_preprocessing_info('store_settings', true);
    [~] = set_save_info('store_settings',true);
    [~] = set_selection_info('store_settings', true);
    [~] = set_path_info( 'store_settings', true, 'silence_warn', true );
    
end