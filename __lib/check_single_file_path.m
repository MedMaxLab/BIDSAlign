function [raw_filepath, dataset_name, path_info] = check_single_file_path(path_info, ...
    dataset_info, dataset_name )

    raw_filepath = path_info.raw_filepath;
    
    % if raw_filepath isempty return an error
    if isempty(path_info.raw_filepath)
        error("Cannot process a single file without knowing its name or path." + ...
            "Please give a proper file name as char or string using the " + ...
            " 'raw_filename' argument or set it in the presaved path_info struct");
    
    else

        % raw_filepath is not a valid path to a file. This will never
        % happened due to the numerous checks but an additional check
        % is not a problem for performance
        if ~isfile(path_info.raw_filepath)
            error("path_info stored a path which is not valid." + ...
                "Please correct it or give in input a new one" + ...
                " using the 'raw_filename' argument");
        else
            
            % must verify if the retrieved dataset_code is included in
            % the table or is the same as the one of dataset name
            dataset_code_check = dataset_name_from_raw( ...
                path_info.raw_filepath, path_info.datasets_path);

            % if isempty, check that code is included in the table and
            % add proper dataset name
            if isempty(dataset_name) 

                % extract right name or give error
                if any(strcmp(dataset_code_check, dataset_info.dataset_code))
                    rows=  strcmp( dataset_code_check , dataset_info.dataset_code);
                    dataset_name = dataset_info{rows,"dataset_name"};
                    dataset_name = dataset_name{1};
                    raw_filepath = path_info.raw_filepath;
                else
                    error(['Incompatibility with datasets_name and extracted dataset_code.' ...
                        ' Please check that paths are correct.'])
                end

            else
                rows=  strcmp( dataset_code_check , dataset_info.dataset_code);
                dataset_name_check = dataset_info{rows,"dataset_name"};
                dataset_name_check = dataset_name_check{1};
                if ~isequal( dataset_name_check,dataset_name)
                    error( ['File not included in the selected dataset. File was found in ' ...
                        dataset_name_check ' dataset.'])
                else
                    raw_filepath = path_info.raw_filepath;
                end
            end

        end
    end

end