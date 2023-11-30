
function [vec_list, list] = get_elements(list, index_i, index_f, select_files, folder_level)

    % Take only selected files
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
            warning([folder_acronym '_F IS IGNORED SINCE> N ' folder_level]);
            vec_list = vec;
        else
            vec_list = vec(1:index_f);
        end
    elseif ~isempty(index_i) && isempty(index_f)
        if index_i>=N
            warning([folder_acronym '_I IS IGNORED SINCE> N ' folder_level]);
            vec_list = vec;
        else
            vec_list = vec(index_i:end);
        end
    else
        if index_i > index_f %Cases C,D,F
            error(['ERROR: ' folder_acronym '_I>' folder_acronym '_F']);
        else
            if index_i > N %Case E
                warning([folder_acronym '_I AND ' folder_acronym '_F> N ' folder_level]);
                vec_list = vec;
            else
                if index_f > N %Case B
                    warning([folder_acronym '_F> N ' folder_level]);
                    vec_list = vec(index_i:end);
                else %Case A
                    vec_list = vec(index_i:index_f);
                end
            end
        end
    end
end

