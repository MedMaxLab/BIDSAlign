function empty_table = create_empty_table( datasets_number, data_info, save_path) 
    % FUNCTION: create_empty_table
    %
    % Description: Creates an empty table with specified format for storing dataset information.
    %
    % Syntax:
    %   empty_table = create_empty_table(datasets_number, data_info, save_path)
    %
    % Input:
    %   - datasets_number (numeric): Number of datasets to be represented in the table.
    %   - data_info (struct): (Optional) Cell array containing dataset information.
    %   - save_path (char): (Optional) Path to save the table as a CSV file.
    %
    % Output: 
    %   - empty_table (table): Table with the specified format for storing dataset information.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %

    if ~nargin
        datasets_number = 1;
        data_info = {};
        save_path='';
    elseif nargin < 2
        data_info = {};
        save_path='';
    elseif nargin< 3
        save_path='';
    end
    
    % define columns name and type
    variable_names_types = [["dataset_number_reference", "double"]; ...
                                            ["dataset_name", "char"]; ...
                                            ["dataset_code", "char"]; ...
                                            ["channel_location_filename", "char"]; ...
                                            ["nose_direction", "char"]; ...
                                            ["channel_system", "char"]; ...
                                            ["channel_reference", "char"]; ...
                                            ["channel_to_remove", "char"]; ...
                                            ["eeg_file_extension","char"]; ...
                                            ["samp_rate", "double"] ...
                                           ]; 
    
    if isempty(data_info)
        % if no dataset info were given, simply create an empty
        % table and suppress all char warnings
        
        % create empty table with the specified format 
        warning('off', 'MATLAB:table:PreallocateCharWarning')
        empty_table = table('Size',[datasets_number,size(variable_names_types,1)],... 
          'VariableNames', variable_names_types(:,1),...
          'VariableTypes', variable_names_types(:,2));
        warning ('on', 'MATLAB:table:PreallocateCharWarning')
    else
        % if dataset info were given, first check that the 
        % input is correct by looking at dimensions and types
        [N, M] = size(data_info);
        if M ~=10 || N > datasets_number
            error( ["incompatible size of given data info." ...
                " Data_info must have size(1) < datasets_number and size(2) == 10. " ...
                " See help for more info."])
        end
        for i = 1:10
            if i == 1 || i==10
                if ~isnumeric(data_info{1,i}) || ...
                        isnan(data_info{1,i}) || ...
                        isinf(data_info{1,i})
                    error("wrong data type used in the given_data info. " + ...
                        " See help for more info")
                end
            else
                if ~ischar(data_info{1,i})
                    error("wrong data type used in the given data_info." + ...
                        " See help for more info")
                end
            end
        end   
        
        % then fill dataset info into the table. 
        % If size is equal to the  number of subjects, 
        % meaning that a complete set of 
        % information was given, simply call cell2table
        %
        % Otherwise, create an empty table and fill the partial
        % information
        if N == datasets_number
            empty_table = cell2table(data_info, ...
                'VariableNames', variable_names_types(:,1));
        else
            % create empty table with the specified format 
            warning('off', 'MATLAB:table:PreallocateCharWarning')
            empty_table = table( ...
                'Size', [datasets_number,size(variable_names_types,1)], ... 
                'VariableNames', variable_names_types(:,1), ...
                'VariableTypes', variable_names_types(:,2));
            warning ('on', 'MATLAB:table:PreallocateCharWarning')
            for i = 1:N
                for k = 1:M
                    if k ==1 || k==10
                        empty_table{i,k} = data_info{i,k};
                    else
                        empty_table{i,k} =data_info(i,k);
                    end
                end
            end
            
        end
    end

    % save table with save_path, if given
    if ~isempty(save_path)
        % if a path without a name is given, try to add 
        % a name until a new one is available. 
        % This will avoid overwrites  of prexisting tables. 
        % If save_path is not a valid path,, possibly 
        % beacuse it is a filename, or a path ending with the 
        % file name, try to save the table using the save_path string
        if isfolder(save_path)
            tablename = [save_path filesep 'dataset_info.csv'];
            file_exist = isfile(tablename);
            cnt =1;
            while file_exist
                tablename = [save_path filesep 'dataset_info_' char(string(cnt)) '.csv'];
                file_exist = isfile(tablename);
                cnt = cnt + 1; 
            end     
        else
            tablename = save_path;
        end
        writetable( empty_table, tablename); 
    end
end