# EEG_ML_dataset
This is the reference repository for the paper < >.
This library called < > preprocess public dataset saved in BIDS structure, uniforming the outputs to a common template.

## Preparation Steps
You have to create a folder where you will store all the datasets present in DATASET_INFO.csv. 
DATASET_INFO.csv is a file structured in the following way:
| dataset_number_reference | dataset_name     | dataset_code | channel_location_filename | channel_system | channel_reference | channel_to_remove | eeg_file_extension | samp_rate | select_subjects | label_name | label_value | change_arch |
|--------------------------|------------------|--------------|---------------------------|----------------|-------------------|-------------------|--------------------|-----------|-----------------|------------|-------------|-------------|
| 1                        | HBN_EO_EC        | ds004186     | loaded                    | GSN129         | CZ                |                   | .set               | no        | no              |            |             |             |
| 2                        | Test_Retest_Rest | ds004148     |                           | 10_10          | FCZ               |                   | .vhdr              | 500       | no              |            |             |             |

Please remember that you have to specify the name of the dataset not the name of the folder that instead corresponds to dataset code in DATASET_INFO.csv. 
Since this project uses institutional computing resources, you can choose between two paths, 'local' or 'server' and setting the variable *modality*.
If you want to use parallel computing resources please set:
```
TO DO;
```
This will allows to process multiple datasets in parallel.

# BIDS Format
This library can preprocess datasets structured with a BIDS format. Thus is expected the same structure of https://bids.neuroimaging.io/ .
However if you set:
```
use_parpool = true;
```
you can change in-place the folder structure of the dataset. For all the cases handled, please see <>.

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




