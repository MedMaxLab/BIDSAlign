
function [EEG, DATA_STRUCT] = preprocess_dataset(dataset_info, save_info, params_info, path_info, selection_info)
    % Function: preprocess_dataset
    % Description: Preprocesses a dataset of EEG recordings, extracts relevant information,
    % and saves the preprocessed data to a template-based data structure or matrix format.
    %
    % Input:
    %   - root_datasets_path: The root path to the datasets.
    %   - root_folder_path: The root path to the preprocessed data folders.
    %   - lib_path: The path to the library folder containing template files.
    %   - dataset_info: Structure containing dataset-specific information.
    %   - dataset_name: The name of the dataset to preprocess.
    %   - save_info: Structure specifying the data saving options.
    %   - params_info: Structure containing preprocessing parameters.
    %   - mat_preprocessed_folder: The path to save the preprocessed data in MAT format.
    %   - csv_preprocessed_folder: The path to save preprocessed marker data in CSV format.
    %   - diagnostic_folder_name: The name of the diagnostic folder within the dataset.
    %   - selection_info: Structure containing selection parameters.
    %
    % Output:
    %   - EEG: EEG data structure after preprocessing.
    %   - DATA_STRUCT: Structure containing preprocessed data information.
    %
    % Notes:
    %   - This function preprocesses all the EEG data for a specified dataset, 
    %     including loading participant and diagnostic files, extracting channel 
    %     information, interpolating missing channels, and saving the data.
    %
    % Author: [Andrea Zanola]
    % Date: [04/10/2023]
    
    %% Load Dataset Informations
    [data_info, path_info, template_info, T] = load_info(dataset_info, path_info, params_info, save_info);

    %% Extract selected patients
    cd(path_info.dataset_path);
    % Check if subject selection is required
    if selection_info.select_subjects && isempty(T)
        error('UNABLE TO SELECT SUBJECTS WITH NO PARTICIPANT FILE LOADED');

    elseif selection_info.select_subjects && ~isempty(T)
        % Select control subjects based on group information
        idx_column = linspace(1,width(T),width(T));
        I = idx_column(ismember(T.Properties.VariableNames, selection_info.label_name));
        subj_list = T.(1);                                  %FIRST COLUMN ALWAYS ID PARTICIPANT
        mask = strcmp(T.(I), selection_info.label_value);                                     
        subj_list = subj_list(mask,:);
        T = T(mask,:);
    else
        d = dir(pwd);
        dfolders = d([d(:).isdir]); %select all folders
        %exclude some folders
        dfolders = dfolders(~ismember({dfolders(:).name},{'.','..',path_info.diagnostic_folder_name,'.datalad','code','derivatives'}));
        subj_list = {dfolders.name};
    end

    % Select files on the basis of number of subjects
    N_subj = length(subj_list);
    if ~strcmp(selection_info.N_subj,'all')
        if selection_info.N_subj>N_subj
            warning('NUMBER OF SUBJECTS REQUIRED IS TOO HIGH');
        end
        N_subj = min(N_subj,selection_info.N_subj);
    end

    %% Check Channel/Electrodes file name 
    obj_info.check_ch0_root = dir([path_info.dataset_path '*_channels.tsv']);
    obj_info.check_el0_root = dir([path_info.dataset_path '*_electrodes.tsv']);
    if length(obj_info.check_ch0_root)>1
        error(['MULTIPLE CHANNEL FILES PRESENT IN ' path_info.dataset_path]);
    end
    if length(obj_info.check_el0_root)>1
        error(['MULTIPLE ELECTRODES FILES PRESENT IN ' path_info.dataset_path]);
    end

    L = [];
    
    %% Preprocess all subjects
    for j=1:N_subj

        fprintf([' \t\t\t\t\t\t\t\t ---' data_info.dataset_name '- SUBJECT PROCESSED: ' num2str(j) '/' num2str(N_subj) ' ---\n']);

        subject_name   = subj_list{j};
        subject_folder = [path_info.dataset_path subject_name];
        cd(subject_folder);

        %% Load subject information
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

        %% Check Channel/Electrodes file name 
        obj_info.check_ch1_root = dir('*_channels.tsv');
        obj_info.check_el1_root = dir('*_electrodes.tsv');
        if length(obj_info.check_ch1_root)>1
            error(['MULTIPLE CHANNEL FILES PRESENT IN ' subject_folder]);
        end
        if length(obj_info.check_el1_root)>1
            error(['MULTIPLE ELECTRODES FILES PRESENT IN ' subject_folder]);
        end
    
        %% Extract selected sessions
        d         = dir(pwd);
        dfolders  = d([d(:).isdir]);
        sess_list = dfolders(~ismember({dfolders(:).name},{'.','..'}));
        N_sess    = length(sess_list);

        % Take only sessions selected
        if ~isempty(selection_info.session_totake)
            z_list = [];
            for z = 1:N_sess
                mask = false;
                for p=1:length(selection_info.session_totake)
                    mask = mask || contains(sess_list(z).name, selection_info.session_totake{p});
                end
                if mask 
                    z_list = [z_list, z];
                end
            end
            sess_list = sess_list(z_list);
            N_sess = length(sess_list);
        end

        % Select files on the basis of number of sessions
        if ~strcmp(selection_info.N_sess,'all')
            if selection_info.N_sess>N_sess
                warning('NUMBER OF SESSIONS REQUIRED IS TOO HIGH');
            end
            N_sess = min(N_sess,selection_info.N_sess);
        end
    
        %% Preprocess all sessions for a subject
        for k = 1:N_sess

            fprintf([' \t\t\t\t\t\t\t\t ---' data_info.dataset_name '- SESSION PROCESSED: ' num2str(k) '/' num2str(N_sess) ' ---\n']);

            session_name           = sess_list(k).name;
            subject_session_folder = [subject_folder '/' session_name '/eeg/'];
            cd(subject_session_folder);
    
            %% Check Channel/Electrodes file name 
            obj_info.check_ch2_root = dir('*_channels.tsv');
            obj_info.check_el2_root = dir('*_electrodes.tsv');

            %% Extract selected objects
            obj_info.raw_filepath  = pwd;
            filelist      = dir(['*' data_info.eeg_file_extension]);
            N_obj         = length(filelist);

            % Take only task selected
            if ~isempty(selection_info.task_totake)
                z_list = [];
                for z = 1:N_obj
                    mask = false;
                    for p=1:length(selection_info.task_totake)
                        mask = mask || contains(filelist(z).name, selection_info.task_totake{p});
                    end
                    if mask 
                        z_list = [z_list, z];
                    end
                end
                filelist = filelist(z_list);
                N_obj = length(filelist);
            end

            % Select files on the basis of number of objects
            if ~strcmp(selection_info.N_obj,'all')
                if selection_info.N_obj>N_obj
                    warning('NUMBER OF OBJECTS REQUIRED IS TOO HIGH');
                end
                N_obj = min(N_obj,selection_info.N_obj);
            end

            %% Preprocess all files of a session -----------------------
            for i=1:N_obj

                fprintf([' \t\t\t\t\t\t\t\t ---' data_info.dataset_name '- OBJECT PROCESSED: ' num2str(i) '/' num2str(N_obj) ' ---\n']);

                obj_info.raw_filename              = filelist(i).name;
                obj_info.preprocessed_filename     = [int2str(data_info.dataset_number_reference) '_' int2str(j) '_' int2str(k) '_' int2str(i)];
                obj_info.set_preprocessed_filename = [obj_info.preprocessed_filename data_info.eeg_file_extension];
                obj_info.mat_preprocessed_filename = [path_info.mat_preprocessed_filepath obj_info.preprocessed_filename '.mat'];
    	
                % extract right electrodes and channels filename
                [obj_info] = extract_filenames(obj_info, path_info, data_info);

                % Get Event Filename
                l = strfind(obj_info.raw_filename,'_');
                if ~isempty(l)
                    event_name = [obj_info.raw_filename(1:l(end)) 'events.tsv'];
                    if isfile(event_name)
                        obj_info.event_filename = event_name;
                    else
                        obj_info.event_filename = [];
                    end
                else
                    obj_info.event_filename = [];
                end

                [EEG, L] = preprocess_single_file(L, obj_info, data_info, params_info, path_info, template_info, save_info);
                
                %% Save data to template (and interpolation)
                if save_info.save_data && ~isempty(EEG)
                    [EEG, DATA_STRUCT] = save_data_totemplate(EEG, obj_info, template_info, save_info, path_info, data_info, params_info, subj_info);

                    if ~isempty(EEG.event) && save_info.save_marker
                        eeg_eventtable(EEG,'exportFile',[path_info.csv_preprocessed_folder obj_info.preprocessed_filename '.csv'],'dispTable',false);
                    end
                else
                    DATA_STRUCT = [];
                end
                
            end
        end
    end

end

