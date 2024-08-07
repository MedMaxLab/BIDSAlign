
function DATA_STRUCT = preprocess_all( dataset_info_filename, varargin)
    % FUNCTION: preprocess_all
    % 
    % sudo apt-get install libjpeg8-dev libjpeg-turbo8-dev
    % Description: Preprocesses EEG datasets based on the provided configuration.
    %
    % Syntax:
    %   DATA_STRUCT = preprocess_all(DATASET_INFO_FILENAME, 'PARAM1', VALUE1, ...)
    %   preprocesses EEG datasets according to the specified parameters. The
    %   preprocessing configurations are loaded from DATASET_INFO_FILENAME, and
    %   additional parameters can be set using parameter-value pairs.
    %
    % Input:
    %   - dataset_info_filename: Full path to the dataset information file (TSV format).
    %                            If the table is in the current working directory, only 
    %                            the file name is needed.  The loaded table can be 
    %                            directly given. 
    %                            In such a case call the **check_loaded_table**
    %                            function to verify if the table format is the required
    %                            one.
    %   - varargin: Variable-length input arguments specifying optional parameters.
    %
    % Optional Input Parameters:
    %   - path_info: Structure specifying paths for different components.
    %   - preprocess_info: Structure containing preprocessing parameters.
    %   - selection_info: Structure containing selection parameters.
    %   - save_info: Structure specifying the data saving options.
    %   - setting_name: String specifying the name of the settings configuration.
    %   - single_file: Boolean indicating whether to process a single file.
    %   - single_dataset_name: String specifying the name of the single dataset 
    %                          to process.
    %   - single_file_name: String specifying the name of the single file to process.
    %   - diagnostic_folder_name: String specifying the name of the diagnostic folder.
    %   - use_parpool: Boolean indicating whether to use parallel processing.
    %   - solve_nogui: Boolean indicating whether to solve potential 
    %                  eeglab nogui issues or not.
    %   - verbose: Boolean setting the verbosity level.
    %   - datasets_path: String specifying the dataset path.
    %   - output_path: String specifying the output path.
    %   - output_mat_path: String specifying the custom output path for mat files.
    %   - output_csv_path: String specifying the custom output path for marker files.
    %   - output_set_path: String specifying the custom output path for set files.
    %   - eeglab_path: String specifying the path to EEGLAB.
    %
    % Output:
    %   - EEG: EEG data structure after preprocessing.
    %   - DATA_STRUCT: Structure containing preprocessed data information.
    %
    % Notes:
    %   - This script preprocesses EEG data, including loading, channel extraction,
    %     interpolation, and saving. It can process a single file, a single dataset,
    %     or all datasets in the provided dataset information file.
    %
    % Author: [Andrea Zanola, Federico Del Pup]
    % Date: [25/01/2024]
    
    
    % NOTE: this code was written using a monospace font (like it always should be)
    
    % --------------------------------------------------------------------------------
    %                                ARGUMENT PARSING
    % --------------------------------------------------------------------------------
    
    % ------------------------------ setting defaults ------------------------------
    filePath = mfilename('fullpath');
    filePath = filePath(1:length(filePath)-14);
    
    defaultDatasetPath = '';
    defaultOutputPath = '';
    defaultOutputMatPath = '';
    defaultOutputCsvPath = '';
    defaultOutputSetPath = '';
    defaultEeglabPath = '';
    
    defaultSelectionInfo = struct;
    defaultProcessInfo = struct;
    defaultSaveInfo = struct;
    defaultPathInfo = struct;
    
    defaultSettingName = 'default';
    
    defaultSingleFile = false;
    defaultSingleDatasetName = '';
    defaultSingleFileName = '';
    
    defaultVerbose = false;
    defaultParPool = false;
    defaultSolveNoGui = false;
    defaultDiagnosticName = '_diagnostic_test';


    % --------------------------- create input parses ----------------------------
    p = inputParser;
    validStringChar= @(x) isstring(x) || ischar(x);
    validstruct = @(x) isstruct(x);
    validBool= @(x) islogical(x);
    p.addRequired( 'dataset_info_filename', @(x) istable(x) || isfile(x) );
    
    p.addOptional( 'path_info', defaultPathInfo, validstruct);
    p.addOptional('preprocess_info', defaultProcessInfo, validstruct);
    p.addOptional('selection_info', defaultSelectionInfo, validstruct);
    p.addOptional('save_info', defaultSaveInfo, validstruct);
    p.addParameter('setting_name', defaultSettingName, validStringChar);
    
    p.addParameter( 'single_file', defaultSingleFile, validBool);
    p.addParameter( 'single_dataset_name', defaultSingleDatasetName, validStringChar);
    p.addParameter( 'single_file_name', defaultSingleFileName, validStringChar);
    
    p.addParameter( 'diagnostic_folder_name', defaultDiagnosticName, validStringChar);
    p.addParameter('use_parpool', defaultParPool, validBool);
    p.addParameter( 'solve_nogui', defaultSolveNoGui, validBool);
    p.addParameter( 'verbose', defaultVerbose, validBool);
    
    p.addParameter( 'datasets_path', defaultDatasetPath, validStringChar);
    p.addParameter( 'output_path', defaultOutputPath, validStringChar);
    p.addParameter( 'output_mat_path', defaultOutputMatPath, validStringChar);
    p.addParameter( 'output_csv_path', defaultOutputCsvPath, validStringChar);
    p.addParameter( 'output_set_path', defaultOutputSetPath, validStringChar);
    p.addParameter( 'eeglab_path', defaultEeglabPath, validStringChar);
    
    parse(p, dataset_info_filename, varargin{:});    
    
    % -------------------- extract parameters from input parser --------------------
    selection_info = p.Results.selection_info;
    params_info = p.Results.preprocess_info;
    save_info = p.Results.save_info;
    path_info = p.Results.path_info;
    setting_name = p.Results.setting_name;   

    verbose = p.Results.verbose;
    solve_nogui = p.Results.solve_nogui; 
    use_parpool = p.Results.use_parpool;
    
    single_file = p.Results.single_file;
    dataset_name = [p.Results.single_dataset_name];
    raw_filename = p.Results.single_file_name;
    raw_filepath = '';
    
    % -------------------------------------------------------------------------------
    %                       GET STRUCTS WITH PREPRO SETTINGS
    % -------------------------------------------------------------------------------

    % basically, if not given, it will try to load a file given in the
    % setting name, otherwise it will try to load a file placed in the
    % defaults setting. If both fails, initialize a struct with the default
    % settings just for this call (if verbose is set to true warnings will
    % be generated)    
    if isempty( fieldnames(save_info) )
       try
           save_info = load([filePath 'default_settings/' ...
               setting_name '/save_info.mat']).save_info;
       catch
           try
               save_info = load([filePath ...
                   'default_settings/default/save_info.mat']).save_info;
           catch
               save_info = set_save_info();
           end
       end
    end


    if isempty( fieldnames(selection_info) )
       try
           selection_info = load([filePath 'default_settings/' ...
               setting_name '/selection_info.mat']).selection_info;
       catch
           try
               selection_info = load([filePath ...
                   'default_settings/default/selection_info.mat']).selection_info;
           catch
               selection_info = set_selection_info();
           end
       end
    end

    if isempty( fieldnames(params_info) )
       try
           params_info = load([filePath 'default_settings/' ...
               setting_name '/preprocessing_info.mat']).params_info;
       catch
           try
               params_info = load([filePath ...
                   'default_settings/default/preprocessing_info.mat']).params_info;
           catch
               params_info = set_preprocessing_info();
           end
       end
    end

    if isempty( fieldnames(path_info) )
       try
           path_info = load([filePath ...
               'default_settings/' setting_name '/path_info.mat']).path_info;
       catch
           try
               path_info = load([filePath ...
                   'default_settings/default/path_info.mat']).path_info;
           catch
               path_info = set_path_info();
           end
       end
    end


    % for path info, fields will be changed if anything new is given 
    % as input to this function. 
    
    % Also, paths to the library and the current one will be always updated 
    % to avoid errors, since those aren't given by the user. 
    % No overwrite to the original path is performed.
    path_info.current_path = pwd;
    path_info.lib_path = filePath;
    path_info.git_path = filePath(1:length(filePath)-6);
    
    if ~isempty(p.Results.datasets_path)
       path_info =  set_path_info(path_info, 'datasets_path', p.Results.datasets_path);
    end
    if ~isempty(p.Results.output_path)
       path_info = set_path_info(path_info, 'output_path', p.Results.output_path);
    end
    if ~isempty(p.Results.eeglab_path)
       path_info = set_path_info(path_info, 'eeglab_path', p.Results.eeglab_path);
    end
    if ~isempty(p.Results.output_mat_path)
       path_info = set_path_info(path_info, 'output_mat_path', ...
           p.Results.output_mat_path);
    end
    if ~isempty(p.Results.output_csv_path)
       path_info = set_path_info(path_info, 'output_csv_path', ...
           p.Results.output_csv_path);
    end
    if ~isempty(p.Results.output_set_path)
       path_info = set_path_info(path_info, 'output_set_path', ...
           p.Results.output_set_path);
    end
    if ~strcmp(p.Results.diagnostic_folder_name, '_diagnostic_test')
       path_info.diagnostic_folder_name = p.Results.diagnostic_folder_name;
    end

    % --------------------------------------------------------
    %            ADDITIONAL CHECKS ON GIVEN PATHS
    % --------------------------------------------------------
    
    % add path to eeglab if given. If not given, check that 
    % eeglab will start when called by the function
    if ~isempty(path_info.eeglab_path)
       addpath(path_info.eeglab_path)
       search_eeglab_path(verbose)
    else
       search_eeglab_path(verbose)
    end

    % add path to BIDSAlign if not included in the 
    % search path
    if ~any(strcmp(path_info.lib_path, strsplit( path ,':')))
       addpath(path_info.lib_path)
    end

    % if datasets info wasn't given, raise an error
    if isempty(path_info.datasets_path)
       error(['datasets_path not given. Be sure it is stored '
           'in path_info or give it in input when calling this function'])
    end

    % check that output path is valid
    if ~isfolder(path_info.output_path)
        error("given 'output_path' is not a correct path to an existing directory")
    end

    % if given, check that custom output path
    % for mat files is valid
    if ~isempty(path_info.output_mat_path)
        if ~isfolder(path_info.output_mat_path)
            error(" if given, 'output_mat_path' must be " + ...
                "a valid path to an existing directory")
        end
    end

    % if given, check that custom output path
    % for csv files is valid
    if ~isempty(path_info.output_csv_path)
        if ~isfolder(path_info.output_csv_path)
            error(" if given, 'output_table_path' must be a" + ...
                " valid path to an existing directory")
        end
    end

    % if given, check that custom output path for set files is valid
    if ~isempty(path_info.output_set_path)
        if ~isfolder(path_info.output_set_path)
            error(" if given, 'output_set_path' must be a " + ...
                "valid path to an existing directory")
        end
    end
    
    % ---------------------------------------------------------------------------------
    %                                   OPEN EEGLAB
    % ---------------------------------------------------------------------------------
    % sometimes eeglab nogui fail to load plugins. If this happens, use the 
    % solve_nogui boolean and 'eeglab; close' commands will be used
    if solve_nogui
       if verbose
           eeglab; close;
       else
           [~] = evalc('eeglab; close;');
       end
       addpath(path_info.lib_path);
    else
       if verbose
           eeglab nogui;
       else
           [~] = evalc('eeglab nogui;');
       end
    end

    % -------------------------------------------------------------------------------
    %                         IMPORT DATASETS INFO FROM TABLE
    % -------------------------------------------------------------------------------
    
    % Read the dataset information from a tsv file
    if istable(dataset_info_filename)
        dataset_info = dataset_info_filename;
    else
        dataset_info = readtable(dataset_info_filename, ...
            'format','%f%s%s%s%s%s%s%s%s%f%f','filetype','text');
    end
    
    check_loaded_table(dataset_info);
    
    % Check if given dataset name is included in the table
    if ~isempty(dataset_name)
        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name), 1); 
        if isempty(dataset_index)
            error( [ 'given dataset name to preprocess not included' ...
                ' in the loaded dataset info table'])
        end
    end

    % --------------------------------------------------------------------------------
    %                             MANAGE SINGLE FILE 
    % --------------------------------------------------------------------------------

    % if single file mode must be performes, check that such file exists in the 
    % current dataset path
    if single_file

        % if no filename is given check if path_info.raw_filepath brings to a
        % valid file
        if isempty(raw_filename)
            [raw_filepath, dataset_name, path_info]  = ...
                check_single_file_path(path_info, dataset_info, dataset_name );

        else
            % if isfile it means that a valid path to a file was given. In such
            % a case, do as previously for all paths and write it in path info
            % and check if it's valid
            if isfile(raw_filename)
                path_info.raw_filepath = raw_filename;
                [raw_filepath, dataset_name, path_info]  = ...
                    check_single_file_path(path_info, dataset_info, dataset_name );
            else
                % if raw_filename is not a path but only the name of a file,
                % we must retrieve a possible file to the path, then do as
                % always and write it in the path_info and check its validity.

                % first check if the given raw_filename brings to a valid 
                % file in the datasets path               
                path_file_struct = dir([path_info.datasets_path '**' ...
                    filesep raw_filename]);
                if isempty(path_file_struct)
                    error("cannot find current raw file. Please check that " + ...
                        "dataset path and raw_filename are correct." + ...
                        "Give raw_filename with the extension, for example" + ... 
                        " 'sub-01-raw-eeg.bdf' ")
                else
                    % if there are multiple files with the same name, the only
                    % way to retrieve the right single path is by looking at
                    % the single_dataset name. So, if not given, raise an error
                    if size(path_file_struct,1) > 1
                        if isempty(dataset_name)
                            error(['detected multiple file with the same name. ' ...
                                ' Please specify which dataset to consider using the'...
                                ' single_dataset_name argument.'])
                        else
                            % in the other case, use the dataset_info table to
                            % retrieve all eeg records of such dataset and do
                            % an intersection with the possible files found. If
                            % the intersection brings to a single file, then we
                            % are ok, otherwise throw an error
                            rows=  strcmp( dataset_name , dataset_info.dataset_name);
                            code_and_format = dataset_info{rows, ...
                                ["dataset_code", "eeg_file_extension"]};
                            filelist = get_dataset_file_list(path_info.datasets_path,...
                                code_and_format{1}, code_and_format{2});
                            allfilepaths = cell(length(filelist),1);

                            % create cell array with all the full paths to eeg
                            % files for the selected dataset
                            for i=1:length(filelist)
                                allfilepaths{i} = [filelist(i).folder ...
                                    filesep filelist(i).name];
                            end

                            % create cell array with all the full paths to eeg
                            % files compatible with raw file name
                            path_file_cell = cell(length(path_file_struct),1);
                            for i=1:length(path_file_struct)
                                path_file_cell{i} = [path_file_struct(i).folder ...
                                    filesep path_file_struct(i).name];
                            end

                            % intersection to get the right file to preprocess
                            final_path_found = intersect(path_file_cell, allfilepaths);
                            if length(final_path_found)>1
                                error(['multiple file with the same name in the '
                                    dataset_name ' dataset. The only way to avoid this'
                                    ' is by giving the full path to the file you want '
                                    'to preprocess']) 
                            else
                                % check is performed below
                                path_info.raw_filepath = final_path_found{1};
                            end
                        end

                    else
                        path_info.raw_filepath = [path_file_struct.folder ... 
                            filesep path_file_struct.name];
                    end
                    % now that path_info.raw_filepath is set correctly 
                    % verify that everything has gone correctly for this block
                    [raw_filepath, dataset_name, path_info]  = ...
                        check_single_file_path(path_info, dataset_info, dataset_name );

                end  
            end % end of "if isfile(raw_filename)"
        end % end of "if isempty(raw_filename)"
        
        raw_filename = strsplit(raw_filepath, filesep);
        raw_filename = raw_filename{end};
    end % end of "if signle file"


    % -------------------------------------------------------------------------------
    %                        INITIALIZE OBJECT INFO STRUCT
    % -------------------------------------------------------------------------------
    obj_info.raw_filename = raw_filename;
    raw_filepath_split = strsplit( raw_filepath, filesep);
    raw_filepath = [strjoin(raw_filepath_split(1:end-1), filesep) filesep];
    obj_info.raw_filepath = raw_filepath;
    
    % -------------------------------------------------------------------------------
    %                            CREATE OUTPUT FOLDERS
    % -------------------------------------------------------------------------------
    % Check if exist otherwise create mat_preprocessed folder
    if isempty(path_info.output_mat_path)
        path_info.output_mat_path   = [path_info.output_path ...
            '_mat_preprocessed' filesep];     
        if ~exist(path_info.output_mat_path, 'dir')
           mkdir(path_info.output_mat_path)
        end
    end

    % Check if exist otherwise create csv_marker_files folder
    if isempty(path_info.output_csv_path) 
        path_info.output_csv_path   = [path_info.output_path ...
            '_csv_marker_files' filesep];     
        if ~exist(path_info.output_csv_path, 'dir') && save_info.save_marker 
            mkdir(path_info.output_csv_path)
        end   
    end

    % Check if exist otherwise create set_files folder
    if isempty(path_info.output_set_path) 
        path_info.output_set_path   = [path_info.output_path ...
            '_set_preprocessed' filesep];     
        if ~exist(path_info.output_set_path, 'dir') && save_info.save_set 
            mkdir(path_info.output_set_path)
        end   
    end
    
    %          |------------------------------------------------------|
    %          |------------------------------------------------------|
    %          |                 START PREPROCESSING                  |
    %          |------------------------------------------------------|
    %          |------------------------------------------------------|
    
    % Create two use modes: if dataset name is specified, preprocess only that
    % dataset otherwise, preprocess all the dataset in dataset_info.

    % PARPOOL BLOCK 
    if use_parpool && isempty(dataset_name) && ~single_file
        %Launch the parallel pool for parallel computing (if available)
        poolobj = gcp();
        if ~poolobj.Connected
            try
                parpool;
            catch
                error('ERROR: parpool not available. Set use_parpool to false.');
            end
        end

        % slice table to avoid broadcastable warning with parfor
        dataset_names = dataset_info.dataset_name;
        channels_to_remove = dataset_info.channel_to_remove;

        % Launch Parpool
        parfor i=1:height(dataset_info)
            if verbose
                fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' ...
                    dataset_names{i} ' ---\n']);
            end

            % Create the data_info struct to store dataset-specific information
            % dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
            data_info = table2struct(dataset_info(i,:));
            data_info.channel_to_remove = strsplit(channels_to_remove{i}, ','); 

            % Preprocess all the dataset
            [~, ~] = preprocess_dataset(data_info, save_info, params_info, ...
                path_info, selection_info, verbose);
        end  

    % SINGLE THREAD BLOCK
    elseif isempty(dataset_name) && ~single_file
       for i=1:height(dataset_info) 
           if verbose
                fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' ...
                    dataset_info.dataset_name{i} ' ---\n']);
           end

            % Create the data_info struct to store dataset-specific information
            % dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
            data_info = table2struct(dataset_info(i,:));
            data_info.channel_to_remove = ...
                strsplit(dataset_info.channel_to_remove{i}, ','); 

            % Preprocess all the dataset
            [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, ...
                path_info, selection_info, verbose);
       end

    % SINGLE FILE OR DATASET BLOCK
    else
        if single_file
            if verbose && use_parpool
                warning('PARPOOL NOT USED SINCE SPECIFIC FILE WAS SELECTED');
            end

            % Extract Dataset Code Name
            out = regexp(obj_info.raw_filepath , filesep, 'split');
            dataset_code = out{end-4};

            % Create the data_info struct to store dataset-specific information
            dataset_index = find(strcmp(dataset_info.dataset_code, dataset_code));
            data_info = table2struct(dataset_info(dataset_index,:));
            data_info.channel_to_remove = ...
                strsplit(dataset_info.channel_to_remove{dataset_index}, ',');

            disp(dataset_name)
            [~,DATA_STRUCT] = preprocess_subject(data_info, save_info, ...
                params_info, path_info, obj_info, verbose);
        else
            if verbose
                warning('PARPOOL NOT USED SINCE SPECIFIC DATASET WAS SELECTED');
            end

            % Create the data_info struct to store dataset-specific information
            dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
            data_info = table2struct(dataset_info(dataset_index,:));
            data_info.channel_to_remove = ...
                strsplit(dataset_info.channel_to_remove{dataset_index}, ','); 

            % Preprocess a specific dataset
            [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, ...
                path_info, selection_info, verbose);
        end
    end

    % ---------------------------------------------------------------------------------
    %                             GO BACK TO STARTING FOLDER
    % ---------------------------------------------------------------------------------
    % preprocessing phase will "cd" into subfolders inside dataset path. 
    % We need to return to the starting folder path
    cd(path_info.current_path)

end

