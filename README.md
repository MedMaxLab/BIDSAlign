# EEG_ML_dataset
This is the reference repository for the paper < >.
This library called < > preprocess public dataset saved in BIDS structure, uniforming the outputs to a common template.


## Preparation Steps
You have to create a folder where you will store all the datasets present in DATASET_INFO.csv. 
DATASET_INFO.csv is a file structured in the following way:
| dataset_number_reference | dataset_name     | dataset_code | channel_location_filename | channel_system | channel_reference | channel_to_remove | eeg_file_extension | samp_rate | select_subjects | label_name | label_value |
|--------------------------|------------------|--------------|---------------------------|----------------|-------------------|-------------------|--------------------|-----------|-----------------|------------|-------------|
| 1                        | HBN_EO_EC        | ds004186     | loaded                    | GSN129         | CZ                |                   | .set               | no        | no              |            |             |
| 2                        | Test_Retest_Rest | ds004148     |                           | 10_10          | FCZ               |                   | .vhdr              | 500       | no              |            |             |

Please remember that you have to specify the name of the dataset, not the name of the folder where the dataset is stored, that instead corresponds to *dataset_code* in DATASET_INFO.csv. 
Since this project uses institutional computing resources, you can choose between two set of paths ('local' or 'server') setting the variable *modality*.
If you want to use parallel computing resources please set:
```
use_parpool = true;
```
This will allows to process multiple datasets in parallel.


# BIDS Format
This library can preprocess datasets structured with a BIDS format. Thus is expected in input a dataset structured as shown in https://bids.neuroimaging.io/ .
However you can use the function *create_dataset_architecture.m* to change in-place the folder structure of the dataset. For all the cases handled, please see <>.
As specified by the BIDS format, *participant_file.tsv* should be stored in the dataset folder.
If other diagnostical tests have been performed and stored in .csv files, please create a diagnostical folder and set the corresponding name:
```
diagnostic_folder_name = '_test';
```
Folders inside the dataset folder, should have the name of the corresponding subject. Thus the subjects names in *participants.tsv* should match the folder names.


# Channel Location
If a specific channel location should be used for the entire dataset, please enter the filename in the corresponding column in DATASET_INFO.csv. 
If the eeg files have already the channel coordinates, please enter 'loaded' in the corresponding colum in DATASET_INFO.csv.
If no channel location is specified, and the field is left empty, than *_electrodes.tsv* files are used.
*_electrodes.tsv* and *_channels.tsv* files could be saved in every position inside the BIDS structure. These files will be used for all the eeg recording contained in the folder position.


# Usage Modalities
This library allows 3 way of using:
1. Preprocess the specified file.
You have to specify the dataset name, from which the file is taken, the filename and the corresponding filepath. The modality is activated with the variable *single_file*.
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
3. Preprocess all the datasets contained in DATASET_INFO.csv
You have to specify only number of subjects, sessions and objects you to want to preprocess.
```
single_file = false;
dataset_name = [];
numbers_files = struct('N_subj','all','N_sess','all','N_obj','all'); 
```


# Preprocessing
The structure *params_info* contains all the parameters you need to set. Please note that the variable *params_info.prep_steps* is another structure in which you can specify the preprocessing steps you want to perform. 
In the current version of the library, the following preprocessing steps are available:
1. Channels removal
2. Segment removal
3. Baseline removal
4. Resampling
5. Filtering
6. Rereference
7. ICA
8. ASR


# Compatibility
The library was written in MATLAB 2021, EEGLAB 2023.0, requiring the following plug-in:
- "Biosig" v3.8.1
- "FastICA" v25
- "Fileio" v20230716
- "bva-io" v1.71
- "clean_rawdata" v2.8
- "dipfit" v5.2
- "firfilt" v2.7.1

# Versions
v1.0 - Library associated to the pubblication < >.




