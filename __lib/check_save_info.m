function [] = check_save_info(save_info)
    % FUNCTION: check_save_info
    %
    % Description: Validates the parameters provided in the save_info structure for data saving.
    %
    % Syntax:
    %   check_save_info(save_info)
    %
    % Input:
    %   - save_info: Structure containing information about data saving options.
    %
    % Output: 
    %   - None. It throws an error if any parameter is invalid.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %
    
    validStringChar= @(x) isstring(x) || ischar(x);
    
    if ~islogical(save_info.save_data)
        error('save_data must be a boolean')
    end
    
    if ~islogical(save_info.save_set)
        error('save_set must be a boolean')
    end
    
    if ~islogical(save_info.save_struct)
        error('save_struct must be a boolean')
    end
    
    if ~islogical(save_info.save_marker)
        error('save_marker must be a boolean')
    end

    if validStringChar(save_info.save_data_as)
        if isempty(save_info.save_data_as) || ~any(strcmp(save_info.save_data_as, {'matrix', 'tensor'}))
            error("save_data_as must be a char or string vector with 'matrix' or 'tensor'")
        end
    else
        error("save_data_as must be a char or string vector with 'matrix' or 'tensor'")
    end
    
end