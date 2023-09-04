
function create_dataset_architecture()

    files = dir(pwd);
    dirFlags = [files.isdir];
    subFolders = files(dirFlags);
    subFolders = subFolders(3:end);

    for i=1:length(subFolders)
        subject_folder_name = [pwd '/' subFolders(i).name];
        cd(subject_folder_name)    %Check if session folders are present

        files = dir(pwd);
        dirFlags = [files.isdir];
        sessFolders = files(dirFlags);
        sessFolders = sessFolders(3:end);

        if isempty(sessFolders)
           mkdir([subject_folder_name '/sess-01/eeg'])
           movefile([subject_folder_name '/*'],[subject_folder_name '/sess-01/eeg']) %If no session folders present, assume 1 session.

        elseif length(sessFolders)==1 && string(sessFolders(1).name) == "eeg"
           session_folder_name = [pwd '/' sessFolders(1).name];   
           mkdir([subject_folder_name '/sess-01/eeg'])
           movefile([session_folder_name '/*'],[subject_folder_name '/sess-01/eeg'])

           rmdir eeg
    
        else         
            for j=1:length(sessFolders)
                session_folder_name = [pwd '/' sessFolders(j).name];                
                cd(session_folder_name)    %Check if eeg folder is present

                files = dir(pwd);
                dirFlags = [files.isdir];
                eegFolder = files(dirFlags);
                eegFolder = eegFolder(3:end);

                if isempty(eegFolder)
                    movefile([session_folder_name '/*'],[session_folder_name '/eeg/']) %If no session folders present, assume 1 session.
                elseif length(eegFolder)==1 && string(eegFolder(1).name) ~= "eeg"
                    movefile([session_folder_name '/' eegFolder(1).name],[session_folder_name '/eeg/']);
                end
                cd ..
            end
        end
        cd ..
    end

end

