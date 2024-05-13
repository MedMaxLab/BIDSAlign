# Step-by-step User Guide
Before starting, you should check the Compatibility section in the README of BIDSAlign.
Thus you should have EEGLAB installed in your PC and all the plug-in required.
## Get BIDSAlign and set working directory
1) Get a copy of BIDSAlign on your PC, using the Git command line:

`git clone https://github.com/MedMaxLab/BIDSAlign.git`

2) Create: *YourWorkingDirectory* folder.
3) Put inside *YourWorkingDirectory* the BIDSAlign's code example preprocess_all_script.m
4) Copy from BIDSAlign or create your own DATASET_INFO.tsv file and put it inside *YourWorkingDirectory*.
5) Create a folder inside *YourWorkingDirectory*, where you want to put the preprocessed files from BIDSAlign, here called *OutputOfBIDSAlign*.

After these 5 steps *YourWorkingDirectory* should appear like this:

<img src="YourWorkingDirectory.png"
        alt="Picture"
        width="250"
        style="display: block; margin: 0 auto" />

## Get the Dataset
For this guided example, we will use the "UC San Diego Resting State EEG Data from Patients with Parkinson's Disease" from OpenNeuro [UC_SD](https://openneuro.org/datasets/ds002778/versions/1.0.5). It is relatively small (573.3 MB), so you can download it quickly.

The required steps to take are:
1) Create the folder where you will store the dataset, here *EEG_Datasets*
2) Download the dataset inside the folder, with your preferred method.
If you want to use AWS, make sure to have it installed; for instance, you can do it easily with conda. For downloading, the following command line can be used:

`aws s3 sync --no-sign-request s3://openneuro.org/ds002778 dataset_folder_name/`

A typical suggested *dataset_folder_name* is the code of the dataset (here: ds002778).
The dataset has the following folder structure:

<img src="UC_SD_structure.png"
        alt="Picture"
        style="display: block; margin: 0 auto" />

Since the dataset has the right structure (subjects/sessions/eeg/), there is no need ot use the function create_dataset_architecture, which changes in place the dataset structure.

## Set the DATASET_INFO file
The DATASET_INFO.tsv file is where all the information about the dataset are stored.
You can get this information in several ways:
- Read the README file of the dataset if present.
- Read the authors' publication associated with the dataset.
- Load one file from the dataset in EEGLAB and inspect the relative EEG structure.
- Contact the authors' of the dataset.

The information for this example dataset is already inside the DATASET_INFO.tsv file provided by BIDSAlign (dataset number 8).

<img src="bidsaling1to8_datasetinfo.png"
        alt="Picture"
        style="display: block; margin: 0 auto" />

The most important thing is that the dataset_code of one dataset is the *dataset_folder_name* used before.

## How to use the example script
#### 1) Set the modality 
In order to keep things simple, you set the modality as 'local', and set the dataset name that should match the dataset_name field inside DATASET_INFO.tsv, in this case 'UC_SD'.

<img src="set_modality.png"
        alt="Picture"
        style="display: block; margin: 0 auto" />

#### 2) Choose which files you want to preprocess
Before setting up this structure, you should think about your analysis and how the data in the dataset can be used.

If you want to select files from the whole dataset, set "select_subjects" as true. In this example, we want to:
1) Select only Parkinson subjects (subjects_totake = {{'pd'}}).
2) Select only the off-session, meaning that without medication (session_totake = {{'ses-off'}})
3) In order to keep things quick, we want to preprocess only the first 5 subjects from the previous selected ones. (sub_i = 1, sub_f=5).

<img src="set_selectinfo.png"
        alt="Picture"
	width = 500
        style="display: block; margin: 0 auto" />

Notice that the three fields named "_totake", check if the given string is present inside the folder and file name, thus before setting these fields check the dataset's folder names.
This dataset is structured in the following way:

<img src="UC_SD_structure_on.png"
        alt="Picture"
	width = 300
        style="display: block; margin: 0 auto" />
	
#### 3) What do you want from BIDSAlign?
With the struct "save_info" you can decide the output of BIDSAlign.
In this example, we want to save only the preprocessed .set files.

<img src="set_saveinfo.png"
        alt="Picture"
	width = 400
        style="display: block; margin: 0 auto" />

"set$\_$label" is useful if you want to use the visualisation functions provided by BIDSAlign, which needs folder names saved as:
					$$\text{dataset_code + group + _ + pipeline}$$
Here you have to put in "set_label" only the "group_pipeline" part.
Here we want to perform only filtering, thus the pipeline is called "FILT".

#### 4) Setting the Paths
Finally, since at the beginning we set the modality as 'local', we set the needed paths.
Remember to give the EEGLAB path, if is not made globally available to MATLAB.

<img src="paths.png"
        alt="Picture"
        style="display: block; margin: 0 auto" />
	
#### 5) Run the preprocessing
Everything is set to make BIDSAlign work!
Indeed, after the preprocessing, you will have the OutputOfBIDSAlign folder, structured in the following way:

<img src="OutputOfBIDSAlign.png"
        alt="Picture"
        style="display: block; margin: 0 auto" />
	
#### 6) Conclusions
Now it is your turn! Please explore BIDSAlign and the many options available. If you are not confident using MATLAB scripting, you are encouraged to use the GUI; for that, please see the attached documentation.
