function selection_info = set_selection_info(varargin)

% Da completare la descrizione delle variabili

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
    validScalarInt = @(x) isscalar(x) && mod(x,1)==0;
    validStruct = @(x) isstruct(x) ;
    
    p.addOptional('selection_info', defaultSelectionInfo, validStruct);
    
    p.addParameter('sub_i', defaultSubstart, validScalarInt);
    p.addParameter('sub_f', defaultSubend, validScalarInt);
    p.addParameter('ses_i', defaultSesstart, validScalarInt);
    p.addParameter('ses_f', defaultSesend, validScalarInt);
    p.addParameter('obj_i', defaultObjstart, validScalarInt);
    p.addParameter('obj_f', defaultObjend, validScalarInt);
    
    p.addParameter('select_subjects', defaultSelectSubject, validBool);
    p.addParameter('label_name', defaultLabelName, validStringChar);
    p.addParameter('label_value', defaultLabelValue, validStringChar);
    
    p.addParameter('subjects_totake', defaultSubjectsToTake, validCell);
    p.addParameter('session_totake', defaultSessionToTake, validCell);
    p.addParameter('task_totake', defaultTaskToTake, validCell);
    
    p.addParameter('store_settings', defaultStoreSettings, validBool);
    p.addParameter('setting_name', defaultSettingName, validStringChar);
    parse(p, varargin{:});

    % Create a struct to store the save information
     if  ~isempty(fieldnames(p.Results.selection_info)) &&  ...
            isempty( setdiff(fieldnames(p.Results.selection_info), p.Parameters' ))
        
        param2set = setdiff( setdiff( p.Parameters, {'setting_name' 'standard_ref'}), ...
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
         if not( isfolder( [filePath(1:length(filePath)-18)  '/default_settings/' p.Results.setting_name]) )
             mkdir( [filePath(1:length(filePath)-18)  '/default_settings/'] , p.Results.setting_name)
         end
         save( [ filePath(1:length(filePath)-18)  '/default_settings/' p.Results.setting_name '/selection_info.mat'], 'selection_info');
     end

end
