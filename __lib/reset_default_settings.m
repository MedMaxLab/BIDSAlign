function [] = reset_default_settings()

    [~] = set_preprocessing_info('store_settings', true);
    [~] = set_save_info('store_settings',true);
    [~] = set_selection_info('store_settings', true);
    [~, ~] = evalc("set_path_info( 'store_settings', true )");
    
end