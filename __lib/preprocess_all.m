%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Script for processing EEG DATASET with BIDS STRUCTURE    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear all variables, close figures, and clear the command window

%module unload matlab/2019a
%module load matlab/2022a


clear all
close all
clc

%% Initialize
% Launch EEGLAB and add necessary plugins
eeglab_path = '/home/zanola/eeglab2023.0/';
addpath(eeglab_path);

try
    eeglab;
    close;
catch
    error("ERROR: EEGLAB NOT FOUND ON MATLAB PATH");
end

% Launch the parallel pool for parallel computing (if available)
%try
%     parpool;
%catch
%end

%% Set Inputs
% Set the root path of the EEG datasets (server)
root_folder_path    = '/home/zanola/eeg_datasets/'; %INPUT
root_data_path       = '/data/zanola/'
root_datasets_path  = [root_data_path 'datasets/'];  %INPUT  /readonly/openeuro
git_path            = '/home/zanola/eeg_datasets/EEG_ML_dataset/';  %INPUT

% Set the root path of the EEG datasets (local)
% root_folder_path    = 'E:/02_Documenti/05_PhD/1°_anno/EEG_Prep/'; %INPUT
% root_datasets_path  = 'E:/02_Documenti/05_PhD/1°_anno/EEG_Prep/Datasets/';  %INPUT
% git_path            = 'E:/02_Documenti/05_PhD/1°_anno/EEG_Prep/EEG_ML_dataset/';  %INPUT

lib_path            = [git_path '__lib']; 
addpath(lib_path);

% Set the name of the current dataset
dataset_name = ['MPI_LEMON'];                                                         %INPUT

% Create a struct to store the save information                            %INPUT
save_info = struct('save_data',true, ...
                   'save_data_as','matrix', ...
                   'save_set', false,...
                   'save_struct',true, ...
                   'save_marker',false);

% Set the parameters for preprocessing
params_info = struct('low_freq',0.1,...                                    %INPUT
                     'high_freq',49, ...
                     'sampling_rate',250, ...
                     'n_ica',15, ...
                     'non_linearity_ica','tanh', ...
                     'standard_ref','CZ', ...
                     'interpol_method','spherical',...
                     'flatlineC',5,...
                     'channelC',0.7,...
                     'lineC',4);

%Set how many files to preprocess
numbers_files = struct('N_subj','all','N_sess','all','N_obj','all');                   %INPUT
%numbers_files = struct('N_subj',1,'N_sess',1,'N_obj',1);

% Read the dataset information from a tsv file
dataset_info_filename = 'DATASET_INFO.tsv';                               %INPUT
%dataset_info_filename = 'dataset_info_debug.tsv';
dataset_info = readtable([git_path dataset_info_filename],'format','%f%s%s%s%s%s%s%s%f%s%s%s%s','filetype','text');

% Check if exist otherwise create mat_preprocessed_folder
mat_preprocessed_folder   = [root_data_path '_mat_preprocessed/'];     %INPUT
if ~exist(mat_preprocessed_folder, 'dir')
   mkdir(mat_preprocessed_folder)
end
% Check if exist otherwise create csv_marker_files folder
csv_preprocessed_folder   = [root_data_path '_csv_marker_files/'];     %INPUT
if ~exist(csv_preprocessed_folder, 'dir') && save_info.save_marker 
    mkdir(csv_preprocessed_folder)
end

% Set the name for the folders with diagnostic tests
diagnostic_folder_name = '_test';                                          %INPUT

%Create two use modes: if dataset name is specified, preprocess only that
%dataset otherwise, preprocess all the dataset.
if isempty(dataset_name)
   for i=1:height(dataset_info) %<< parfor HERE
        dataset_name = dataset_info.dataset_name{i};
        fprintf([' \t\t\t\t\t\t\t\t --- PREPROCESSING DATASET:' dataset_name ' ---\n']);

        % Preprocess the dataset
        [~, ~] = preprocess_dataset(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                    mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name, numbers_files);
    end  
else
        % Preprocess a specific dataset
        [~, DATA_STRUCT] = preprocess_dataset(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                              mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name, numbers_files);
end
