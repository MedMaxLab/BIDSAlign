
function raw_filepath = retrieve_file(root_datasets_path,  mat_filename)

    %% Retrieve indexes from filename -------------------------------------
    index_comma = [];
    index_comma(1) = 0;
    t=1;
    for i=1:length(mat_filename)
        if strcmp(mat_filename(i),'_') || strcmp(mat_filename(i),'.')
            index_comma(t+1) = i;
            t = t+1;
        end
    end

    list_index = {};
    for i=1:length(index_comma)-1
        list_index{i} = mat_filename(1+index_comma(i):(index_comma(i+1)-1));
    end

    W =  str2num(list_index{1});
    J =  str2num(list_index{2});
    K =  str2num(list_index{3});
    I =  str2num(list_index{4});

    dataset_info = readtable([root_datasets_path 'DATASET_INFO.xlsx']);
    A = find(dataset_info.dataset_number_reference == W);

    dataset_name           = dataset_info.dataset_name{A};
    eeg_file_extension     = dataset_info.eeg_file_extension{A};   %NOT PRESENT ANYMORE IN EXCEL FILE (HOW TO SOLVE!?)
    participants_filename  = dataset_info.participants_filename{A};

    dataset_path      = [root_datasets_path dataset_name '\' ];
    cd(dataset_path);

    data_dataset_path = [dataset_path 'dataset\'];

    %% Check if participants filename list is given ------------------------
    if ~strcmp(participants_filename,'nan')
        fid = fopen(participants_filename);
        C = textscan(fid, '%s %f %s %s %s %s %f ' , 'HeaderLines', 1);
        fclose(fid);
        subj_list = char();
        for i=1:length(C{1})
            if strcmp(C{3}{i}, 'CTL') %CONTROL IN ON THE 3° LINE
                subj_list = char(subj_list, C{1}{i});
            end
        end
        subj_list = subj_list(2:end,:);
    
        subj_list = subj_list(1,:);  %REMOVE THIS LINE WHEN ALL DATASET DOWNLOADED
        cd(data_dataset_path);
    else
        cd(data_dataset_path);
        struct_subj_list = dir(fullfile(pwd));
        struct_subj_list = struct_subj_list(3:end);
        subj_list = char();
        for i=1:length(struct_subj_list)
            
            subj_list = char(subj_list, struct_subj_list(i).name);
        end
        subj_list = subj_list(2:end,:);
    end
    
    %% Go Through the dataset architecture --------------------------------
    subject_name   = subj_list(J,:);
    subject_folder = [data_dataset_path subject_name];
    cd(subject_folder);
    
    sess_list = dir(fullfile(pwd));
    sess_list = sess_list(3:end);
    session_name           = sess_list(K).name;
    subject_session_folder = [subject_folder '\' session_name '\eeg\'];
    cd(subject_session_folder);

    raw_filepath = pwd;
    filelist     = dir(fullfile(raw_filepath, ['*' eeg_file_extension]));
    raw_filename = filelist(I).name;
    raw_filepath = [raw_filepath '\' raw_filename];

end

