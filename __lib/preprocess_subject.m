

function [EEG, DATA_STRUCT] = preprocess_subject(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                                 mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name, raw_filename, raw_filepath)

    %% Load Dataset Informations
    [data_info, template_info, T] = load_info(root_datasets_path, lib_path, dataset_info, dataset_name, ...
                                              params_info, diagnostic_folder_name);
    
    %% Check if folder already exist otherwise create set_preprocessed folder
    if save_info.save_set
        data_info.set_folder = [root_folder_path 'set_preprocessed_' data_info.dataset_code '/'];
        if ~exist(data_info.set_folder, 'dir')
            mkdir(data_info.set_folder)
        end
    end
    
    %% Extract Subject and Session Name
    out = regexp(raw_filepath ,'\','split');
    subject_name = out{end-3};
    session_name = out{end-2}; 

    %% Assign subject information
    if ~isempty(T)
        O = find(strcmp(subject_name,T{:,1}));
        if ~isempty(O)
            subj_info = table2struct(T(O,:));
        else
            warning('SUBJECT FOLDER NAME NOT FOUND IN THE PARTICIPANT FILE.');
            subj_info = [];
        end
    else
        warning('PARTICIPANT FILE NOT PROVIDED, SUBJECT INFO NOT LOADED.');
        subj_info = [];
    end

    %% Extract Channel/Electrodes filename 
    cd(data_info.dataset_path);
    
    check_ch0_root = dir([data_info.dataset_path '*_channels.tsv']);
    check_el0_root = dir([data_info.dataset_path '*_electrodes.tsv']);
    if length(check_ch0_root)>1
        error(['MULTIPLE CHANNEL FILES PRESENT IN ' data_info.dataset_path]);
    end
    if length(check_el0_root)>1
        error(['MULTIPLE ELECTRODES FILES PRESENT IN ' data_info.dataset_path]);
    end
    
    subject_folder = [data_info.dataset_path subject_name];
    cd(subject_folder);

    check_ch1_root = dir('*_channels.tsv');
    check_el1_root = dir('*_electrodes.tsv');
    if length(check_ch1_root)>1
        error(['MULTIPLE CHANNEL FILES PRESENT IN ' subject_folder]);
    end
    if length(check_el1_root)>1
        error(['MULTIPLE ELECTRODES FILES PRESENT IN ' subject_folder]);
    end

    subject_session_folder = [subject_folder '/' session_name '/eeg/'];
    cd(subject_session_folder);
    
    check_ch2_root = dir('*_channels.tsv');
    check_el2_root = dir('*_electrodes.tsv');

    [data_info] = extract_filenames(check_ch0_root, check_ch1_root, check_ch2_root, ...
                                    check_el0_root, check_el1_root, check_el2_root, ...
                                    raw_filepath, raw_filename, data_info);
    % Get Event Filename
    l = strfind(raw_filename,'_');
    if ~isempty(l)
        event_name = [raw_filename(1:l(end)) 'events.tsv'];
        if isfile(event_name)
            event_filename = event_name;
        else
            event_filename = [];
        end
    else
        event_filename = [];
    end

    %% Set filenames
    preprocessed_filename     = [raw_filename '_prep'];
    set_preprocessed_filename = [preprocessed_filename data_info.eeg_file_extension];
    mat_preprocessed_filepath = [mat_preprocessed_folder preprocessed_filename '.mat'];
    
    %% Preprocess File
    [EEG, ~] = preprocess_single_file(raw_filepath, raw_filename, set_preprocessed_filename, event_filename,...
                                          data_info, params_info, template_info, [], save_info);
    
    %% Save data to template (and interpolation)
    if save_info.save_data && ~isempty(EEG)
        [EEG, DATA_STRUCT] = save_data_totemplate(raw_filepath, raw_filename, mat_preprocessed_filepath,...
                                                  EEG, template_info, save_info, data_info, params_info, subj_info);
    
        if ~isempty(EEG.event) && save_info.save_marker
            eeg_eventtable(EEG,'exportFile',[csv_preprocessed_folder preprocessed_filename '.csv'],'dispTable',false);
        end
    else
        DATA_STRUCT = [];
    end      

end