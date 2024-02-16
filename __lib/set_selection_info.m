
function selection_info = set_selection_info(varargin)
    % FUNCTION: set_selection_info
    %
    % Description: Sets or updates the selection information for the EEG processing pipeline.
    %
    % Syntax:
    %   selection_info = set_selection_info(varargin)
    %
    % Input:
    %   - varargin (optional): A list of parameter-value pairs for customizing the selection information.
    %
    % Output:
    %   - selection_info: A struct containing the selection information.
    %
    % Parameters:
    %   - sub_i (integer): Start index for subject selection.
    %   - sub_f (integer): End index for subject selection.
    %   - ses_i (integer): Start index for session selection.
    %   - ses_f (integer): End index for session selection.
    %   - obj_i (integer): Start index for object selection.
    %   - obj_f (integer): End index for object selection.
    %   - select_subjects (logical): A flag indicating whether to select
    %                                specific group of subjects.
    %   - label_name (char): Name of the label for selection, a feature
    %                        present in participant.tsv file.
    %   - label_value (char): Value of the label for selection.
    %   - subjects_totake (cell): Specify the part of the subjects' names 
    %                             to be included in the analysis.
    %   - session_totake (cell): Specify the part of the sessions' 
    %                            names to be included in the analysis.
    %   - task_totake (cell): Specify the part of tasks' names to be 
    %                         included in the analysis.
    %   - store_settings (logical): A flag indicating whether to store 
    %                               the settings (default: false).
    %   - setting_name (char): Name of the setting if storing
    %                          settings (default: 'default').
    %
    % Author: [Federico Del Pup]
    % Date: [27/01/2024]
    % 

    defaultSubstart = [];
    defaultSubend = [];
    defaultSesstart = [];
    defaultSesend =[];
    defaultObjstart = [];
    defaultObjend= [];
    defaultSelectSubject = false;
    defaultLabelName = '';
    defaultLabelValue = '';
    defaultSubjectsToTake = {{}};
    defaultSessionToTake = {{}};
    defaultTaskToTake = {{}};
    defaultStoreSettings= false;
    defaultSettingName = 'default';
    defaultSelectionInfo = struct;

    
    p = inputParser;
    validStringChar= @(x) isstring(x) || ischar(x);
    validBool= @(x) islogical(x);
    validCell = @(x) iscell(x);
    validEmptyOrScalarInt = @(x) isempty(x) || (isscalar(x) && mod(x,1)==0);
    validStruct = @(x) isstruct(x) ;
    
    p.addOptional('selection_info', defaultSelectionInfo, validStruct);
    
    p.addParameter('sub_i', defaultSubstart, validEmptyOrScalarInt);
    p.addParameter('sub_f', defaultSubend, validEmptyOrScalarInt);
    p.addParameter('ses_i', defaultSesstart, validEmptyOrScalarInt);
    p.addParameter('ses_f', defaultSesend, validEmptyOrScalarInt);
    p.addParameter('obj_i', defaultObjstart, validEmptyOrScalarInt);
    p.addParameter('obj_f', defaultObjend, validEmptyOrScalarInt);
    
    p.addParameter('select_subjects', defaultSelectSubject, validBool);
    p.addParameter('label_name', defaultLabelName, validStringChar);
    p.addParameter('label_value', defaultLabelValue, ...
        @(x) isscalar(x) || validStringChar(x) );
    
    p.addParameter('subjects_totake', defaultSubjectsToTake, validCell);
    p.addParameter('session_totake', defaultSessionToTake, validCell);
    p.addParameter('task_totake', defaultTaskToTake, validCell);
    
    p.addParameter('store_settings', defaultStoreSettings, validBool);
    p.addParameter('setting_name', defaultSettingName, validStringChar);
    parse(p, varargin{:});

    % Create a struct to store the save information
     if  ~isempty(fieldnames(p.Results.selection_info)) &&  ...
            isempty( setdiff(fieldnames(p.Results.selection_info), p.Parameters' ))
        
        param2set = setdiff( setdiff( p.Parameters, {'setting_name' 'store_settings'}), ...
            [p.UsingDefaults 'selection_info']);
        selection_info = p.Results.selection_info;
        for i = 1:length(param2set)
                selection_info.(param2set{i}) = p.Results.(param2set{i});
        end     
        
     else
         selection_info = struct('sub_i',p.Results.sub_i,...
                                 'sub_f',p.Results.sub_f,...
                                 'ses_i',p.Results.ses_i,...
                                 'ses_f',p.Results.ses_f,...
                                 'obj_i',p.Results.obj_i,...
                                 'obj_f',p.Results.obj_f,...
                                 'select_subjects',p.Results.select_subjects,...
                                 'label_name',p.Results.label_name,...
                                 'label_value',p.Results.label_value,...
                                 'subjects_totake',p.Results.subjects_totake,...
                                 'session_totake', p.Results.session_totake,...
                                 'task_totake', p.Results.task_totake);

     end
     
     check_selection_info(selection_info);
     
     % store settings if asked to do so
     if p.Results.store_settings
         filePath = mfilename('fullpath');
         if not( isfolder( [filePath(1:length(filePath)-18) ...
                 filesep 'default_settings' filesep p.Results.setting_name]) )
             mkdir( [filePath(1:length(filePath)-18) ...
                 filesep 'default_settings' filesep] , p.Results.setting_name)
         end
         save( [ filePath(1:length(filePath)-18)  filesep 'default_settings' filesep ...
             p.Results.setting_name filesep 'selection_info.mat'], 'selection_info');
     end

end
