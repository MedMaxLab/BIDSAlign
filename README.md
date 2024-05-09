# BIDSAlign
This is the reference repository for the paper < >.
BIDSAlign preprocess public datasets saved in both BIDS and non-BIDS structure, uniforming the outputs to a common template.
For the use of the GUI please see the attached detailed documentation.

## Preparation Steps
In order to successfully use BIDSAlign, check the following steps.

### Datasets List
You have to create a folder where you will store all the datasets present in DATASET_INFO.tsv, file structured in the following way:
| dataset_number_reference | dataset_name     | dataset_code | channel_location_filename | channel_system | channel_reference | channel_to_remove | eeg_file_extension | samp_rate |
|--------------------------|------------------|--------------|---------------------------|----------------|-------------------|-------------------|--------------------|-----------|
| 1                        | HBN_EO_EC        | ds004186     | loaded                    | GSN129         | CZ                |                   | .set               | 500       |
| 2                        | Test_Retest_Rest | ds004148     |                           | 10_10          | FCZ               |                   | .vhdr              | 500       |

Please remember that the name of the folder where the dataset is stored must corresponds to *dataset_code* in DATASET_INFO.tsv . 

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
raw_filepath = ['/Users/.../Datasets/ds002778/sub-hc10/ses-hc/eeg/'];
```
2. Preprocess the entire specified dataset.
You have to specify the dataset. In this case you can process the entire dataset, a portion, only some subjects or some session, or even preprocess specific groups and/or specific task.
```
single_file = false;
dataset_name = ['UC_SD'];
```
3. Preprocess all the datasets contained in DATASET_INFO.tsv
You have to left empty the dataset name and set single file as false.
```
single_file = false;
dataset_name = [];
```

## Preprocessing
In the current version of the library, the following preprocessing steps are available:
1. Channels removal
2. Segment removal (first and last specified seconds)
3. Baseline removal
4. Resampling
5. Filtering
6. Independent Component Analysis and Automatic IC rejection with MARA or ICLabel
7. ASR, that can be used independently in two ways: for removing bad channels or for removing/reconstructing bad time windows.
8. Interpolation of previously removed bad channels.
8. Rereference.

Please note that EEG data are assumed to be saved in $\mu V$.

## Saving and Visualization
In order to use the visualization functions, please save the set folders by specifing the name as *group* _ *pipeline*; for example group could be 'A' indicating Alzheimer and pipeline could be 'ICA' indicating the preprocessing step done.
BIDSAling provides three main function for visualization of the results:
1. groups_visualization: you can compare more groups for a single pipeline, or viceversa; you can also specify the single filename to be visualized. Please see the associated paper in order to see which plots can be produced.
2. ERP_visualization: you can see the average ERP a group of patients or for a single one, for multiple event names. If there is only one event, scalp topographies of channels activation in time is shown.
3. template_comparison: you can see the differences between the topographies obtained from two channel location, and the effects of the conversion file. 

## Compatibility
The library was written in MATLAB 2023b, EEGLAB 2023.0, and requires the following plug-in:
- "Biosig" v3.8.3
- "FastICA" v25
- "Fileio" v20240111
- "ICLabel" v1.4
- "MARA" v1.2
- "bva-io" v1.73
- "clean_rawdata" v2.91
- "dipfit" v5.3
- "firfilt" v2.7.1
- "eegstats" v2.7.1

Moreover interally it uses two functions for the non-parametric permutation t-test https://github.com/eglerean/hfASDmodules/tree/master and the iaf calculations https://github.com/corcorana/restingIAF. If you want to avoid downloading these external packages, please set iaf_correction=false and test_parametric = true whenever required.




