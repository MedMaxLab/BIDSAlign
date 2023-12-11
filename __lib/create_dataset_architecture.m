
function create_dataset_architecture(path)
    % Function: create_dataset_architecture
    % Description: Organizes EEG data files in a specified directory following
    % a standardized folder structure adhering to the Brain Imaging Data
    % Structure (BIDS) convention. Assumes a default session name of 'sess-01'
    % and EEG data folder name of 'eeg'.
    %
    % Input:
    %   - path: The directory path where the dataset is located.
    %
    % Parameters:
    %   - def_sess_name: Default session name, set to 'sess-01'.
    %   - def_eeg_name: Default EEG data folder name, set to 'eeg'.
    %
    % Folder Organization:
    %   1) No Folder Structure Present:
    %     - Iterates through EEG data files.
    %     - Organizes them into subject and session folders following BIDS.
    %     - Files are moved to appropriate folders, and missing folders are created.
    %
    %   2) Existing Folder Structure (Non-BIDS or Missing Parts):
    %     - Checks for existing folder structures.
    %     - Creates the necessary directory hierarchy.
    %
    % Example Usage:
    %   create_dataset_architecture('/path/to/dataset');
    %
    % Notes:
    %   - The function assumes the EEG data follows BIDS conventions.
    %   - The default session name is 'sess-01', and the default EEG data folder
    %     name is 'eeg'.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]

    def_sess_name = 'sess-01';
    def_eeg_name = 'eeg';
    
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

