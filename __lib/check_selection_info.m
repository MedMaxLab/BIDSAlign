function [] = check_selection_info(selection_info, raise_allempty)
    % FUNCTION: check_selection_info
    %
    % Description: Validates the parameters provided in the selection_info
    %              structure for dataset selection.
    %
    % Syntax:
    %   check_selection_info(selection_info)
    %
    % Input:
    %   - selection_info (struct): Structure containing information about dataset selection options.
    %
    % Output: None.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %

    if nargin < 2
        raise_allempty = false;
    end

    validScalarInt = @(x) isscalar(x) && mod(x,1)==0;
    validStringChar= @(x) isstring(x) || ischar(x);

    if raise_allempty && selection_info.select_subjects
        if isempty(selection_info.sub_i) && ...
                isempty(selection_info.sub_f) && ...
                isempty(selection_info.ses_i) && ...
                isempty(selection_info.ses_f) && ...
                isempty(selection_info.obj_i) && ...
                isempty(selection_info.obj_f) && ...
                isempty(selection_info.label_name) && ...
                isempty(selection_info.label_value) && ...
                (isequal(selection_info.subjects_totake, {{}}) ...
                     || isempty(selection_info.subjects_totake)) && ...
                (isequal(selection_info.session_totake, {{}}) ...
                     || isempty(selection_info.session_totake)) && ...
                (isequal(selection_info.task_totake, {{}}) ...
                     || isempty(selection_info.task_totake))

            error('select_subjects cannot be true with all other field empty')
        end
    end
    
    if ~isempty(selection_info.sub_i)
        if validScalarInt(selection_info.sub_i)
            if selection_info.sub_i < 0 
                error('sub_i must be a scalar integer bigger than 0')
            end
        else
            error('sub_i must be a scalar integer bigger than 0')
        end
    end
    
    if ~isempty(selection_info.sub_f)
        if validScalarInt(selection_info.sub_f)
            if selection_info.sub_f < 0 
                error('sub_f must be a scalar bigger than 0')
            end
        else
            error('sub_f must be a scalar integer bigger than 0')
        end
    end
    
    if ~isempty(selection_info.sub_i) && ~isempty(selection_info.sub_f)
        if validScalarInt(selection_info.sub_i) && validScalarInt(selection_info.sub_f)
            if selection_info.sub_i > selection_info.sub_f
                error('sub_i must be lower than sub_f')
            end
        end
    end
    
    
    if ~isempty(selection_info.ses_i)
        if validScalarInt(selection_info.ses_i)
            if selection_info.ses_i < 0 
                error('ses_i must be a scalar integer bigger than 0')
            end
        else
            error('ses_i must be a scalar integer bigger than 0')
        end
    end
    
    if ~isempty(selection_info.ses_f)
        if validScalarInt(selection_info.ses_f)
            if selection_info.ses_f < 0 
                error('ses_f must be a scalar integer bigger than 0')
            end
        else
            error('ses_f must be a scalar integer bigger than 0')
        end
    end
    
    if ~isempty(selection_info.ses_i) && ~isempty(selection_info.ses_f)
        if ~isscalar(selection_info.ses_i) && ~isscalar(selection_info.ses_f)
            if selection_info.ses_i > selection_info.ses_f
                error('ses_i must be lower than ses_f')
            end
        end
    end
    
    
    if ~isempty(selection_info.obj_i)
        if validScalarInt(selection_info.obj_i)
            if selection_info.obj_i < 0 
                error('obj_i must be a scalar bigger than 0')
            end
        else
            error('obj_i must be a scalar integer bigger than 0')
        end
    end
    
    if ~isempty(selection_info.obj_f)
        if validScalarInt(selection_info.obj_f)
            if selection_info.obj_f < 0 
                error('obj_f must be a scalar bigger than 0')
            end
        else
            error('obj_f must be a scalar integer bigger than 0')
        end
    end
    
    if ~isempty(selection_info.obj_i) && ~isempty(selection_info.obj_f)
        if ~isscalar(selection_info.obj_i) && ~isscalar(selection_info.obj_f)
            if selection_info.obj_i > selection_info.obj_f
                error('obj_i must be lower than obj_f')
            end
        end
    end
    
    if ~islogical(selection_info.select_subjects)
        error('select_subjects must be a boolean')
    end

    if ~validStringChar(selection_info.label_name)
        error('label_name must be a string or char array')
    end
    
    if ~(validStringChar(selection_info.label_value) || ...
            isscalar(x))
        error('label_value must be a string or char array or a valid scalar')
    end
                              
    if ~isempty(selection_info.subjects_totake) || ...
            ~isequal(selection_info.subjects_totake, {{}})
        if ~iscellstr( selection_info.subjects_totake)
            error('subjects_totake must be a cell array with char vectors')
        end
    end
    
    if ~isempty(selection_info.session_totake) || ...
            ~isequal(selection_info.session_totake, {{}})
        if ~iscellstr( selection_info.session_totake)
            error('session_totake must be a cell array with char vectors')
        end
    end
    
    if ~isempty(selection_info.task_totake) || ...
            ~isequal(selection_info.task_totake, {{}})
        if ~iscellstr( selection_info.task_totake)
            error('task_totake must be a cell array with char vectors')
        end
    end 
        
end