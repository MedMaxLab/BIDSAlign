
% Script: Preprocess EEG Datasets with BIDS Structure
% Description: Preprocesses multiple EEG datasets with a BIDS structure,
% applying various preprocessing steps and saving the preprocessed data.
%
% Note: This script requires EEGLAB to be installed and configured.
% You need to set appropriate paths and parameters before running the script.
% 
% Author: [Andrea Zanola]
% Date: [04/10/2023]

%% Clear Workspace and Initialize
clear all
close all
clc

modality = 'local'; % or local
use_parpool = true; % use parpool if available
dataset_info_filename = 'DATASET_INFO.tsv';  % Set the name of the dataset info file 
diagnostic_folder_name = '_test';  % Set the name for the folders with diagnostic tests

single_file = false; % preprocess a single file

%% Select Preferences
% Set the name of the current dataset
dataset_name = [];  

% Set the name and the path of the file
raw_filename = []; %raw_filename = ['sub-hc10_ses-hc_task-rest_eeg.bdf']; 
raw_filepath = []; %raw_filepath = ['E:\02_Documenti\05_PhD\1°_anno\EEG_Prep\Datasets\ds002778\sub-hc10\ses-hc\eeg\'];


% Set how many files to preprocess (insert a number or 'all')             
numbers_files = struct('N_subj',1,'N_sess',1,'N_obj',1);  

%% Select parameters 
% Create a struct to store the save information                            
save_info = struct('save_data',true, ...
                   'save_data_as','matrix', ...
                   'save_set', false,...
                   'save_struct',true, ...
                   'save_marker',false);

% Set the parameters for preprocessing
params_info = struct('low_freq',0.1,...                     %filtering                              
                     'high_freq',49, ...                    %filtering
                     'sampling_rate',250, ...               %resampling
                     'standard_ref','CZ', ...               %standard ref
                     'interpol_method','spherical',...      %interpolation
                     'flatlineC',5,...                      %1° ASR
                     'channelC',0.7,...                     %1° ASR
                     'lineC',4, ...                         %1° ASR
                     'burstC',20,...                        %2° ASR
                     'windowC',0.25,...                     %2° ASR
                     'burstR','on',...                      %2° ASR
                     'th_reject',1000,... %uV               %amplitude threshold
                     'ica_type','fastica',...               %ICA
                     'non_linearity','tanh',...             %ICA
                     'n_ica',25,...                         %ICA
                     'dt_i',4,...                           %segment removal
                     'dt_f',4,...                           %segment removal
                     'prep_steps',struct('rmchannels'     ,true,...
                                         'rmsegments',true,...
                                         'rmbaseline'     ,true,...
                                         'resampling'     ,true,...
                                         'filtering'      ,true,...
                                         'rereference'    ,true,...
                                         'ICA'            ,false,...
                                         'ASR'            ,true) );

%% Check Modality
% Check the modality of single subject
if single_file
    if isempty(raw_filepath) || isempty(raw_filename) 
        error('ERROR: SPECIFY THE NAME AND THE PATH OF THE DESIRED FILE');
    end
end

% Check number of files requested if we are preprocessing an entire dataset
if ~single_file
    if numbers_files.N_subj<=0 || numbers_files.N_sess<=0 || numbers_files.N_obj<=0 ||...
        (ischar(numbers_files.N_subj) && ~strcmp(numbers_files.N_subj,'all')) ||...
        (ischar(numbers_files.N_sess) && ~strcmp(numbers_files.N_sess,'all')) ||...
        (ischar(numbers_files.N_obj) && ~strcmp(numbers_files.N_obj,'all'))
    
        error('ERROR: MULTIPLE IN THE INPUT VALUES IN numbers_files');
    end
end

% Set paths and check modality
if strcmp(modality,'server')

    % Select MATLAB Version
    module unload matlab/2019a
    module load matlab/2022a

    % Set eeglab path
    eeglab_path = '/home/zanola/eeglab2023.0/';
    addpath(eeglab_path);

    % Set various paths (server)
    root_folder_path    = '/home/zanola/eeg_datasets/'; 
    root_data_path      = '/data/zanola/';  
    root_datasets_path  = [root_data_path 'datasets/'];  
    git_path            = [root_folder_path 'EEG_ML_dataset/'];
    lib_path            = [git_path '__lib']; 
    addpath(lib_path);

elseif strcmp(modality,'local')

    eeglab_path = 'E:/02_Documenti/05_PhD/Lezioni/eeglab2023.0';
    addpath(eeglab_path);

    % Set various paths (local)
    root_folder_path    = 'E:/02_Documenti/05_PhD/1°_anno/EEG_Prep/'; 
    root_datasets_path  = [root_folder_path 'Datasets/']; 
    root_data_path      = root_datasets_path;
    git_path            = [root_folder_path 'EEG_ML_dataset/']; 
    lib_path            = [git_path '__lib']; 
    addpath(lib_path);

else
    error(['ERROR: UNRECOGNAIZED MODALITY: ' modality]);
end


%% Import Dataset Information
% Read the dataset information from a tsv file                            
dataset_info = readtable([git_path dataset_info_filename],'format','%f%s%s%s%s%s%s%s%f%s%s%s%s','filetype','text');

% Check for errors
for i=1:height(dataset_info) 
    matching_rows = strcmp(dataset_info.dataset_name, dataset_info.dataset_name{i});
    c = sum(matching_rows);
    
    if c == 0
        error('ERROR: CHECK THE DATASET NAME');
    elseif c > 1
        error(['ERROR: MULTIPLE DATASETS HAVE THE SAME NAME IN ' dataset_info_filename]);
    end
end

%% Set Folders Names
% Check if exist otherwise create mat_preprocessed_folder
mat_preprocessed_folder   = [root_data_path '_mat_preprocessed/'];     
if ~exist(mat_preprocessed_folder, 'dir')
   mkdir(mat_preprocessed_folder)
end
% Check if exist otherwise create csv_marker_files folder
csv_preprocessed_folder   = [root_data_path '_csv_marker_files/'];     
if ~exist(csv_preprocessed_folder, 'dir') && save_info.save_marker 
    mkdir(csv_preprocessed_folder)
end   

%% Lunch Preprocess of the Datasets
% Create two use modes: if dataset name is specified, preprocess only that
% dataset otherwise, preprocess all the dataset in dataset_info.

if use_parpool && isempty(dataset_name) && ~single_file

    %% Lunch Parpool
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
        dataset_name = dataset_info.dataset_name{i};
        fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' dataset_name ' ---\n']);

        % Preprocess all the dataset
        [~,DATA_STRUCT] = preprocess_dataset(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                             mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name, numbers_files);
    end  

elseif isempty(dataset_name) && ~single_file
   for i=1:height(dataset_info) 
        dataset_name = dataset_info.dataset_name{i};
        fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' dataset_name ' ---\n']);
    
        % Preprocess all the dataset
        [~,DATA_STRUCT] = preprocess_dataset(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                             mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name, numbers_files);
    end  
else
    if use_parpool && ~single_file
        warning('PARPOOL NOT USED SINCE SPECIFIC DATASET WAS SELECTED');
    else
        warning('PARPOOL NOT USED SINCE SPECIFIC FILE WAS SELECTED');
    end

    if single_file
        % Preprocess a specific file
        out = regexp(raw_filepath ,'\','split');
        dataset_code = out{end-4};
        name = dataset_info.dataset_name(find(strcmp(dataset_info.dataset_code, dataset_code)));
        dataset_name = name{:};
        [~,DATA_STRUCT] = preprocess_subject(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                             mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name,...
                                             raw_filename, raw_filepath);
    else   
        % Preprocess a specific dataset
        [~,DATA_STRUCT] = preprocess_dataset(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                             mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name, numbers_files);  
    end
end
