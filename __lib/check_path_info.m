function [] = check_path_info(path_info, must_give_datasets_path)
    % FUNCTION: check_path_info
    %
    % Description: Validates the paths provided in the path_info structure.
    %
    % Syntax:
    %   check_path_info(path_info, must_give_datasets_path)
    %
    % Input:
    %   - path_info (struct): Structure containing paths for different components.
    %   - must_give_datasets_path (logical): Boolean indicating whether datasets_path is required (default: false).
    %
    % Output: 
    %   - None. It throws an error if any path is invalid.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %
    
    if nargin < 2
        must_give_datasets_path = false;
    end
    validPath = @(x) isfolder(x);
    
    if ~isempty(path_info.datasets_path)
        if ~(validPath(path_info.datasets_path) && ischar(path_info.datasets_path))
            error(' datasets path is not valid')
        end
    else
        if must_give_datasets_path
            error('datasets path not given, but it is required for the next steps')
        end
    end

    if ~isempty(path_info.output_path)
        if ~(validPath(path_info.output_path) && ischar(path_info.output_path))
            error(' output path is not valid')
        end
    end
    
    if ~isempty(path_info.output_mat_path)
        if ~(validPath(path_info.output_mat_path) && ischar(path_info.output_mat_path))
            error(' output mat path is not valid')
        end
    end
    
    if ~isempty(path_info.output_csv_path)
        if ~(validPath(path_info.output_csv_path) && ischar(path_info.output_csv_path))
            error(' output csv path is not valid')
        end
    end
    
    if ~isempty(path_info.output_set_path)
        if ~(validPath(path_info.output_set_path) && ischar(path_info.output_set_path))
            error(' output set path is not valid')
        end
    end
    
    if ~isempty(path_info.eeglab_path)
        if ~(validPath(path_info.eeglab_path) && ischar(path_info.eeglab_path))
            error(' eeglab path is not valid')
        end
    end
    
    if ~isempty(path_info.raw_filepath)
        if ~(validPath(path_info.raw_filepath) && ischar(path_info.raw_filepath))
            error(' path to eeg single file (raw_filepath) is not valid')
        end
    end

end