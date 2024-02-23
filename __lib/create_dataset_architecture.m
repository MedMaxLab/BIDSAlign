
function create_dataset_architecture(path, def_sess_name, def_eeg_name)
    % FUNCTION: create_dataset_architecture
    %
    % Description: Organizes EEG dataset files into a BIDS-compliant directory structure.
    %
    % Syntax:
    %   create_dataset_architecture(path)
    %
    % Input:
    %   - path (char): The path to the main directory containing EEG dataset files.
    %
    % Author: [Andrea Zanola]
    % Date: [27/01/2024]
    %
    % Examples:
    %   create_dataset_architecture('/path/to/dataset')

    %def_sess_name = 'sess-01';
    %def_eeg_name = 'eeg';
    
    cd(path);
    files = dir(pwd);
    dirFlags = [files.isdir];
    subFolders = files(dirFlags);
    subFolders = subFolders(3:end);
    
    dirFiles = ~[files.isdir];
    Files = files(dirFiles);
    
    if isempty(subFolders)
    %% CASE 1)
    % This part is when no folder structure is present, all files are
    % in the main directory.

        L = length(Files);
        for i=1:L
            C = strsplit(Files(i).name,"_");
            if length(C)~=1
                a = C(1);
                subj_name_file = a{:};
                a = C(2);
                sess_name_file = a{:};
                folder_name = [subj_name_file '/' sess_name_file '/' def_eeg_name '/'];
            else
                [ ~ , name , ~] = fileparts(Files(i).name);
                subj_name_file = name;
                folder_name    = [subj_name_file '/' def_sess_name '/' def_eeg_name '/'];
            end
            if ~exist(folder_name)
                mkdir(folder_name);
            end
            movefile(Files(i).name, folder_name);
        end
    
    %% CASE 2)
    % This part is when some folders are present, but not in BIDS or with
    % missing parts.
    else
        for i=1:length(subFolders)
            subject_folder_name = [path '/' subFolders(i).name];
            cd(subject_folder_name)    %Check if session folders are present
        
            files = dir(pwd);
            dirFlags = [files.isdir];
            sessFolders = files(dirFlags);
            sessFolders = sessFolders(3:end);
    
            if isempty(sessFolders)
                %2) This case is when there is the subject folder, but not
                %session folder
                mkdir([subject_folder_name '/' def_sess_name '/' def_eeg_name])
                movefile([subject_folder_name '/*'],[subject_folder_name '/' def_sess_name '/' def_eeg_name]) %If no session folders present, assume 1 session.
                cd(path);
    
            elseif length(sessFolders)==1 && isequal(sessFolders(1).name,def_eeg_name)
                %3) This case is when there is also the session folder, but
                %is the eeg folder
                session_folder_name = [pwd '/' sessFolders(1).name];   
                mkdir([subject_folder_name '/' def_sess_name '/' def_eeg_name])
                movefile([session_folder_name '/*'],[subject_folder_name '/' def_sess_name '/' def_eeg_name])
                rmdir(def_eeg_name);
                cd(path);
    
            elseif length(sessFolders)>=1

                for j =1:length(sessFolders)
                    if ~isequal(sessFolders(j).name, def_eeg_name)
                        cd([subject_folder_name '/' sessFolders(j).name]);
    
                        filesE = dir(pwd);
                        dirFlagsE = [filesE.isdir];
                        eegFolders = filesE(dirFlagsE);
                        eegFolders = eegFolders(3:end);
                        dirFilesE = ~[filesE.isdir];
                        FilesE = filesE(dirFilesE);
    
                        if isempty(eegFolders)
                            %4) This case is when there are session
                            %folders, but not eeg folders.
                            mkdir(def_eeg_name);
                            for k=1:length(FilesE)
                                movefile(FilesE(k).name,[subject_folder_name '/' sessFolders(j).name '/' def_eeg_name]);
                            end
                        elseif length(eegFolders)==1 && ~isequal(eegFolders.name,def_eeg_name)
                            %5) This case is when there is the session
                            %folder, and a folder that has a different name
                            %respect 'eeg'.
                            movefile(eegFolders.name,def_eeg_name);
                        end
                    end
                    cd(subject_folder_name);
                end
            end
        end
    end
end

