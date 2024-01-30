
function path_info = set_path_info(varargin)
    % FUNCTION: set_path_info
    %
    % Description: Sets or updates the path information for the EEG processing pipeline.
    %
    % Syntax:
    %   path_info = set_path_info(varargin)
    %
    % Input:
    %   - varargin (optional): A list of parameter-value pairs for customizing the path information.
    %
    % Output:
    %   - path_info: A struct containing the path information.
    %
    % Parameters:
    %   - datasets_path (char): Path to the datasets (BIDS-formatted).
    %   - output_path (char): Path to the output directory.
    %   - output_mat_path (char): Path to the directory for saving preprocessed EEG data in MAT format.
    %   - output_csv_path (char): Path to the directory for saving preprocessed EEG data in CSV format.
    %   - output_set_path (char): Path to the directory for saving preprocessed EEG data in SET format (EEGLAB).
    %   - eeglab_path (char): Path to the EEGLAB toolbox.
    %   - raw_filepath (char): Path to the raw EEG data file.
    %   - diagnostic_folder_name (char): Name of the diagnostic folder.
    %   - store_settings (logical): A flag indicating whether to store the settings (default: false).
    %   - setting_name (char): Name of the setting if storing settings (default: 'default').
    %   - root_data_path: for know to avoid error during function transition
    %   - current_path: current path, it will be used to call the final cd 
    %   - raw_filepath: path to the single eeg file to preprocess
    %   - lib_path: path to the __lib folder of the BIDSAlign library
    %   - git_path: path to the BIDSAlign library
    %   - root_folder_path: alias to the root folder path (TO DO)
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %


    filePath = mfilename('fullpath');
    filePath = filePath(1:length(filePath)-13);

    defaultDatasetPath= '';
    defaultOutputPath = pwd;
    defaultMatPreproPath= '';
    defaultCsvPreproPath = '';
    defaultSetPreproPath = '';
    defaultDiagnosticName = '_diagnostic_test';
    defaultEeglabPath = '';
    defaultRawFilepath = '';
    
    defaultStoreSettings= false;
    defaultSettingName = 'default';
    defaultSilencewarning = false;
    defaultPathInfo = struct;
    
    
    p = inputParser;
    validStringChar= @(x) isstring(x) || ischar(x);
    validBool= @(x) islogical(x);
    validStruct = @(x) isstruct(x);
    validPath = @(x) isfolder(x);
    
    p.addOptional('path_info', defaultPathInfo, validStruct);
    
    p.addParameter('datasets_path', defaultDatasetPath, validStringChar);
    p.addParameter('output_path', defaultOutputPath, validStringChar);
    
    p.addParameter('output_mat_path', defaultMatPreproPath, validPath);
    p.addParameter('output_csv_path', defaultCsvPreproPath, validPath);
    p.addParameter('output_set_path', defaultSetPreproPath, validPath);
    
    p.addParameter('eeglab_path', defaultEeglabPath, validStringChar);
    
    p.addParameter('raw_filepath', defaultRawFilepath, validStringChar);
    
    p.addParameter('diagnostic_folder_name', defaultDiagnosticName, validStringChar);
    
    p.addParameter('store_settings', defaultStoreSettings, validBool);
    p.addParameter('setting_name', defaultSettingName, validStringChar);
    p.addParameter('silence_warn', defaultSilencewarning, validBool);
    parse(p, varargin{:});

    % Create a struct to store the save information
    % since there are some fields which are automatically set, it is
    % simpler to check that all input params are present in the path_info
    % struct
    if  ~isempty(fieldnames(p.Results.path_info)) &&  ...
        length( intersect(fieldnames(p.Results.path_info), p.Parameters') )==8

        param2set = setdiff( p.Parameters(1:end-3), [p.UsingDefaults 'path_info']);
        path_info = p.Results.path_info;
        for i = 1:length(param2set)
                path_info.(param2set{i}) = p.Results.(param2set{i});          
        end     

    else
        path_info = struct( 'datasets_path', p.Results.datasets_path, ...  
                                       'output_path', p.Results.output_path, ... 
                                       'output_mat_path', p.Results.output_mat_path, ... 
                                       'output_csv_path', p.Results.output_csv_path, ... 
                                       'output_set_path', p.Results.output_set_path, ...
                                       'eeglab_path', p.Results.eeglab_path, ...
                                       'current_path', pwd, ... 
                                       'diagnostic_folder_name', p.Results.diagnostic_folder_name, ... 
                                       'raw_filepath', p.Results.raw_filepath, ... 
                                       'lib_path', filePath, ...  
                                       'git_path', filePath(1:length(filePath)-6) ...  
                                     );
    end
    
    % conversion to char if needed
    path_fields = fieldnames(path_info);
    for i = 1:length(path_fields)
        if ~ischar(path_info.(path_fields{i}))
            path_info.(path_fields{i}) = char( path_info.(path_fields{i})  );
        end
    end
    
    % add '/' at the end of some paths if not already included
    % it is necessary for BIDSAlign when it construct the path to a file to
    % preprocess
    if isempty(path_info.datasets_path)
        if ~p.Results.silence_warn
            warning("dataset_path not given. Remember to set it or give it in input to the 'process_all' function")
        end
    else
        if path_info.datasets_path(end) ~= '/'
            path_info.datasets_path = [path_info.datasets_path '/'];
        end
    end
    if ~isempty(path_info.output_path) && path_info.output_path(end) ~= '/'
        path_info.output_path = [path_info.output_path '/'];
    end
    if ~isempty(path_info.output_mat_path) && path_info.output_mat_path(end) ~= '/'
        path_info.output_mat_path = [path_info.output_mat_path '/'];
    end
    if ~isempty(path_info.output_csv_path) && path_info.output_csv_path(end) ~= '/'
        path_info.output_csv_path = [path_info.output_csv_path '/'];
    end
    if ~isempty(path_info.output_set_path) && path_info.output_set_path(end) ~= '/'
        path_info.output_set_path = [path_info.output_set_path '/'];
    end
    
    
    check_path_info(path_info);
     % store settings if asked to do so
     if p.Results.store_settings
         filePath = mfilename('fullpath');
         if not( isfolder( [filePath(1:length(filePath)-13)  '/default_settings/' p.Results.setting_name]) )
             mkdir( [filePath(1:length(filePath)-13)  '/default_settings/'] , p.Results.setting_name)
         end
         save( [ filePath(1:length(filePath)-13)  '/default_settings/' p.Results.setting_name '/path_info.mat'], 'path_info');
     end

end