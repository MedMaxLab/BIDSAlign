
function [EEG, DATA_STRUCT] = preprocess_subject(data_info, save_info, params_info, path_info, obj_info, verbose)
    % FUNCTION: preprocess_subject
    %
    % Description: Preprocesses EEG data for a single subject.
    %
    % Syntax:
    %   [EEG, DATA_STRUCT] = preprocess_subject(data_info, save_info, params_info, path_info, obj_info, verbose)
    %
    % Input:
    %   - data_info: Dataset information.
    %   - save_info: Save settings information.
    %   - params_info: Preprocessing parameters information.
    %   - path_info: Paths information.
    %   - obj_info: Object information.
    %   - verbose: Flag to display warnings (optional, default is false).
    %
    % Output:
    %   - EEG: Processed EEG data.
    %   - DATA_STRUCT: Processed data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]
    %
    
    if nargin < 6
        verbose =  false;
    end
    %% Load Dataset Informations
    [data_info, path_info, template_info, T] = load_info(data_info, path_info, params_info, save_info, verbose);
    
    %% Extract Subject and Session Name
    out = regexp(obj_info.raw_filepath ,'\','split');
    subject_name = out{end-3};
    session_name = out{end-2};

    %% Assign subject information
    if ~isempty(T)
        O = find(strcmp(subject_name,T{:,1}));
        if ~isempty(O)
            subj_info = table2struct(T(O,:));
        else
            if verbose
                warning('SUBJECT FOLDER NAME NOT FOUND IN THE PARTICIPANT FILE.');
            end
            subj_info = [];
        end
    else
        if verbose
            warning('PARTICIPANT FILE NOT PROVIDED, SUBJECT INFO NOT LOADED.');
        end
        subj_info = [];
    end

    %% Extract Channel/Electrodes filename 
    cd(path_info.dataset_path);
    
    obj_info.check_ch0_root = dir([path_info.dataset_path '*_channels.tsv']);
    obj_info.check_el0_root = dir([path_info.dataset_path '*_electrodes.tsv']);
    if length(obj_info.check_ch0_root)>1
        error(['MULTIPLE CHANNEL FILES PRESENT IN ' path_info.dataset_path]);
    end
    if length(obj_info.check_el0_root)>1
        error(['MULTIPLE ELECTRODES FILES PRESENT IN ' path_info.dataset_path]);
    end
    
    subject_folder = [path_info.dataset_path subject_name];
    cd(subject_folder);

    obj_info.check_ch1_root = dir('*_channels.tsv');
    obj_info.check_el1_root = dir('*_electrodes.tsv');
    if length(obj_info.check_ch1_root)>1
        error(['MULTIPLE CHANNEL FILES PRESENT IN ' subject_folder]);
    end
    if length(obj_info.check_el1_root)>1
        error(['MULTIPLE ELECTRODES FILES PRESENT IN ' subject_folder]);
    end

    subject_session_folder = [subject_folder '/' session_name '/eeg/'];
    cd(subject_session_folder);
    
    obj_info.check_ch2_root = dir('*_channels.tsv');
    obj_info.check_el2_root = dir('*_electrodes.tsv');

    % Extract right electrodes, channels and event filenames
    [obj_info] = extract_filenames(obj_info, path_info, data_info);


    %% Set filenames
    obj_info.preprocessed_filename     = [obj_info.raw_filename '_prep'];
    obj_info.set_preprocessed_filename = [obj_info.preprocessed_filename data_info.eeg_file_extension];
    obj_info.mat_preprocessed_filename = [path_info.output_mat_path obj_info.preprocessed_filename '.mat'];
    	

    [EEG, ~] = preprocess_single_file([], obj_info, data_info, params_info, path_info, template_info, save_info);
    
    %% Save data to template (and interpolation)
    if save_info.save_data && ~isempty(EEG)
        [EEG, DATA_STRUCT] = save_data_totemplate(EEG, obj_info, template_info, save_info, path_info, data_info, params_info, subj_info);

        if ~isempty(EEG.event) && save_info.save_marker
            eeg_eventtable(EEG,'exportFile',[path_info.output_csv_path obj_info.preprocessed_filename '.csv'],'dispTable',false);
        end
    else
        DATA_STRUCT = [];
    end

end