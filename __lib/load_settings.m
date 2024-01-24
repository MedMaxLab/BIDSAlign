function varargout = load_settings( setting_name, info_type )
    
    filePath = mfilename('fullpath');
    filePath = filePath(1:length(filePath)-13);
    if nargin<2
        info_type='all';
    end
    if ~ischar(setting_name) || isempty(setting_name)
        error('setting_name must be a non empty char array')
    else
        if ~isfolder([filePath 'default_settings/' setting_name])
            error('setting name is not valid')
        end
    end
    if ~ischar(info_type)
        error('info_type must be a char array in [path | save | preprocess | selection | all ]')
    else
        if ~any(strcmpi(info_type, {'path' 'preprocess' 'selection' 'all' 'save'}))
            error('info_type must be a char array in [path | save | preprocess | selection | all ]')
        end
    end
    
    struct_name = {'path_info.mat', 'preprocessing_info.mat', 'selection_info.mat', 'save_info.mat'};
    if  strcmpi(info_type,'all')
        field_name = {'path_info', 'params_info', 'selection_info', 'save_info'};
        varargout = cell(1,4);
        for i = 1:4
            try 
                varargout{i} = load([ filePath 'default_settings/' setting_name '/' struct_name{i} ]).(field_name{i});
            catch
                varargout{i} = ['no ' struct_name{i} ' in ' setting_name 'setting'];
            end
        end
        if iscellstr(varargout)
            d = dir( [ filePath 'default_settings/' setting_name ]);
            d = d(~ismember({d(:).name},{'.','..'}));
            if isempty(d)
                warning(" setting name exist but doesn't have any valid file and is empty. Removing it to avoid bugs.")
                remove_settings(setting_name);            
            else
                warning([" setting name exist but doesn't have any valid file. "
                    "It is suggested to copy all its content elsewhere and remove the setting name."])
            end                
        end
    else
        %nargout=1;
        varargout = cell(1,1);
        if strcmpi(info_type, 'path')
            varargout{1} = load([ filePath 'default_settings/' setting_name '/' struct_name{1} ]).path_info;
        elseif strcmpi(info_type, 'preprocess')
            varargout{1} = load([ filePath 'default_settings/' setting_name '/' struct_name{2} ]).params_info;
        elseif strcmpi(info_type, 'selection')
            varargout{1} = load([ filePath 'default_settings/' setting_name '/' struct_name{3} ]).selection_info;
        elseif strcmpi(info_type, 'save')
            varargout{1} = load([ filePath 'default_settings/' setting_name '/' struct_name{4} ]).save_info;
        end
    end


end