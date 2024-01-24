function [] = check_path_info(path_info, must_give_datasets_path)

    
    if nargin < 2
        must_give_datasets_path = false;
    end
    validPath = @(x) isfolder(x);
    
    if ~isempty(path_info.datasets_path)
        if ~validPath(path_info.datasets_path) && ~ischar(path_info.datasets_path)
            error(' datasets path is not valid')
        end
    else
        if must_give_datasets_path
            error('datasets path not given, but it is required for the next steps')
        end
    end

    if ~isempty(path_info.output_path)
        if ~validPath(path_info.output_path) && ~ischar(path_info.output_path)
            error(' output path is not valid')
        end
    end
    
    if ~isempty(path_info.output_mat_path)
        if ~validPath(path_info.output_mat_path) && ~ischar(path_info.output_mat_path)
            error(' output mat path is not valid')
        end
    end
    
    if ~isempty(path_info.output_csv_path)
        if ~validPath(path_info.output_csv_path) && ~ischar(path_info.output_csv_path)
            error(' output csv path is not valid')
        end
    end
    
    if ~isempty(path_info.output_set_path)
        if ~validPath(path_info.output_set_path) && ~ischar(path_info.output_set_path)
            error(' output set path is not valid')
        end
    end
    
    if ~isempty(path_info.eeglab_path)
        if ~validPath(path_info.eeglab_path) && ~ischar(path_info.eeglab_path)
            error(' eeglab path is not valid')
        end
    end
    
    if ~isempty(path_info.raw_filepath)
        if ~validPath(path_info.raw_filepath) && ~ischar(path_info.raw_filepath)
            error(' path to eeg single file (raw_filepath) is not valid')
        end
    end

end