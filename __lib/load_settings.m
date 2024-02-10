function varargout = load_settings( setting_name, info_type )
    % FUNCTION: load_settings
    %
    % Description: Loads settings information based on the specified setting name and info type.
    %
    % Syntax:
    %   varargout = load_settings(setting_name, info_type)
    %
    % Input:
    %   - setting_name: Name of the stored settings folder.
    %   - info_type: Type of information to load ('path', 'preprocess', 'selection', 'save', or 'all').
    %
    % Output:
    %   - varargout: Cell array containing the loaded settings information.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %
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
                struct_info = load([ filePath 'default_settings/' setting_name '/' struct_name{i} ]).(field_name{i});
                [~] = evalc(['check_' struct_name{i}(1:end-4) '(struct_info);']);
                varargout{i} = struct_info;
            catch
                varargout{i} = ['no ' struct_name{i} ' in ' setting_name ' setting'];
            end
        end
        if iscellstr(varargout)
            d = dir( [ filePath 'default_settings/' setting_name ]);
            d = d(~ismember({d(:).name},{'.','..'}));
            if isempty(d)
                warning(" setting name exist but doesn't have any valid file and is empty. Removing it to avoid bugs.")
                remove_settings(setting_name);            
            else
                warning([' setting name exist but does not have any valid file. '
                    'It is suggested to copy all its content elsewhere and remove the setting name.'])
            end                
        end
    else
        %nargout=1;
        varargout = cell(1,1);
        if strcmpi(info_type, 'path')
            struct_info = load([ filePath 'default_settings/' setting_name '/' struct_name{1} ]).path_info;
            check_path_info(struct_info);
            varargout{1} = struct_info;
        elseif strcmpi(info_type, 'preprocess')
            struct_info = load([ filePath 'default_settings/' setting_name '/' struct_name{2} ]).params_info;
            check_preprocessing_info(struct_info);
            varargout{1} = struct_info;
        elseif strcmpi(info_type, 'selection')
            struct_info = load([ filePath 'default_settings/' setting_name '/' struct_name{3} ]).selection_info;
            check_selection_info(struct_info);
            varargout{1} = struct_info;
        elseif strcmpi(info_type, 'save')
            struct_info = load([ filePath 'default_settings/' setting_name '/' struct_name{4} ]).save_info;
            check_save_info(struct_info);
            varargout{1} = struct_info;
        end
    end


end