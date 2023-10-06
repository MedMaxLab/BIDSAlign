

function [EEG, DATA_STRUCT] = preprocess_subject(root_datasets_path, root_folder_path, lib_path, dataset_info, dataset_name, save_info, params_info, ...
                                                 mat_preprocessed_folder, csv_preprocessed_folder, diagnostic_folder_name, raw_filename, raw_filepath)

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

    %% Extract Subject and Session Name
    out = regexp(raw_filepath ,'\','split');
    subject_name  = out{end-3};
    session_name = out{end-2}; 

    %% Extract Channel/Electrodes filename 
    cd(dataset_path);
    check_ch0_root = dir([dataset_path '*_channels.tsv']);
    check_el0_root = dir([dataset_path '*_electrodes.tsv']);
    
    if length(check_ch0_root)>1
        error(['MULTIPLE CHANNEL FILES PRESENT IN ' dataset_path]);
    end
    if length(check_el0_root)>1
        error(['MULTIPLE ELECTRODES FILES PRESENT IN ' dataset_path]);
    end
    
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

    subject_session_folder = [subject_folder '/' session_name '/eeg/'];
    cd(subject_session_folder);
    
    check_ch2_root = dir('*_channels.tsv');
    check_el2_root = dir('*_electrodes.tsv');

    [data_info] = extract_filenames(check_ch0_root, check_ch1_root, check_ch2_root, ...
                                    check_el0_root, check_el1_root, check_el2_root, ...
                                    raw_filepath, raw_filename, data_info);

    %% Assign subject information
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

    %% Set filenames
    preprocessed_filename     = [raw_filename '_prep'];
    set_preprocessed_filename = [preprocessed_filename data_info.eeg_file_extension];
    mat_preprocessed_filepath = [mat_preprocessed_folder preprocessed_filename '.mat'];
    
    %% Preprocess File
    [EEG, ~] = preprocess_single_file(raw_filepath, raw_filename, set_preprocessed_filename, ...
                                      channel_systems, data_info, channel_to_remove, params_info, template_info, [], save_info);
    
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