
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
%   - numbers_files: Structure specifying the number of subjects, sessions, and objects to process.
%
% Output:
%   - EEG: EEG data structure after preprocessing.
%   - DATA_STRUCT: Structure containing preprocessed data information.
%
% Usage example:
%   [EEG, DATA_STRUCT] = preprocess_dataset(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, ...
%                                           save_info, params_info, mat_preprocessed_folder, csv_preprocessed_folder, ...
%                                           diagnostic_folder_name, numbers_files);
%
% Notes:
%   - This function preprocesses all the EEG data for a specified dataset, 
%     including loading participant and diagnostic files, extracting channel 
%     information, interpolating missing channels, and saving the data.
%
% Author: [Andrea Zanola]
% Date: [04/10/2023]

function [EEG, DATA_STRUCT] = preprocess_dataset(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                                 mat_preprocessed_folder, csv_preprocessed_folder, ...
                                                 diagnostic_folder_name, numbers_files)

    %% Handle Compatibility
    % Find the row corresponding to the dataset name
    dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
    
    % Extract the channels to remove from the dataset information
    channel_to_remove = strsplit(dataset_info.channel_to_remove{dataset_index}, ',');
    
    %% Create data_info struct
    % Create the data_info struct to store dataset-specific information
    data_info = struct('dataset_number_reference', dataset_index, ...
                       'dataset_code', dataset_info.dataset_code{dataset_index}, ...
                       'channel_location_filename', dataset_info.channel_location_filename{dataset_index},...
                       'channel_system', dataset_info.channel_system{dataset_index},...
                       'channel_reference', dataset_info.channel_reference{dataset_index},...
                       'eeg_file_extension', dataset_info.eeg_file_extension{dataset_index},...
                       'samp_rate', dataset_info.samp_rate(dataset_index),...
                       'select_subjects', dataset_info.select_subjects{dataset_index},...
                       'label_value', dataset_info.label_value{dataset_index},...
                       'label_name', dataset_info.label_name{dataset_index},...
                       'dataset_name', dataset_name,...
                       'channel_to_remove',dataset_info.channel_to_remove{dataset_index}, ...
                       'change_arch',dataset_info.change_arch{dataset_index});
                       %'voltage_unit', dataset_info.units{dataset_index},...
                       %'nchan', dataset_info.nchan(dataset_index),...
 
      
    %% Check if the imported data has correct values
    %samp rate
    if data_info.samp_rate < 0 || mod(data_info.samp_rate, 1) ~= 0
        error("ERROR: NEGATIVE OR NON-INTEGER SAMPLING RATE");
    end
    %filter frequencies
    if params_info.low_freq>params_info.high_freq || params_info.low_freq<0 || params_info.high_freq<0
        error("ERROR: CHECK THE FREQUENCIES FOR THE FILTER");
    end
    
    %% Set Folder/Files Path
    dataset_path = [root_datasets_path data_info.dataset_code '/' ];
    cd(dataset_path);

    %% Create/Check Dataset Structure
    if strcmp(data_info.change_arch,'yes')
        create_dataset_architecture();
    end


    %% Check if folder already exist otherwise create set_preprocessed folder
    if save_info.save_set
        data_info.set_folder = [root_folder_path 'set_preprocessed_' data_info.dataset_code '/'];
        if ~exist(data_info.set_folder, 'dir')
            mkdir(data_info.set_folder)
        end
    end
    
    data_info.dataset_path = dataset_path;
    
    %% Create template struct

    %channel system supported
    channel_systems = {'10_20', '10_10', '10_5', 'GSN129', 'GSN257'};

    % Create the template struct to store channel template information
    template_folder           = [lib_path '/template/template_channel_selection/'];
    tensor_template_filename  = 'tensor_channel_template.mat';
    matrix_template_filename  = 'matrix_channel_template.mat';
    
    % Load the matrix template file
    template_matrix = load([template_folder matrix_template_filename]);
    template_matrix = upper(template_matrix.matrix_channel_template);
    
    % Load the tensor template file
    template_tensor = load([template_folder tensor_template_filename]);
    template_tensor = upper(template_tensor.tensor_channel_template);
    
    % Load the conversion files based on the channel system
    conversion_folder         = [lib_path '/template/template_channel_conversion/'];
    conv_GSN129_1010_filename = 'conv_GSN129_1010.mat';
    conv_GSN257_1010_filename = 'conv_GSN257_1010.mat';
    
    % Load standard channel location file from templates
    channel_location_folder = [lib_path '/template/template_channel_location/'];
    
    if strcmp(data_info.channel_system,channel_systems{4})
        conversion = load([conversion_folder  conv_GSN129_1010_filename]);
        conversion = upper(conversion.convGSN129);
        if length(conversion(:,1)) < length(template_matrix)
            error('ERROR: CONVERSION FILE SHORTER THAN TEMPLATE FILE')
        end
        data_info.standard_chanloc = [channel_location_folder 'chanloc_template_' data_info.channel_system '.sfp'];
    
    elseif strcmp(data_info.channel_system,channel_systems{5})
        conversion = load([conversion_folder  conv_GSN257_1010_filename]);
        conversion = upper(conversion.convGSN257);
        if length(conversion(:,1)) < length(template_matrix)
            error('ERROR: CONVERSION FILE SHORTER THAN TEMPLATE FILE')
        end
        data_info.standard_chanloc = [channel_location_folder 'chanloc_template_' data_info.channel_system '.sfp'];
    
    elseif  strcmp(data_info.channel_system,channel_systems{1}) || strcmp(data_info.channel_system, channel_systems{2}) || strcmp(data_info.channel_system,channel_systems{3})
        conversion = "nan";
        data_info.standard_chanloc = [channel_location_folder 'chanloc_template_' '10_5' '.sfp'];

    else
        error('ERROR: UNSUPPORTED CHANNEL SYSTEM');
    end
    
    template_info = struct('template_matrix',template_matrix,'template_tensor',template_tensor,'conversion',conversion); 
    
    
    %% Import participant file -----------------------------------------------
    % Get the participant file path
    participant_filepath  = [dataset_path 'participants'];
    
    % Read the participant file
    if isfile([participant_filepath '.csv'])
        T = readtable([participant_filepath '.csv'],"FileType","text");

    elseif isfile([participant_filepath '.tsv'])
        T = readtable([participant_filepath '.tsv'],"FileType","text");

    elseif ~isempty(dir([dataset_path 'participants.*']))
        T = [];
        warning('PARTICIPANT FILE FOUND BUT UNABLE TO IMPORT THE ASSOCIATED FILE FORMAT'); 
    else
        T = [];
        warning(['PARTICIPANT FILE NOT FOUND IN: ' dataset_path]);
    end

    %% Import diagnostic test -----------------------------------------------
    diagnostic_folder_path = [dataset_path diagnostic_folder_name];
    S = dir(fullfile(diagnostic_folder_path,'*'));
    N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of D.

    for ii = 1:numel(N)
        K = dir(fullfile(diagnostic_folder_path,N{ii},'*.csv'));
        C = {K(~[K.isdir]).name}; % files in subfolder.

        for jj = 1:numel(C)
            F = fullfile(diagnostic_folder_path,N{ii},C{jj});
            

            if ~isempty(T)		
                T_new = readtable(F,"FileType","text");
		
                T_feats = T_new.Properties.VariableNames(2:end);
                Nfeat = length(T_feats);
                c = [false true(1,Nfeat)];

                for i=1:Nfeat
                    T_type = class(T_new.(i+1));
		   
                    if ~strcmp(T_type,'cell')
		
                        T = [T table(NaN([height(T) 1]),'VariableNames',T_feats(i))];
			else
                        c(i+1) = false;
                    end
                end
    
                for i=1:height(T_new)
                    O = find(strcmp(T_new{i,1},T{:,1}));

                    if ~isempty(O)
                        T(O,end-sum(c)+1:end) = T_new(i,c);
                    end
                end
            else
                T = T_new;
            end
        end
    end


    %% Extract selected patients
    % Check if subject selection is required
    if strcmp(data_info.select_subjects,'yes') && isempty(T)
        error('UNABLE TO SELECT SUBJECTS WITH NO PARTICIPANT FILE LOADED');
    
    elseif strcmp(data_info.select_subjects,'yes') && ~isempty(T)
        % Select control subjects based on group information
        idx_column = linspace(1,width(T),width(T));
        I = idx_column(ismember(T.Properties.VariableNames, data_info.label_name));
        subj_list = T.(1);                                  %FIRST COLUMN ALWAYS ID PARTICIPANT
        mask = strcmp(T.(I), data_info.label_value);                                     
        subj_list = subj_list(mask,:);
        T = T(mask,:);
        
        cd(dataset_path);
    
    elseif strcmp(data_info.select_subjects,'no')
        % Process all subjects in the dataset
        cd(dataset_path);
        d = dir(pwd);
        
        dfolders = d([d(:).isdir]); %select all folders
        dfolders = dfolders(~ismember({dfolders(:).name},{'.','..',diagnostic_folder_name,'.datalad'}));  %exclude some folders
        subj_list = {dfolders.name};

     end
    
    %% Check Channel/Electrodes file name -----------------------------------
    check_ch0_root = dir([dataset_path '*_channels.tsv']);
    check_el0_root = dir([dataset_path '*_electrodes.tsv']);
    
    if length(check_ch0_root)>1
        error(['MULTIPLE CHANNEL FILES PRESENT IN ' dataset_path]);
    end
    if length(check_el0_root)>1
        error(['MULTIPLE ELECTRODES FILES PRESENT IN ' dataset_path]);
    end
    
    %% Process all subjects in the dataset ----------------------------------
    N_subj = length(subj_list);
    if ~strcmp(numbers_files.N_subj,'all')
        if numbers_files.N_subj>N_subj
            warning('NUMBER OF SESSIONS REQUIRED IS TO HIGH');
        end
        N_subj = min(N_subj,numbers_files.N_subj);
    end

    L = [];
    
    for j=1:N_subj

        fprintf([' \t\t\t\t\t\t\t\t ---' dataset_name '- SUBJECT PROCESSED: ' num2str(j) '/' num2str(N_subj) ' ---\n']);

        subject_name   = subj_list{j};
        subject_folder = [dataset_path subject_name];

        cd(subject_folder);
        check_ch1_root = dir('*_channels.tsv');
        check_el1_root = dir('*_electrodes.tsv');
    
        if length(check_ch1_root)>1
            error(['MULTIPLE CHANNEL FILES PRESENT IN ' subject_folder]);
        end
        if length(check_el1_root)>1
            error(['MULTIPLE ELECTRODES FILES PRESENT IN ' subject_folder]);
        end
    
        d         = dir(pwd);
        dfolders  = d([d(:).isdir]);
        sess_list = dfolders(~ismember({dfolders(:).name},{'.','..'}));
        N_sess    = length(sess_list);
        if ~strcmp(numbers_files.N_sess,'all')
            if numbers_files.N_sess>N_sess
                warning('NUMBER OF SESSIONS REQUIRED IS TO HIGH');
            end
            N_sess = min(N_sess,numbers_files.N_sess);
        end

        % Load subject information, and check if the folder name is found
        % inside the participant.tsv file
        if ~isempty(T)
            O = find(strcmp(subject_name,T{:,1}));

            if ~isempty(O)
                subj_info = table2struct(T(O,:));
            else
                warning('SUBJECT FOLDER NAME NOT FOUND IN THE PARTICIPANT FILE; SUBJECT INFO NOT LOADED.');
                subj_info = [];
            end

        else
             warning('PARTICIPANT FILE NOT PROVIDED, SUBJECT INFO NOT LOADED.');
            subj_info = [];
        end
    
        %% Preprocess all sessions for a subject
        for k=1:N_sess

            fprintf([' \t\t\t\t\t\t\t\t ---' dataset_name '- SESSION PROCESSED: ' num2str(k) '/' num2str(N_sess) ' ---\n']);

            session_name           = sess_list(k).name;
            subject_session_folder = [subject_folder '/' session_name '/eeg/'];
            cd(subject_session_folder);
    
            check_ch2_root = dir('*_channels.tsv');
            check_el2_root = dir('*_electrodes.tsv');
    
            raw_filepath  = pwd;
            filelist      = dir(['*' data_info.eeg_file_extension]);
            N_obj         = length(filelist);
            if ~strcmp(numbers_files.N_obj,'all')
                if numbers_files.N_obj>N_obj
                    warning('NUMBER OF OBJECTS REQUIRED IS TO HIGH');
                end
                N_obj = min(N_obj,numbers_files.N_obj);
            end

            %% Preprocess all files of a session -----------------------
            for i=1:N_obj

                fprintf([' \t\t\t\t\t\t\t\t ---' dataset_name '- OBJECT PROCESSED: ' num2str(i) '/' num2str(N_obj) ' ---\n']);

                raw_filename              = filelist(i).name;
                preprocessed_filename     = [int2str(data_info.dataset_number_reference) '_' int2str(j) '_' int2str(k) '_' int2str(i)];
                set_preprocessed_filename = [preprocessed_filename data_info.eeg_file_extension];
                mat_preprocessed_filepath = [mat_preprocessed_folder preprocessed_filename '.mat'];
    	
                [data_info] = extract_filenames(check_ch0_root, check_ch1_root, check_ch2_root, ...
                                                check_el0_root, check_el1_root, check_el2_root, ...
                                                raw_filepath, raw_filename, data_info);

                [EEG, L] = preprocess_single_file(raw_filepath, raw_filename, set_preprocessed_filename, ...
                                                  channel_systems, data_info, channel_to_remove, params_info, template_info, L, save_info);
                
                %% Save data to template (and interpolation)
                if save_info.save_data && ~isempty(EEG)
                    [EEG, DATA_STRUCT] = save_data_totemplate(raw_filepath, raw_filename, mat_preprocessed_filepath, channel_systems,...
                                                              EEG, template_info, save_info, data_info, params_info, subj_info);

                    if ~isempty(EEG.event) && save_info.save_marker
                        eeg_eventtable(EEG,'exportFile',[csv_preprocessed_folder preprocessed_filename '.csv'],'dispTable',false);
                    end
                else
                    DATA_STRUCT = [];
                end
                
            end
        end
    end

end

