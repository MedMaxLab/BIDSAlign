
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
%close all
clc

%% Set Variables
modality = 'local'; % or local
use_parpool = false; % use parpool if available
dataset_info_filename = 'DATASET_INFO.tsv';  % Set the name of the dataset info file 
path_info.diagnostic_folder_name = '_test';  % Set the name for the folders with diagnostic tests

%% Select Modality
single_file  = false; % preprocess a single file
dataset_name = ['UC_SD'];  % Set the name of the current dataset

raw_filename = [];%['sub-hc10_ses-hc_task-rest_eeg.bdf']; 
raw_filepath = [];%['E:\02_Documenti\05_PhD\1°_anno\EEG_Prep\Datasets\ds002778\sub-hc10\ses-hc\eeg\'];

%% Select parameters 
%Create a struct to store selection information
selection_info = struct('sub_i',[],...
                        'sub_f',[],...
                        'ses_i',[],...
                        'ses_f',[],...
                        'obj_i',[],...
                        'obj_f',[],...
                        'select_subjects',false,...
                        'label_name','',...
                        'label_value','',...
                        'subjects_totake',{{}},...
                        'session_totake',{{}},...
                        'task_totake', {{}});

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
                     'standard_ref','COMMON', ...               %standard ref
                     'interpol_method','spherical',...      %interpolation
                     'flatlineC',5,...                      %1° ASR
                     'channelC',0.8,...                     %1° ASR
                     'lineC',4, ...                         %1° ASR
                     'burstC',20,...                        %2° ASR
                     'windowC',0.25,...                     %2° ASR
                     'burstR','on',...                      %2° ASR
                     'th_reject',1000,... %uV               %amplitude threshold
                     'ica_type','fastica',...               %ICA
                     'non_linearity','tanh',...             %ICA
                     'n_ica',20,...                         %ICA
                     'dt_i',0,...                          %segment removal [s]
                     'dt_f',0,...                          %segment removal [s]
                     'prep_steps',struct('rmchannels'     ,true,...
                                         'rmsegments'     ,true,...
                                         'rmbaseline'     ,true,...
                                         'resampling'     ,true,...
                                         'filtering'      ,true,...
                                         'rereference'    ,true,...
                                         'ICA'            ,false,...
                                         'ASR'            ,false) );

%% Set Paths
if strcmp(modality,'server')

    % Set eeglab path
    path_info.eeglab_path = '/home/zanola/eeglab2023.0/';
    addpath(path_info.eeglab_path);
    eeglab; close;

    % Set various paths (server)
    path_info.root_folder_path    = '/home/zanola/eeg_datasets/'; 
    path_info.root_data_path      = '/data/zanola/'; 
    path_info.root_datasets_path  = [path_info.root_data_path 'datasets/'];  

    path_info.git_path            = [path_info.root_folder_path 'EEG_ML_dataset/'];
    path_info.lib_path            = [path_info.git_path '__lib']; 
    addpath(path_info.lib_path);

elseif strcmp(modality,'local')

    path_info.eeglab_path = 'E:/02_Documenti/05_PhD/Lezioni/eeglab2023.0';
    addpath(path_info.eeglab_path);
    eeglab; close

    % Set various paths (local)
    path_info.root_folder_path    = 'E:/02_Documenti/05_PhD/1°_anno/EEG_Prep/'; 
    path_info.root_datasets_path  = [path_info.root_folder_path 'Datasets/']; 
    path_info.root_data_path      = path_info.root_datasets_path;


    path_info.git_path            = [path_info.root_folder_path 'EEG_ML_dataset/']; 
    path_info.lib_path            = [path_info.git_path '__lib']; 
    addpath(path_info.lib_path);
else
    error(['ERROR: UNRECOGNAIZED MODALITY: ' modality]);
end

%% Check Parameters
obj_info.raw_filename = raw_filename;
obj_info.raw_filepath = raw_filepath;

%% Import Dataset Information
% Read the dataset information from a tsv file                            
dataset_info = readtable([path_info.git_path dataset_info_filename],'format','%f%s%s%s%s%s%s%s%s%f','filetype','text');

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
path_info.mat_preprocessed_filepath   = [path_info.root_data_path '_mat_preprocessed/'];     
if ~exist(path_info.mat_preprocessed_filepath, 'dir')
   mkdir(path_info.mat_preprocessed_filepath)
end
% Check if exist otherwise create csv_marker_files folder
path_info.csv_preprocessed_folder   = [path_info.root_data_path '_csv_marker_files/'];     
if ~exist(path_info.csv_preprocessed_folder, 'dir') && save_info.save_marker 
    mkdir(path_info.csv_preprocessed_folder)
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
        fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' dataset_info.dataset_name{i} ' ---\n']);
        
        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
        data_info = table2struct(dataset_info(i,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{i}, ','); 

        % Preprocess all the dataset
        [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, path_info, selection_info);
    end  

elseif isempty(dataset_name) && ~single_file
   for i=1:height(dataset_info) 
        fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' dataset_info.dataset_name{i} ' ---\n']);

        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
        data_info = table2struct(dataset_info(i,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{i}, ','); 

        % Preprocess all the dataset
        [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, path_info, selection_info);
    end  
else
    if single_file
        warning('PARPOOL NOT USED SINCE SPECIFIC FILE WAS SELECTED');

        % Extract Dataset Code Name
        out = regexp(obj_info.raw_filepath ,'\','split');
        dataset_code = out{end-4};

        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_code, dataset_code));
        data_info = table2struct(dataset_info(dataset_index,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{dataset_index}, ',');

        disp(dataset_name)
        [~,DATA_STRUCT] = preprocess_subject(data_info, save_info, params_info, path_info, obj_info);
    else   
        warning('PARPOOL NOT USED SINCE SPECIFIC DATASET WAS SELECTED');

        % Create the data_info struct to store dataset-specific information
        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
        data_info = table2struct(dataset_info(dataset_index,:));
        data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{dataset_index}, ','); 

        % Preprocess a specific dataset
        [~,DATA_STRUCT] = preprocess_dataset(data_info, save_info, params_info, path_info, selection_info);
    end
end
