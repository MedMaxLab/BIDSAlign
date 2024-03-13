# BIDSAlign
This is the reference repository for the paper < >.
BIDSAlign preprocess public datasets saved in both BIDS and non-BIDS structure, uniforming the outputs to a common template.
For the use of the GUI please see the attached detailed documentation.

## Preparation Steps
In order to successfully use BIDSAlign, check the following steps.

### Datasets List
You have to create a folder where you will store all the datasets present in DATASET_INFO.tsv. 
DATASET_INFO.csv is a file structured in the following way:
| dataset_number_reference | dataset_name     | dataset_code | channel_location_filename | channel_system | channel_reference | channel_to_remove | eeg_file_extension | samp_rate |
|--------------------------|------------------|--------------|---------------------------|----------------|-------------------|-------------------|--------------------|-----------|
| 1                        | HBN_EO_EC        | ds004186     | loaded                    | GSN129         | CZ                |                   | .set               | 500       |
| 2                        | Test_Retest_Rest | ds004148     |                           | 10_10          | FCZ               |                   | .vhdr              | 500       |

Please remember that the name of the folder where the dataset is stored must corresponds to *dataset_code* in DATASET_INFO.csv. 

### BIDS Format
This library can preprocess datasets structured with both BIDS and non-BIDS format. Thus is expected in input a dataset structured as shown in [https://bids.neuroimaging.io/](https://bids-specification.readthedocs.io/en/stable/modality-specific-files/electroencephalography.html) .
However you can use the function *create_dataset_architecture.m* to change in-place the folder structure of the dataset.
As specified by the BIDS format, *participants.tsv* is recommended and should be stored in the dataset folder.

### Channel Location
If a specific channel location should be used for the entire dataset, please enter the filename in the corresponding column in DATASET_INFO.
If the eeg files have already the channel coordinates, please enter 'loaded' in the corresponding colum in DATASET_INFO.
If the default channel location can be used for the dataset, enter 'default' DATASET_INFO.tsv, and it will use the default channel locations present in EEGLAB.
If no channel location is specified, and the field is left empty, than *_electrodes.tsv* files are searched and eventually used.

## Usage Modalities
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
You have to specify the dataset. In this case you can process the entire dataset, a portion, only some subjects or some session, or even preprocess specific groups and/or specific task.
```
single_file = false;
dataset_name = ['UC_SD'];
```
3. Preprocess all the datasets contained in DATASET_INFO
You have to left empty the dataset name and set single file as false.
```
single_file = false;
dataset_name = [];
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

Please note that EEG data are assumed to be saved in $\mu V$.


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




