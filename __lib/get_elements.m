
function [vec_list, list] = get_elements(list, index_i, index_f, select_files, folder_level, verbose)
    % FUNCTION: get_elements
    %
    % Description: Retrieves a subset of elements from a list based on
    % specified criteria. From the list of files, it first select those
    % matching the select_files, and then select those matching index_i and
    % index_f.
    %
    % Syntax:
    %   [vec_list, list] = get_elements(list, index_i, index_f, select_files, folder_level, verbose)
    %
    % Input:
    %   - list (list): List of elements to select from.
    %   - index_i (numeric): Starting index for selection (optional).
    %   - index_f (numeric): Ending index for selection (optional).
    %   - select_files (cell array): Cell array of strings to filter the list
    %                   based on file names (optional).
    %   - folder_level (char): String specifying the folder level for selection
    %                   (e.g., 'SUBJECTS').
    %   - verbose (logical): Flag to control verbosity of output.
    %
    % Output:
    %   - vec_list (numeric array): List of selected indices from the original list.
    %   - list (list): Updated list after applying the specified selection criteria.
    %
    % Notes:
    %   - This function allows the user to filter a list of elements
    %     based on various criteria, including index range, file name 
    %     filtering, and folder level.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]

    % Take only selected files
    if nargin < 6
        verbose =  false;
    end
    
    %Select by folder_level
    if ~isempty(select_files)
        z_list = [];
        for z = 1:length(list)
            mask = false;
            for p=1:length(select_files)
                if isequal(folder_level,'SUBJECTS')
                    mask = mask || contains(list(z), select_files{p});
                else
                    mask = mask || contains(list(z).name, select_files{p});
                end
            end
            if mask 
                z_list = [z_list, z];
            end
        end
        if isempty(z_list)
            error(['ERROR: REQUESTED ' folder_level ' TO TAKE NOT FOUND']);
        else      
            list = list(z_list);
        end
    end
    N = length(list);
    folder_acronym = folder_level(1:3);

    % Select file using the index or the requested number
    vec = 1:1:N;
    if isempty(index_i) && isempty(index_f)
            vec_list = vec;
    elseif isempty(index_i) && ~isempty(index_f)
        if index_f>=N
            if verbose
                warning([folder_acronym '_F IS IGNORED SINCE> N ' folder_level]);
            end
            vec_list = vec;
        else
            vec_list = vec(1:index_f);
        end
    elseif ~isempty(index_i) && isempty(index_f)
        if index_i>=N
            if verbose
                warning([folder_acronym '_I IS IGNORED SINCE> N ' folder_level]);
            end
            vec_list = vec;
        else
            vec_list = vec(index_i:end);
        end
    else
        if index_i > index_f %Cases C,D,F (f<i<N; f<N<i; N<f<i)
            error(['ERROR: ' folder_acronym '_I>' folder_acronym '_F']);
        else
            if index_i > N %Case E (N<i<f)
                if verbose
                    warning([folder_acronym '_I AND ' folder_acronym '_F> N ' folder_level]);
                end
                vec_list = vec;
            else
                if index_f > N %Case B (i<N<f)
                    if verbose
                        warning([folder_acronym '_F> N ' folder_level]);
                    end
                    vec_list = vec(index_i:end);
                else %Case A (i<f<N)
                    vec_list = vec(index_i:index_f);
                end
            end
        end
    end
end

