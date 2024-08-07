
% Script: Preprocess EEG Datasets with BIDS Structure
% Description: Preprocesses multiple EEG datasets with a BIDS structure,
%              applying various preprocessing steps and saving the preprocessed data.
%
% Note: This script requires EEGLAB to be installed and configured.
%       Check the BIDSAlign description on GitHub to see the full dependency list.
%       You need to set appropriate paths and parameters before running the script.
%       Comments are there to help you set those parameters according to your needs.
% 
% Author: [Andrea Zanola, Federico Del Pup]
% Date: [25/01/2024]

%% Clear Workspace and Initialize
clear
close all
clc

%% add path to bidsalign functions
[~] = evalc('bidsalign nogui');

%% Set General Variables
modality              = 'modename';         % choose ['local'|'server'|'modename']
use_parpool           = false;              % use parpool if available
dataset_info_filename = 'DATASET_INFO.tsv'; % Set the name of the dataset info file 
verbose               = true;               % Set the verbosity level
current_path          = pwd;                % just to return here
solve_nogui           = false;              % leave it to false, if problems set to true
setting_name          = 'test_dev_';        % test_dev_ is a set ignored by GIT

%% Select Modality (preprocess all, single dataset or single file)
single_file  = false;        % preprocess a single file
dataset_name = '';           % Set the name of the current dataset
raw_filename = '';           % file name or full path to give for single file mode

%% Set selection parameters

% Create a struct to store selection information
% selection info tells which subjects to select from 
% each dataset based on given sets
selection_info = struct( ...
    'sub_i',           [], ...
    'sub_f',           [], ...
    'ses_i',           [], ...
    'ses_f',           [], ...
    'obj_i',           [], ...
    'obj_f',           [], ...
    'select_subjects', false, ...
    'label_name',      {{ }} , ...
    'label_value',     {{ }} , ...
    'subjects_totake', {{ }} , ...
    'session_totake',  {{ }} , ...
    'task_totake',     {{ }} ...
);

%% Set save parameters

% Create a struct to store the save information
% save_info tells which data must be saved (or not)
% after preprocessing
save_info = struct( ...
    'save_data',    false, ...
    'save_data_as', 'matrix', ...
    'save_set',     true , ...
    'save_struct',  false, ...
    'save_marker',  false , ...
    'set_label',    'PIPELINE_X' ...
);

%% Set preprocessing parameters

% Set the parameters for preprocessing
% params_info tells which operations and configuration
% use when preprocessing an eeg file
params_info = struct( ...
    'dt_i',               5 , ...                % segment removal [s]
    'dt_f',               5 , ...                % segment removal [s]
    'sampling_rate',      250, ...               % resampling in [Hz]
    'low_freq',           1 , ...                % filtering low freq [Hz]                        
    'high_freq',          45, ...                % filtering high freq [Hz]
    'ica_type',           'fastica' , ...        % ICA 
    'non_linearity',      'tanh' , ...           % ICA
    'n_ica',              30 , ...               % ICA
    'ic_rej_type',        'iclabel' , ...        % 'mara' or 'iclabel'
    'iclabel_thresholds', [ 0 0.1; ...           % brain class
                            0.9 1; ...           % Muscle class
                            0.9 1; ...           % eye class
                            0.9 1; ...           % heart class
                            0.9 1; ...           % line noise class
                            0.9 1; ...           % channel noise class
                            0.9 1 ] , ...        % other class
    'mara_threshold',     0.5 , ...              % MARA threshold
    'wavelet_type',       'coif5', ...           % wICA
    'wavelet_level',      5, ...                 % wICA
    'notchfreq',          50, ...                % notch filter freq for power line [Hz]
    'notchfreq_bw',       4, ...                 % notch filter band for power line [Hz]
    'flatlineC',          5 , ...                % 1° ASR (channel)
    'channelC',           0.8 , ...              % 1° ASR (channel)
    'lineC',              4, ...                 % 1° ASR (channel)
    'burstC',             20 , ...               % 2° ASR (segment)
    'windowC',            0.25 , ...             % 2° ASR (segment)
    'burstR',             'on' , ...             % 2° ASR on = reject, off = correct
    'th_reject',          250 , ...              % amplitude uV
    'interpol_method',    'spherical' , ...      % interpolation
    'standard_ref',       'COMMON', ...          % rereferencing
    'prep_steps', ...     % struct with steps to perform
        struct( ...       % all are boolean variables
            'rmchannels' , true , ...
            'rmsegments' , true , ...
            'rmbaseline' , true , ...
            'resampling' , true , ...
            'filtering'  , true , ...
            'ICA'        , true , ...
            'ICrejection', true, ...
            'wICA'       , true, ...
            'ASR'        , true, ...
            'rereference', true) ...
 );

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

filePath = mfilename('fullpath');
filePath = filePath(1:length(filePath)-14);
path_info = set_path_info('silence_warn',true);

if strcmp(modality,'server')

    % set various paths
    path_info.datasets_path   = ''; %#ok
    path_info.output_path     = '';
    path_info.output_mat_path = '';
    path_info.output_csv_path = '';
    path_info.output_set_path = '';
    path_info.eeglab_path     = '';
    
    path_info.git_path  = filePath(1:length(filePath)-6);
    path_info.lib_path  = filePath; 
    addpath(path_info.lib_path);

elseif strcmp(modality,'local')
    
    % set various paths
    path_info.datasets_path   = ''; %#ok
    path_info.output_path     = '';
    path_info.output_mat_path = '';
    path_info.output_csv_path = '';
    path_info.output_set_path = '';
    path_info.eeglab_path     = '';
    
    path_info.git_path = filePath(1:length(filePath)-6);
    path_info.lib_path = filePath; 
elseif strcmp(modality, 'modename')

    % load a specific setting
    path_info = load_settings(setting_name, 'path');
else
    error(['ERROR: UNRECOGNAIZED MODALITY: ' modality]); %#ok
end

%% Launch preprocessing

EEG_data = preprocess_all( ...
    dataset_info_filename, ...
    'path_info',           path_info, ...
    'preprocess_info',     params_info, ...
    'selection_info',      selection_info, ...
    'save_info',           save_info, ...
    'setting_name',        setting_name, ...
    'single_file',         single_file, ...
    'single_dataset_name', dataset_name, ...
    'single_file_name',    raw_filename, ...
    'use_parpool',         use_parpool, ...
    'solve_nogui',         solve_nogui, ...
    'verbose',             verbose ...
);

cd(current_path)
