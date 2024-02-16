
% Script: Preprocess EEG Datasets with BIDS Structure
% Description: Preprocesses multiple EEG datasets with a BIDS structure,
% applying various preprocessing steps and saving the preprocessed data.
%
% Note: This script requires EEGLAB to be installed and configured.
% You need to set appropriate paths and parameters before running the script.
% 
% Author: [Andrea Zanola, Federico Del Pup]
% Date: [25/01/2024]

%% Clear Workspace and Initialize
clear
close all
clc

%% Set General Variables
modality = 'local';                          % or local
use_parpool = false;                         % use parpool if available
dataset_info_filename = 'DATASET_INFO.tsv';  % Set the name of the dataset info file 
verbose = true;                             % Set the verbosity level
current_path = pwd;
solve_nogui = false;
setting_name = 'test_dev_';

%% Select Modality (preprocess all, single dataset or single file)
single_file  = false;               % preprocess a single file
dataset_name = ['EEG_3Stim'];  % Set the name of the current dataset

raw_filename = [];                % file name to give in case of single file
raw_filepath = [];                 % path to file in case of single file preprocessing

%% Select parameters 

%Create a struct to store selection information
% selection info tells which subjects to select from 
% each dataset based on given sets
selection_info = struct('sub_i',[],...
                        'sub_f',[],...
                        'ses_i',[1],...
                        'ses_f',[1],...
                        'obj_i',[],...
                        'obj_f',[],...
                        'select_subjects',true,...
                        'label_name','Group',...
                        'label_value','CTL',...
                        'subjects_totake',{{}},...
                        'session_totake',{{}},...
                        'task_totake', {{}});

% Create a struct to store the save information
% save_info tells which data must be saved (or not)
% after preprocessing
save_info = struct('save_data',true, ...
                   'save_data_as', 'matrix', ...
                   'save_set', true,...
                   'save_struct',false, ...
                   'save_marker',false,...
                   'set_label', 'C_PIPEF');

% Set the parameters for preprocessing
% params_info tells which operations and configuration
% use when preprocessing an eeg file
params_info = struct('low_freq',1,...                          %filtering                              
                     'high_freq',45, ...                          %filtering
                     'sampling_rate',250, ...                 %resampling
                     'standard_ref','COMMON', ...        %standard ref
                     'interpol_method','spherical',...     %interpolation
                     'flatlineC',5,...                               %1° ASR
                     'channelC',0.8,...                          %1° ASR
                     'lineC',4, ...                                   %1° ASR
                     'burstC',20,...                               %2° ASR
                     'windowC',0.25,...                        %2° ASR
                     'burstR','on',...                             %2° ASR
                     'th_reject',250,...                        %amplitude threshold in uV
                     'ica_type','fastica',...                     %ICA
                     'non_linearity','tanh',...                  %ICA
                     'n_ica',30,...                                  %ICA
                     'ic_rej_type','iclabel',... %'mara','iclabel',''-> no rejection;
                     'iclabel_thresholds', [0 0.1; 0.9 1; 0.9 1;  0.9 1;  0.9 1;  0.9 1;  0.9 1],...
                     'mara_threshold', 0.9,...
                     'dt_i',5,...                                 % segment removal [s]
                     'dt_f',5,...                                 % segment removal [s]
                     'prep_steps', ...                            % preprocessing steps to perform
                                  struct('rmchannels' , true,...
                                         'rmsegments' , true,...
                                         'rmbaseline' , true,...
                                         'resampling' , true,...
                                         'filtering'  , true,...
                                         'ICA'        , false,...
                                         'ICrejection', true, ...
                                         'ASR'        , true, ...
                                         'rereference', true));

%% Set Paths

% currently this file allows to switch between path 
% from two modality. Since storage space and
% permission are different between local and server
% (remote) platforms, the two configurations are 
% set to local and server. Feel free to change names 
% We encourage you to work using the process_all
% function, as it allow to use an indefinite and complete
% (meaning that other structs are involved) setting
% configurations

%% copy of path info
filePath = mfilename('fullpath');
filePath = filePath(1:length(filePath)-14);

path_info = set_path_info('silence_warn',true);

if strcmp(modality,'server')
    % set various paths
    path_info.datasets_path = '';
    path_info.output_path = '';
    path_info.output_mat_path = '';
    path_info.output_csv_path = '';
    path_info.output_set_path = '';
    path_info.eeglab_path = '';
    
    path_info.git_path  = filePath(1:length(filePath)-6);
    path_info.lib_path  = filePath; 
    addpath(path_info.lib_path);

elseif strcmp(modality,'local')
    
    % set various paths
    path_info.datasets_path = '';
    path_info.output_path = '';
    path_info.output_mat_path = '';
    path_info.output_csv_path = '';
    path_info.output_set_path = '';
    path_info.eeglab_path = '';
    
    path_info.git_path = filePath(1:length(filePath)-6);
    path_info.lib_path  = filePath; 
else
    error(['ERROR: UNRECOGNAIZED MODALITY: ' modality]);
end

if strcmp(setting_name, 'test_dev_')
    path_info = load_settings(setting_name, 'path');
end

%% additional checks on given paths

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
   error("dataset_path not given. Be sure it is stored in path_info or give it in input when calling this function")
end

