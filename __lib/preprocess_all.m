%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Script for processing EEG DATASET with BIDS STRUCTURE    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear all variables, close figures, and clear the command window
clear all
close all
clc

%% Initialize
% Launch EEGLAB and add necessary plugins
try
    eeglab;
    close;
catch
    error("ERROR: EEGLAB NOT FOUND ON MATLAB PATH");
end

% Launch the parallel pool for parallel computing (if available)
% try
%     parpool;
% catch
% end

%% Set Inputs
% Set the root path of the EEG datasets
root_datasets_path = 'E:\02_Documenti\05_PhD\1°_anno\EEG_Prep\Datasets\';  %INPUT

% Read the dataset information from an Excel file
dataset_info_filename = 'DATASET_INFO.xlsx';                               %INPUT
dataset_info = readtable([root_datasets_path dataset_info_filename]);

% Set the name of the current dataset
dataset_name = ['EEG_3Stim'];                                                %INPUT

% Create a struct to store the save information                            %INPUT
save_info = struct('save_data',true, ...
                   'save_data_as','matrix', ...
                   'save_struct',true, ...
                   'save_marker',false);

% Set the parameters for preprocessing
params_info = struct('low_freq',0.1,...                                    %INPUT
                     'high_freq',40, ...
                     'sampling_rate',250, ...
                     'n_ica',15, ...
                     'non_linearity_ica','tanh', ...
                     'standard_ref','CZ', ...
                     'interpol_method','spherical');

% Check if a change in architecture is needed
change_architecture_need  = false;                                         %INPUT

% Check if exist otherwise create mat_preprocessed_folder
mat_preprocessed_folder   = [root_datasets_path '_mat_preprocessed\'];     %INPUT
if ~exist(mat_preprocessed_folder, 'dir')
   mkdir(mat_preprocessed_folder)
end
% Check if exist otherwise create csv_marker_files folder
csv_preprocessed_folder   = [root_datasets_path '_csv_marker_files\'];     %INPUT
if ~exist(csv_preprocessed_folder, 'dir')
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
        [~, ~] = preprocess_dataset(root_datasets_path, dataset_info, dataset_name,save_info,params_info, ...
                                                change_architecture_need,mat_preprocessed_folder,csv_preprocessed_folder, ...
                                                diagnostic_folder_name);
    end  
else
        % Preprocess the dataset
        [~, ~] = preprocess_dataset(root_datasets_path,dataset_info,dataset_name,save_info,params_info, ...
                                                change_architecture_need,mat_preprocessed_folder,csv_preprocessed_folder, ...
                                                diagnostic_folder_name);
end
