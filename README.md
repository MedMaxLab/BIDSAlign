# EEG_ML_dataset
This repository contain a MATLAB library for processing public dataset with BIDS structure.
This is the reference repository for the paper < >.

## Preparation Steps
You have to create a folder where you will store all the datasets present in DATASET_INFO.csv.

# Usage Modalities
This library allows 3 way of using:
1. Preprocess the specified file.
You have to specify the dataset name, from which the file is taken, the filename and the corresponding filepath. The modality is activate through the variable single_file.
```
single_file = true;
dataset_name = ['UC_SD'];
raw_filename = ['sub-hc10_ses-hc_task-rest_eeg.bdf']; 
raw_filepath = ['E:\02_Documenti\05_PhD\1°_anno\EEG_Prep\Datasets\ds002778\sub-hc10\ses-hc\eeg\'];
```
2. Preprocess the entire specified dataset.
You have to specify the dataset name and number of subjects, sessions and objects you to want to preprocess. The options are a specified number or 'all', if you want to preprocess the entire dataset.
```
single_file = false;
dataset_name = ['UC_SD'];
numbers_files = struct('N_subj','all','N_sess','all','N_obj','all'); 
```
3. Preprocess all the dataset contained in DATASET_INFO.csv
You have to specify only number of subjects, sessions and objects you to want to preprocess.
```
single_file = false;
dataset_name = [];
numbers_files = struct('N_subj','all','N_sess','all','N_obj','all'); 
```
