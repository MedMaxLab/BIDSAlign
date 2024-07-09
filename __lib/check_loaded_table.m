function [] = check_loaded_table(dataset_info)
    % FUNCTION: check_loaded_table
    %
    % Description: Checks the integrity of the loaded dataset information table.
    %
    % Syntax:
    %   check_loaded_table(dataset_info)
    %
    % Input:
    %   - dataset_info (table): Table containing information about EEG datasets.
    %
    % Notes:
    %   - This function verifies that the input table has the correct structure,
    %     including the right number of columns, column names, and data types.
    %     It also checks for duplicates and empty values in specific columns.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %
    
    % check that input is table
    if ~istable(dataset_info)
        error('wrong input class. Please give a table as input argument')
    end

    % check that table has 11 columns with the right format
    if size(dataset_info,2) ~= 11
        error('dataset info table must have 11 columns')
    end
    
    % check that table has the right column names
    variable_names_types = [ ...
        ["dataset_number_reference",    "double"]; ...
        ["dataset_name",                "char"]; ...
        ["dataset_code",                "char"]; ...
        ["channel_location_filename",   "char"]; ...
        ["nose_direction",              "char"]; ...
        ["channel_system",              "char"]; ...
        ["channel_reference",           "char"]; ...
        ["channel_to_remove",           "char"]; ...
        ["eeg_file_extension",          "char"]; ...
        ["samp_rate",                   "double"]; ...
        ["line_noise",                  "double"]; ...
    ]; 
    variable_names = dataset_info.Properties.VariableNames;
    if ~isempty( setdiff(variable_names_types(:,1), variable_names) )
        error('missing needed columns in the given table')
    end
    
    % check that table has the right types per columns
    for i= 1:size(variable_names_types,1)
        if i == 1 || i==10 || i==11
            if ~isscalar( dataset_info.(variable_names_types(i,1))(1) )
                error('wrong type detected')
            end
        else
            if ~ischar( dataset_info.(variable_names_types(i,1)){1})
                error('wrong type detected')
            end
        end        
    end
    
    % check for empty values in some columns where it is not allowed
    for i = [1 2 3 6 7 9 10]
        if i==1 || i==10
            empty_rows = sum( isnan( dataset_info.(variable_names_types(i,1)) ) );
        else
            empty_rows = sum(cellfun(@isempty, ...
                dataset_info.(variable_names_types(i,1)) ));
        end
        if empty_rows ~= 0
            error(['found empty values in '  variable_names_types(i,1) ...
                '. This column must be filled completely'])
        end
    end
    
    %check for duplicates in dataset_name and dataset_code
    for i=1:height(dataset_info) 
        matching_rows = strcmp(dataset_info.dataset_name, dataset_info.dataset_name{i});
        c = sum(matching_rows);
        if c ~= 1
            error('found multiple datasets with the same name');
        end
        matching_rows = strcmp(dataset_info.dataset_code, dataset_info.dataset_code{i});
        c = sum(matching_rows);
        if c ~= 1
            error('found multiple datasets with the same folder name (dataset_code)');
        end
    end

end