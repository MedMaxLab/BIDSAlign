function DATA_STRUCT = preprocess_all_guided()

    clc
    Logo = [  "-------------------------------------------------------------------------------------"
                    " ______ _____ _____  ______ ______ __ __   "           
                    "|   __   \_     _|       \ |      __|     _    |   |__|.-------.-------."
                    "|   __ <_|   |_|  --     |__      |           |   |   ||   _    |        |"
                    "|______/_____|_____/|_____ |___|___|__|__||___    |__|__|"
                    "                                                             |_____|      "
                    "------------------------------------------------------------- MedMax Team --"
                    ];        
    fprintf('%s\n',Logo{:})
    fprintf('%s\n',[""
        ""]);
    ok = false;
    while ~ok
        start_bids = input(' press Enter to start or write quit to close: ','s');
        if ~isempty(start_bids)
            % exit if necessary
            if strcmpi(start_bids,'quit') || strcmpi(start_bids,"'quit'") 
                disp('closing BIDSAlign guided preprocessing')
                return
            else
                ok = true;
            end
        else
            ok= true;
        end
    end
        
    clc
    text2print = [ " " 
        " Welcome to the BIDSalign guided preprocessing!"
        ""
        " This guided code will help you set all the parameters  necessary to preprocess your collection "
        " of datasets (or single). "
        ""
        " Remember that you can exit this code at any time by entering 'quit' when asked for a prompt." 
        " "];
    fprintf('%s\n',text2print{:})
    text2print = [
        " First of all, BIDSAlign needs some information regarding your datasets specs."
        " They must be provided through a table, with the format specified in the documentation."
        ""
        " If you have already prepared the table digit the table file name, or the complete path if the "
        " file is located outside the current working directory."
        ""
        " If you haven't prepared the dataset table yet, you can either press enter to start a "
        " guided procedure for the table creation or exit this function and prepare a new one by your own."
        " We strongly suggest you to create the table outside this function, as it is much easier." 
        " Creating a new table by using only the command window during this guided procedure "
        " is tricky due to the inability to open a variable window inside a function."
        " "];
    fprintf('%s\n',text2print{:})

    
    % -------------------------------------------------------------
    % STEP 1: IMPORT DATASETS INFO FROM TABLE
    % -------------------------------------------------------------
    ok = false;
    while ~ok
        dataset_info_filename = input(' Digit table file name or path or press Enter: ','s');
        
        if ~isempty(dataset_info_filename)
            % exit if necessary
            if strcmpi(dataset_info_filename,'quit') || strcmpi(dataset_info_filename,"'quit'") 
                disp('closing BIDSAlign guided preprocessing')
                return
            end
            % try using the input for load the table, and check that the
            % table is formatted as required
            try
                % Read the dataset information from a tsv file
                dataset_info = readtable(dataset_info_filename, 'format','%f%s%s%s%s%s%s%s%s%f','filetype','text');
                check_loaded_table(dataset_info);
                ok = true;
            catch
                disp('given filename or path is not valid. Please enter a correct one')
            end
        else
            % select the number of datasets
            ok2 = false;
            fprintf('%s\n', [ " "  
                " " 
                " Starting the creation of a new dataset table" 
                " First of all, BIDSAlign must know the number of dataset to preprocess "])
            while ~ok2
                try 
                    subjects = input(' Digit the number of datasets to preprocess: ','s');
                    if strcmpi(subjects,'quit') || strcmpi(subjects,"'quit'") 
                        disp(' closing BIDSAlign guided preprocessing')
                        return
                    end
                    subjects = str2double(subjects);
                    if isnan(subjects) || floor(subjects)~=subjects
                        error("wrong input")
                    end
                    ok2 = true;
                catch
                    fprintf('%s\n', "input must be an integer (or quit)")
                end
            end
            dataset_info = create_empty_table(subjects);
            
            % fill empty table
            ok2 = false;
            fprintf('%s\n',  "Now you need to fill the table with all the necessary information.")
            filltableinfo = [ " "
                "The table has the following 10 fields to be (partially) filled:"
                " "
                "1- dataset_number_reference : an integer used to during the save operation. No duplicates are allowed"
                "2- dataset_name : a char array with the name of the dataset. No duplicates are allowed"
                "3- dataset_code : a char array with the name of the folder having all the files of a dataset. "
                "                            No duplicates are allowed"
                "4- channel_location_filename : a char array with the name of a specific channel location file to use for"
                "                                                the entire dataset. Note that files like '_electrodes.tsv' or _channels.tsv' "
                "                                                should be included in every pposition inside the bIDS structure. If no"
                "                                                particular files should be considered, simply leave this field empty."
                "                                                if the eeg files have already the channel coordinates, please enter 'loaded' "
                " 5- nose_direction : a char array with the nose directio. It can be any combination of '+/-' and 'X/Y/Z'.  "
                "                               It can be left empty"
                " 6-channel_system : a char array with the channel system used to record the EEGs. It can be any of "
                "                                 '10_10' , '10_20' , 'GSN129' "
                " 7- channel_reference: a char array with the name of the channel used as reference"
                " 8- channel_to_remove : a char array with the list of channels to remove. Channels must be separated by"
                "                                       a comma with no space, for example 'chan1,chan2,chan3'. It can be left empty "
                " 9- eeg_file_extension : a char array with the file extension used to store the EEGs, for example '.edf' "
                " 10- samp_rate : a float with the sampling rate, given in Hz" 
                " "];
            fprintf('%s\n', filltableinfo)
            text2print = [
                    "Once you have done, simply press enter when asked for a prompt "
                    " to procede to the next part of the guided procedure"
                    " -- If you want to read again the arguments description, type 'help' "
                    " -- If you want to visualize the current status of the table, type 'print' "
                    " -- You can fill the table by entering a cell array with the info to be included in the table. "
                    "     Remember that the cell array must have size(1) == subjects and size(2) == 10"
                    "     for example a single row cell array can be {1 'eegdata' 'ds00345610' '' '' '10_10' 'FCZ' '' '.edf' 1000}"
                    " -- if you are working on a terminal and you want to modify a single cell, you can input a string with"
                    "     the table row index, table column index, and value to add as a string with entries separated by a"
                    "     space for example ''10 20 10_20'' (without quotation as the input is always considered a char array),"
                    "     or as a length 3 cell array, for example {10 20 '10_20'}."
                    " "
                    "     No need to use quotation marks when defining a char array (of course you need to use them "
                    "     when defining a char vector inside the cell array)"
                    " "
                    " When enter is pressed, a check on the current status of the table will be performed."
                    " If something wrong is noticed, you will be asked to modify the table until the provided format is ok."
                    ];
            fprintf('%s\n', text2print)
            while ~ok2
                openvar('dataset_info')
                try
                    info2add = input("enter command or table info (or quit): ");
                    %case 1: quit
                    if strcmpi(info2add,'quit') || strcmpi(info2add,"quit") 
                        disp('exit from BIDSAlign guided preprocessing')
                        return
                    end
                    % case 2: cell array, which can be of length 3 or the
                    % same size as the table
                    if info2add(1) == '{'
                        [~, info2add] = evalc(info2add);
                        if size(info2add,2) == 3
                            if info2add{2} == 1 || info2add{2} == 10
                                dataset_info{info2add{1}, info2add{2}} = info2add{3};
                            else
                                dataset_info{info2add{1}, info2add{2}} = info2add(3);
                            end
                        elseif isequal(size(info2add), size(dataset_info))
                            dataset_info = create_empty_table(subjects, info2add);
                        else
                            error("given cell array wasn't in the right format")
                        end
                        
                    % case 3: char array, which can be help, print, or the
                    % info 2 add with the already specified format
                    elseif ischar(info2add)
                        if strcmp(info2add, "help")
                            fprintf('%s\n', filltableinfo)
                        elseif strcmp(info2add, "print")
                            disp(dataset_info)
                        else
                            info_split = strsplit(info2add, ' ');
                            index1 = double(info_split(1));
                            index2 = double(info_split(2));
                            if index2 ==1 || index2 ==10
                                dataset_info{index1,index2} = double(info_split(3));
                            else
                                dataset_info{index1,index2} = {info_split(3)};
                            end
                        end
                        
                    % case 4: empty array, which means you can go on with
                    % all the table checks and if those pass, exit the loop
                    elseif isempty(info2add) 
                        check_loaded_table(dataset_info)
                        ok2 = true;
                        clc
                    end
               
                catch
                    fprintf('%s\n', ["wrong input"
                        " or current table status is not proper for correctly run a preprocessing"])            
                end             
            end %while
            
            ok2 = false;
            while ~ok2
                fprintf('%s\n', ["Would you like to save your table?"
                    "If so, enter a name or path to pass to the save command (remember to add the extension)"
                    "Otherwise press enter to go to the next part"])
                try
                    saving_name = input('Enter a name or press enter to skip: ','s');
                    if strcmpi(saving_name,'quit') || strcmpi(saving_name,"'quit'") 
                        disp('exit from BIDSAlign guided preprocessing')
                        return
                    end
                    if ~isempty(saving_name)
                        writetable( empty_table, tablename); 
                        ok2= true;
                        disp('table saved!')
                    else
                        ok2=true;
                    end
                catch
                    disp('wrong name or path')
                end
            end          
        end % end if isempty
    end %end while

    % --------------------------------------------------------
    % STEP 2:  DEFINE SETTING NAME
    % --------------------------------------------------------
    clc
    fprintf('%s\n', [""
        " Now we need to define all the preprocessing parameters."]);
    current_setting_names = get_stored_settings();
    setting_name= 'default';
    if isempty( current_setting_names)
        fprintf('%s\n', [""
            "there aren't saved custom settings, Using default settings."]);
    else
        fprintf('%s\n', [" "
                        " BIDSaling allows you to save and load a set of predefined "
                        " preprocessing settings. "
                        " "
                        " If you want to load parameters from one of the available custom settings"
                        " please enter the setting name, otherwise press Enter and the default one will be used"])
         fprintf('%s\n', [" Current list of available settings:"
             ""]);
         disp(current_setting_names)
         ok2 = false;
         while~ok2
             try
                 setting_name = input(' Digit the setting name from the available list or press enter: ','s');
                 if strcmpi(setting_name,'quit') || strcmpi(setting_name,"'quit'") 
                     disp(' closing BIDSAlign guided preprocessing')
                     return
                 end
                 if ~any(strcmp( setting_name, current_setting_names))
                     error(" setting not exist ")
                 else
                     ok2= true;
                 end
             catch
                 fprintf('%s\n', " Wrong input. Please enter a valid setting");
             end
         end      
    end
    
    clc
    fprintf('%s\n', [""
        " Now we need to set some parameters necessary to make BIDSAlign work "
        " If you have given a custom setting, this phase is an opportunity to "
        " check that all the parameters have been set correctly "]);
    
    % --------------------------------------------------------
    % STEP 3: IMPORT PATHS SETTING
    % --------------------------------------------------------
    fprintf('%s\n', [""
        " Let's start with the searching and save paths"]);
    sethelp = [""
        " BIDSAlign requires at least to set a path to a folder where all the datasets are stored."
        " Paths which can be set are:"
        ""
        " 1 - datasets_path : a path to a folder with all the datasets to preprocess. Must be a valid path"
        " 2 - output_path : the path used to save all the preprocessing files. If no custom output paths per "
        "                            stored file type will be used, BIDSAling will create three folder used to save all the "
        "                            .mat, .set, and .csv files. Must be a valid path."
        " 3- output_mat_path : a custom path used by BIDSAling for saving the .mat files. It will override the "
        "                                   output_path. Must be a valid path"
        " 4- output_set_path : a custom path used by BIDSAling for saving the .set files. It will override the "
        "                                   output_path. Must be a valid path"
        " 3- output_csv_path : a custom path used by BIDSAling for saving the .csv files. It will override the "
        "                                   output_path. Must be a valid path"
        " 4 - eeglab_path : path to the EEGlab library. By default, BIDSAlign will try to search for a valid path "
        "                            to eeglab. However, if not found (especially if eeglab is placed in a particular folder)"
        "                            you must provide it with this argument"
        " 5 - raw_filepath : path to the specific eeg file to preprocess. It must be given if you want to preprocess"
        "                            only a specific file using the single file mode. It must be a valid path"
        ""];
    fprintf('%s\n', sethelp)
    guide_command =  [""
        " -- press enter to proceed to the next step"
        " -- type help to see again the meaning of each value"
        " -- to change a parameter, write the name of the parameter to overwrite and the "
        "    new value to add, separated by a space. No need to use quotation marks when "
        "    referring to strings or char arrays"
        ""];
    fprintf('%s\n', guide_command);
    ok = false;
    try
        path_info = load_settings(setting_name, 'path');
    catch
        path_info = set_path_info('setting_name', setting_name);
    end
    current_args= {'datasets_path',  'output_path', 'output_mat_path', 'output_csv_path', ...
                              'output_set_path', 'eeglab_path',  'raw_filepath'};
    while~ok
      try
          fprintf('%s\n', [""
              "current paths set:"
              ""]);
          disp(path_info)
          disp('')
          info2add = input("enter command (or quit): ", 's');
          if isempty(info2add)
              check_path_info(path_info, true);
              ok = true;
          elseif strcmpi(info2add,'quit') || strcmpi(info2add,"'quit'")
              disp(' closing BIDSAlign guided preprocessing')
              return
          elseif strcmpi(info2add,'help') || strcmpi(info2add,"'help'")
              fprintf('%s\n', sethelp)
              fprintf('%s\n', guide_command);
          else
              info2add = strsplit(info2add, ' ');
              arg_name = info2add{1};
              arg_value = info2add{2};
              if ~any(strcmp( arg_name, current_args))
                  error(" setting not exist ")
              else
                  path_info = set_path_info(path_info, arg_name, arg_value);
                  check_path_info(path_info);
              end
          end
      catch
          fprintf('%s\n', " Wrong input. Please enter a valid setting");
      end
    end

     
    % --------------------------------------------------------
    % STEP 4: IMPORT PREPROCESSING SETTING
    % --------------------------------------------------------
    clc
    fprintf('%s\n', [""
         " Now we will set all the preprocessing parameters."
         " BIDSAlign is highly customizable, but its preprocessing phase can be summarized in the following steps: "
         " 1 - channel alignment"
         " 2 - channel removal"
         " 3 - segment removal (initial or final ones)"
         " 4 - baseline removal "
         " 5 - resampling "
         " 6 - filtering"
         " 7 - rereferencing"
         " 8 - ICA decopmposition"
         " 9 - IC Rejection with ICLabel"
         " 10 - double-phase ASR (one soft and the other, if needed, more aggresive)"
         ""
         " most of those steps can be performed or not depending on your choice "]);
    sethelp = [""
        " Preprocessing parameters which can be set are:"
        ""
        " --------------------------------- FILTERING ---------------------------------"
        " 1 - filtering : whether to perform filtering or not. Must be a boolean."
        " 2 - low_freq : the low frequency of the filter's bandpass. Must be a positive scalar."
        " 3 - high_freq : the high frequency of the filter's bandpass. must be a positive scalar."
        ""
        " ------------------------------- RESAMPLING -------------------------------"
        " 1 - resampling : whether to perform resampling or not. Must be a boolean."
        " 2 - sampling_rate : the sampling rate to use for resampling. Must be a positive scalar."
        ""
        " ----------------------------- REREFERENCING ----------------------------"
        " 1 - rereference : whether to perform rereferencing or not. Must be a boolean."
        " 2 - standard_ref : the new reference to use for rereferencing. Must be a char array."
        "                              allowed inputs are 'COMMON' or any specific EEG channel name."
        ""
        " ------------------------- CHANNEL ALIGNMENT -------------------------"
        " 1 - interpol_method : the interpolation method to use during the channel alignment. "
        "                                  Must be a char array. Allowed inputs are  invdist| spherical | spacetime"
        ""
        " -------------------------- CHANNEL REMOVAL --------------------------"
        " 1 - rmbaseline : whether to perform baseline removal or not. Must be a boolean."
        ""
        " -------------------------- BASELINE REMOVAL --------------------------"
        " 1 - rmchannels : whether to perform channel removal or not. Must be a boolean."
        ""
        " -------------------------- SEGMENT REMOVAL --------------------------"
        " 1 - rmsegments : whether to perform segment removal or not. Must be a boolean."
        " 2 - dt_i : the initial segment to remove. Must be given in seconds. "
        "               Segment removed is the one from 0 to dt_i. Must be a positive scalar"
        " 3 - dt_f : the final segment to remove. Must be given in seconds. "
        "               Segment removed is the one from dt_f to end. Must be a positive scalar"
        ""
        " ------------------------------------- ASR -------------------------------------"
        " ( for a complete description of the ASR arguments, we strongly suggest you to take"
        "    a look at the clean_artifact of the Clean_rawdata EEGLAB plug-in "
        "    link : https://github.com/sccn/clean_rawdata/blob/master/clean_artifacts.m#L1 )"
        ""
        " 1 - ASR : whether to perform the double-phase ASR or not. Must be a boolean."
        " 2 - flatlineC : the flatline Criterion argument in the clean_artifact function. Must be a positive scalar. "
        " 3 - channelC : the channel Criterion argument in the clean_artifact function. "
        "                        Must be a positive scalar in range [0 1]"
        " 4 - lineC : the line noise Criterion argument in the clean_artifact function. Must be a positive scalar."
        " 5 - windowC : the window Criterion argument in the clean_artifact function. "
        "                        Must be a positive scalar. Suggested range of values is [0.05 0.5]."
        " 6 - burstC : the burst Criterion argument in the clean_artifact function. Must be a float. "
        " 7 - burstR : the burst Rejection argument in the clean_artifact function. Must be a char in 'on' or 'off' "
        " 8 - th_reject : a threshold used by BIDSAlign to decide whether to use an additional and more aggressive "
        "                       ASR or not. Must be a float with the thershold voltage in uV. "
        ""
        " -------------------------------------- ICA --------------------------------------"
        " ICA decomposition will be performed using the pop_runica function check its help for more info"
        " 1 - ICA : whether to perform ICA decomposition or not. Must be a boolean."
        " 2 - ica_type : the type of ICA algorithm to use. Must be any of [ runica | binica | jader | fastica ]."
        " 3 - non_linearity : the type of non linearity to use during ICA calculation."
        "                             Must be any of  pow3 | tanh | gauss | skew "
        " 4 - n_ica : the number of components to extract. Must be a positive integer"
        " ------------------------------------ ICLabel ------------------------------------"
        " ICrejection will be performed by using the ICLabel plugin. check pop_icflag for more info  "
        " 1 - iclabel_thresholds : a 7x2 array with threshold values with limits to include for selection as artifacts"
        ""];
    fprintf('%s\n', sethelp)
    guide_command =  [""
        " -- press enter to proceed to the next step"
        " -- type help to see again the meaning of each value"
        " -- to change a parameter, write the name of the parameter to overwrite and the "
        "    new value to add, separated by a space. No need to use quotation marks when "
        "    referring to strings or char arrays"
        ""];
    fprintf('%s\n', guide_command);
    ok = false;
    try
        params_info = load_settings(setting_name, 'preprocess');
    catch
        params_info = set_preprocessing_info('setting_name', setting_name);
    end
    current_args= {'low_freq',  'high_freq', 'sampling_rate', 'standard_ref', ...
                                'interpol_method',  'flatlineC', 'channelC', 'lineC', ...
                                'burstC',  'windowC', 'burstR', 'th_reject', ...
                                'ica_type',  'non_linearity', 'n_ica', 'dt_i', ...
                                'dt_f',  'rmchannels', 'rmsegments', 'rmbaseline', ...
                                'resampling', 'filtering',  'rereference','ICA','ASR'};
    float_args = {'low_freq',  'high_freq', 'sampling_rate',  'flatlineC', 'channelC', 'lineC', ...
                                'burstC',  'windowC', 'th_reject', 'n_ica', 'dt_i'};
    bool_args = { 'rmchannels', 'rmsegments', 'rmbaseline', ...
                                'resampling', 'filtering',  'rereference','ICA','ASR'};
    array_args = {'iclabel_thresholds'};
    while~ok
      try
          disp('')
          disp('current preprocessing parameters set')
          disp(params_info)
          disp(params_info.prep_steps)
          disp('')
          info2add = input("enter command (or quit): ", 's');
          if isempty(info2add)
              check_preprocessing_info(params_info)
              ok = true;
          elseif strcmpi(info2add,'quit') || strcmpi(info2add,"'quit'")
              disp(' closing BIDSAlign guided preprocessing')
              return
          elseif strcmpi(info2add,'help') || strcmpi(info2add,"'help'")
              fprintf('%s\n', sethelp)
              fprintf('%s\n', guide_command);
          else
              info2add = regexp(info2add,' ','split','once');
              arg_name = info2add{1};
              arg_value = info2add{2};
              if ~any(strcmp( arg_name, current_args))
                  error(" argument not exists.")
              end
              if any(strcmp( arg_name, float_args))
                  arg_value = str2double(arg_value);
              elseif any(strcmp( arg_name, bool_args))
                  arg_value = string2boolean(arg_value);
              elseif any(strcmp( arg_name, array_args))
                  [~,arg_value] = evalc(arg_value);
              end
              params_info = set_preprocessing_info(params_info, arg_name, arg_value);
              check_preprocessing_info(params_info)
          end
      catch
          fprintf('%s\n', " Wrong input. Please enter a valid setting");
      end
    end
    
    % --------------------------------------------------------
    % STEP 5: IMPORT SELECTION SETTING
    % --------------------------------------------------------
    clc
    fprintf('%s\n', [""
        " Now we will set all the selection options"]);
    sethelp = [""
        " With BIDSAlign, you can preprocessed a subset of eegs from each datasets."
        ""
        " Selection can performed at the subject, session, or object level. "
        " Only slices can be chosen by setting the starting and ending indices, (for example from subjects 1 to 10)  "
        ""
        " Selection options which can be set are:"
        " 1 - sub_i :  the starting subject index. Must be a positive scalar integer"
        " 2 - sub_f : the ending subject index. Must be a positive scalar integer"
        " 3 - ses_i :  the starting session index. Must be a positive scalar integer"
        " 4 - ses_f : the ending session index. Must be a positive scalar integer"
        " 5 - obj_i :  the starting object index. Must be a positive scalar integer"
        " 6 - obj_f : the ending object index. Must be a positive scalar integer"
        " 7 - select_subjects : whether to select subjects or not. Must be a boolean"
        " 8 - label_name : the ending subject index. Must be a char array"
        " 9 - label_value : the starting subject index. Must be a char array"
        " 10 - subjects_totake : the subjects to take. Must be a cell array with char vectors"
        " 11 - session_totake : the session to take . Must be a cell array with char vectors"
        " 12 - task_totake : the task to take . Must be a cell array with char vectors"
        ""];
    fprintf('%s\n', sethelp)
    guide_command =  [""
        " -- press enter to proceed to the next step"
        " -- type help to see again the meaning of each value"
        " -- to change a parameter, write the name of the parameter to overwrite and the "
        "    new value to add, separated by a space. No need to use quotation marks when "
        "    referring to strings or char arrays"];
    fprintf('%s\n', guide_command);
    ok = false;
    try
        selection_info = load_settings(setting_name, 'selection');
    catch
        selection_info = set_selection_info('setting_name', setting_name);
    end
    current_args= {'sub_i',  'sub_f', 'ses_i', 'ses_f', 'obj_i', 'obj_f', 'select_subjects', 'label_name', ...
                              'label_value','session_totake', 'subjects_totake',  'task_totake'};
    float_args = {'sub_i',  'sub_f', 'ses_i', 'ses_f', 'obj_i', 'obj_f'};
    bool_args = { 'select_subjects'};
    cell_args = { 'session_totake', 'subjects_totake',  'task_totake' }; 
    while~ok
      try
          disp('')
          disp('current selection parameters set')
          disp(selection_info)
          disp('')
          info2add = input("enter command (or quit): ", 's');
          if isempty(info2add)
              check_selection_info(selection_info);
              ok = true;
          elseif strcmpi(info2add,'quit') || strcmpi(info2add,"'quit'")
              disp(' closing BIDSAlign guided preprocessing')
              return
          elseif strcmpi(info2add,'help') || strcmpi(info2add,"'help'")
              fprintf('%s\n', sethelp)
              fprintf('%s\n', guide_command);
          else
              info2add = regexp(info2add,' ','split','once');
              arg_name = info2add{1};
              arg_value = info2add{2};
              if ~any(strcmp( arg_name, current_args))
                  error(" argument not exists.")
              end
              if any(strcmp( arg_name, float_args))
                  arg_value = str2double(arg_value);
              elseif any(strcmp( arg_name, bool_args))
                  arg_value = string2boolean(arg_value);
              elseif any(strcmp( arg_name, cell_args))
                  arg_value = evalc(arg_value);
              end
              selection_info = set_selection_info(selection_info, arg_name, arg_value);
              check_selection_info(selection_info)
          end
      catch
          fprintf('%s\n', " Wrong input. Please enter a valid setting");
      end
    end
    
    
    
    % --------------------------------------------------------
    % STEP 6: IMPORT SAVE SETTING
    % --------------------------------------------------------
    clc
    fprintf('%s\n', [""
        " Now we will set all the saving options"]);
    sethelp = [""
        " BIDSAlign can save preprocessed data in different formats and extensions."
        " Paths which can be set are:"
        " 1 - save_data : whether to save preprocessed data as .mat or not. Must be a boolean"
        " 2 - save_data_as : the format used to store data. It can be a 2D matrix or 3D tensor. "
        "                              Must be a string or char array with 'matrix' or 'tensor' "
        " 3 - save_set : whether to save preprocessed data as .set or not or not. Must be a boolean"
        " 4 - save_struct : whether to save .mat files as a struct with other patient info or not. Must be a boolean"
        " 5 - save_marker : whether to save marker files or not.  Must be a boolean"
        ""];
    fprintf('%s\n', sethelp)
    guide_command =  [""
        " -- press enter to proceed to the next step"
        " -- type help to see again the meaning of each value"
        " -- to change a parameter, write the name of the parameter to overwrite and the "
        "    new value to add, separated by a space. No need to use quotation marks when "
        "    referring to strings or char arrays"
        ""];
    fprintf('%s\n', guide_command);
    ok = false;
    try
        save_info = load_settings(setting_name, 'save');
    catch
        save_info = set_save_info('setting_name', setting_name);
    end
    current_args= {'save_data',  'save_data_as', 'save_set', 'save_struct', 'save_marker'};
    bool_args = {'save_data', 'save_set', 'save_struct', 'save_marker'};
    while~ok
      try
          disp(' ')
          disp('current saving parameters set:')
          disp(" ")
          disp(save_info)
          disp(' ')
          info2add = input("enter command (or quit): ", 's');
          if isempty(info2add)
              check_save_info(save_info);
              ok = true;
          elseif strcmpi(info2add,'quit') || strcmpi(info2add,"'quit'")
              disp(' closing BIDSAlign guided preprocessing')
              return
          elseif strcmpi(info2add,'help') || strcmpi(info2add,"'help'")
              fprintf('%s\n', sethelp)
          else
              info2add = regexp(info2add,' ','split','once');
              arg_name = info2add{1};
              arg_value = info2add{2};
              if ~any(strcmp( arg_name, current_args))
                  error(" argument not exists.")
              end
              if any(strcmp( arg_name, bool_args))
                  arg_value = string2boolean(arg_value);
              end
              save_info = set_save_info(save_info, arg_name, arg_value);
              check_save_info(save_info)
          end
      catch
          fprintf('%s\n', " Wrong input. Please enter a valid setting");
      end
    end
    
    
    % --------------------------------------------------------
    % STEP 7: SAVE DEFINED STRUCT
    % --------------------------------------------------------
    clc
    fprintf('%s\n', [""
        " Do you want to save all the defined parameters in a custom setting to be reloaded? "
        " You can use this setting to automatically load all the parameters instead of setting them again. "
        ""]);
    ok = false;
    while ~ok
        new_custom_name = input("enter command (or quit): ", 's');
        if isempty(new_custom_name)
            disp('choose to not save all the preprocessing parameters')
            ok = true;
        elseif strcmpi(info2add,'quit') || strcmpi(info2add,"'quit'")
            disp(' closing BIDSAlign guided preprocessing')
            return
        else
            path_info = set_path_info(path_info, 'store_settings', true, 'setting_name', new_custom_name);
            params_info = set_preprocessing_info(params_info, 'store_settings', true, ...
                'setting_name', new_custom_name);
            selection_info = set_selection_info(selection_info, 'store_settings', true, 'setting_name', new_custom_name);
            save_info = set_save_info(save_info, 'store_settings', true, 'setting_name', new_custom_name);
            ok = true;
        end
    end
        
    
    % --------------------------------------------------------
    % STEP 8: LAST SETTINGS
    % --------------------------------------------------------
    clc
    fprintf('%s\n', [ " Last things to set. "
        " "
        " BIDSAlign allows you to preprocess only a single dataset or specific file included in your datasets folder."
        " Do you want to preprocess a single file?"
        " If so, type yes or no. "
        " If you want to preprocess a single file but you have forgotten to give the raw_filepath during the"
        " path setting, you can enter the file name (with the extension, or the full path to the file now"
        ""]);
    ok = false;
    single_file = false;
    while ~ok
        try
            raw_filename = input("enter command (or quit): ", 's');
            if isempty(raw_filename) || strcmpi(raw_filename,'no') || strcmpi(raw_filename,"'n'")
                disp('choose to not preprocess a specific file')
                ok = true;
                single_file = false;
            elseif strcmpi(raw_filename,'quit') || strcmpi(raw_filename,"'quit'")
                disp(' closing BIDSAlign guided preprocessing')
                return
            else 
                if validFile(raw_filename)
                    path_info.raw_filepath= raw_filename;
                else
                    path_file_struct = dir([path_info.dataset_path '**/' raw_filename]);
                    if isempty(path_file_struct)
                        error("cannot find current raw file. Please check that " + ...
                            "dataset path and raw_filename are correct." + ...
                            "Give raw_filename with the extension, for example 'sub-01-raw-eeg.bdf' ")
                    else
                        path_info.raw_filepath = [path_file_struct.folder '/' path_file_struct.name];
                    end
                end
                single_file = true;
                ok = true;
            end
        catch
            disp('wrong input')
        end
    end
    
    
    clc
    dataset_name='';
    if ~single_file
        fprintf('%s\n', [""
            " Do you want to preprocess a single dataset?"
            " If so, type the name of the dataset to preprocess, otherwise type no or press enter. "
            ""]);
        ok = false;
        while ~ok
            try
                dataset_name = input("enter command (or quit): ", 's');
                if isempty(dataset_name) || strcmpi(dataset_name,'no') || strcmpi(dataset_name,"'n'")
                    disp('choose to not preprocess a specific dataset')
                    ok = true;
                    dataset_name = '';
                elseif strcmpi(dataset_name,'quit') || strcmpi(dataset_name,"'quit'")
                    disp(' closing BIDSAlign guided preprocessing')
                    return
                else 
                    if ~isempty(dataset_name)
                        dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name), 1); 
                        if isempty(dataset_index)
                            error('given dataset name to preprocess not included in the loaded dataset info table')
                        end
                        ok = true;
                    else
                        error('empty input')
                    end
                end
            catch
                disp('wrong input')
            end
        end
    end
    
    
    parpool_set = false;
    if ~single_file && isempty(dataset_name)
        ok = false;
        fprintf('%s\n', [""
            " If you have installed the parallel toolbox, you can preprocess eeg data using it. "
            " Do you want to use a parpool option. Type yes or not."
            ""]);
        while ~ok
            try
                parpool_set = input("enter yes or no (or quit): ", 's');
                if isempty(parpool_set)  || strcmpi(parpool_set,'no') || strcmpi(parpool_set,"'n'")
                    parpool_set = false;
                    ok = true;
                elseif strcmpi(parpool_set,'yes') || strcmpi(parpool_set,"'y'")
                    parpool_set = false;
                    ok = true;
                elseif strcmpi(info2add,'quit') || strcmpi(info2add,"'quit'")
                    disp(' closing BIDSAlign guided preprocessing')
                    return
                else
                    error('wrong input')
                end
            catch
                disp('wrong input. type yes or no (or quit).')
            end
        end
    end
    
    verbose = false;
    % --------------------------------------------------------
    % STEP 8: RUN PREPROCESSING
    % --------------------------------------------------------
    clc 
    disp('starting the preprocessing (verbose is set to false, so nothing is printed in the command window)')
    DATA_STRUCT = preprocess_all( dataset_info_filename, ...
                                                        path_info, ...
                                                        params_info, ...
                                                        selection_info, ...
                                                        save_info, ...
                                                        'setting_name', setting_name, ...
                                                        'single_file', single_file, ...
                                                        'single_dataset_name', dataset_name, ...
                                                        'solve_nogui', true, ...
                                                        'use_parpool', parpool_set, ...
                                                        'verbose', verbose);
end