% if single file mode must be performes, check
% that such file exists in the current dataset path
if single_file
   if isempty(raw_filename)
       if isempty(path_info.raw_filepath)
           error("cannot process a single file without knowing its name or path." + ...
                "Please give a proper file name as char or string using the " + ...
                " 'raw_filename' argument or set it in the presaved path_info struct");
       elseif ~isfile(path_info.raw_filepath)
           error("path_info stored a path which is not valid. Please correct it or give in input a new one" + ...
               " using the 'raw_filename' argument"); 
       end
   else
        if isfile(raw_filename)
            raw_filepath= raw_filename;
        else
            path_file_struct = dir([path_info.dataset_path '**/' raw_filename]);
            if isempty(path_file_struct)
                error("cannot find current raw file. Please check that " + ...
                    "dataset path and raw_filename are correct." + ...
                    "Give raw_filename with the extension, for example 'sub-01-raw-eeg.bdf' ")
            else
                path_info.raw_filepath = [path_file_struct.folder '/' path_file_struct.name];
            end
        end
   end
end


% check that output path is valid
if ~isfolder(path_info.output_path)
    error("given 'output_path' is not a correct path to an existing directory")
end

% if given, check that custom output path
% for mat files is valid
if ~isempty(path_info.output_mat_path)
    if ~isfolder(path_info.output_mat_path)
        error(" if given, 'output_mat_path' must be a valid path to an existing directory")
    end
end

% if given, check that custom output path
% for csv files is valid
if ~isempty(path_info.output_csv_path)
    if ~isfolder(path_info.output_csv_path)
        error(" if given, 'output_table_path' must be a valid path to an existing directory")
    end
end

% if given, check that custom output path
% for set files is valid
if ~isempty(path_info.output_set_path)
    if ~isfolder(path_info.output_set_path)
        error(" if given, 'output_set_path' must be a valid path to an existing directory")
    end
end

%% create output folders 

% Check if exist otherwise create mat_preprocessed folder
if isempty(path_info.output_mat_path)
    path_info.output_mat_path   = [path_info.output_path '_mat_preprocessed/'];     
    if ~exist(path_info.output_mat_path, 'dir')
       mkdir(path_info.output_mat_path)
    end
end

% Check if exist otherwise create csv_marker_files folder
if isempty(path_info.output_csv_path) 
    path_info.output_csv_path   = [path_info.output_path '_csv_marker_files/'];     
    if ~exist(path_info.output_csv_path, 'dir') && save_info.save_marker 
        mkdir(path_info.output_csv_path)
    end   
end

% Check if exist otherwise create set_files folder
if isempty(path_info.output_set_path) 
    path_info.output_set_path   = [path_info.output_path '_set_preprocessed/'];     
    if ~exist(path_info.output_set_path, 'dir') && save_info.save_set 
        mkdir(path_info.output_set_path)
    end   
end

%% open eeglab

% sometimes eeglab nogui fail to load plugins.
% if this happens, use the solve_nogui boolean 
% and 'eeglab; close' commands will be used
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

%% Initialize object info struct
obj_info.raw_filename = raw_filename;
obj_info.raw_filepath = raw_filepath;

%% Import Dataset Information
% Read the dataset information from a tsv file                            
dataset_info = readtable([path_info.git_path dataset_info_filename], ...
    'format','%f%s%s%s%s%s%s%s%s%f','filetype','text');
check_loaded_table( dataset_info);

%% Lunch Preprocess of the Datasets
% Create two use modes: if dataset name is specified, preprocess only that
% dataset otherwise, preprocess all the dataset in dataset_info.

if use_parpool && isempty(dataset_name) && ~single_file
    %Launch the parallel pool for parallel computing (if available)
    poolobj = gcp();
    if ~poolobj.Connected
        try
            parpool;
        catch
            error('ERROR: PARPOOL NOT AVAILABLE SET use_parpool TO FALSE');
        end
    end
    % Launch Parpool
    parfor i=1:height(dataset_info)
        if verbose
            fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' dataset_info.dataset_name{i} ' ---\n']);
        end
        
        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
        data_info = table2struct(dataset_info(i,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{i}, ','); 

        % Preprocess all the dataset
        [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, path_info, selection_info, verbose);
    end  

elseif isempty(dataset_name) && ~single_file
   for i=1:height(dataset_info) 
       if verbose
            fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' dataset_info.dataset_name{i} ' ---\n']);
       end

        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
        data_info = table2struct(dataset_info(i,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{i}, ','); 

        % Preprocess all the dataset
        [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, path_info, selection_info, verbose);
    end  
else
    if single_file
        if verbose
            warning('PARPOOL NOT USED SINCE SPECIFIC FILE WAS SELECTED');
        end

        % Extract Dataset Code Name
        out = regexp(obj_info.raw_filepath ,'\','split');
        dataset_code = out{end-4};

        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_code, dataset_code));
        data_info = table2struct(dataset_info(dataset_index,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{dataset_index}, ',');

        disp(dataset_name)
        [~,DATA_STRUCT] = preprocess_subject(data_info, save_info, params_info, path_info, obj_info, verbose);
    else
        if verbose
            warning('PARPOOL NOT USED SINCE SPECIFIC DATASET WAS SELECTED');
        end

        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
        data_info = table2struct(dataset_info(dataset_index,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{dataset_index}, ','); 

        % Preprocess a specific dataset
        [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, path_info, selection_info, verbose);
    end
end
cd(current_path)
