classdef BIDSAlign_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TabGroup                       matlab.ui.container.TabGroup
        IntroTab                       matlab.ui.container.Tab
        WelcometoBIDSAlignLabel        matlab.ui.control.Label
        PathStatus_2                   matlab.ui.control.Lamp
        PathstatustocheckLabel_2       matlab.ui.control.Label
        HelpButton_4                   matlab.ui.control.Button
        Label                          matlab.ui.control.Label
        Image                          matlab.ui.control.Image
        NextButton                     matlab.ui.control.Button
        TableSelection                 matlab.ui.container.Tab
        GenerateTableInfo              matlab.ui.control.Label
        SaveTableInfo                  matlab.ui.control.Label
        DatasetNumberEditField         matlab.ui.control.NumericEditField
        DatasetNumberLabel             matlab.ui.control.Label
        tableInfoLoad                  matlab.ui.control.Label
        TableStatusemptyLabel          matlab.ui.control.Label
        HelpButton                     matlab.ui.control.Button
        TableStatusLamp                matlab.ui.control.Lamp
        EmptyButton                    matlab.ui.control.Button
        CreateButton                   matlab.ui.control.Button
        SaveButton                     matlab.ui.control.Button
        SelectFileButton               matlab.ui.control.Button
        BackButton                     matlab.ui.control.Button
        NextButton_2                   matlab.ui.control.Button
        UITable                        matlab.ui.control.Table
        SettingLoadTab                 matlab.ui.container.Tab
        LoadSettingButton              matlab.ui.control.Button
        RemoveSetting                  matlab.ui.control.Button
        TextArea                       matlab.ui.control.TextArea
        SettingSaveInfo                matlab.ui.control.Label
        SettingRemoveInfo              matlab.ui.control.Label
        SettingListInfo                matlab.ui.control.Label
        Settinginspect                 matlab.ui.container.ButtonGroup
        SaveinfoButton                 matlab.ui.control.RadioButton
        SelectioninfoButton            matlab.ui.control.RadioButton
        PreproinfoButton               matlab.ui.control.RadioButton
        PathinfoButton                 matlab.ui.control.RadioButton
        SaveButton_2                   matlab.ui.control.Button
        EditField                      matlab.ui.control.EditField
        AllSetStatus                   matlab.ui.control.Lamp
        AllsettingstatustocheckLampLabel  matlab.ui.control.Label
        HelpButton_2                   matlab.ui.control.Button
        RemoveSettingDropDown          matlab.ui.control.DropDown
        SettingListDropDown            matlab.ui.control.DropDown
        BackButton_8                   matlab.ui.control.Button
        NextButton_8                   matlab.ui.control.Button
        PathsTab                       matlab.ui.container.Tab
        PathInfoGeneric                matlab.ui.control.Label
        CheckEEGLabButton              matlab.ui.control.Button
        SetEEGLabPathButton            matlab.ui.control.Button
        SetOutputCsvPathButton         matlab.ui.control.Button
        SetOutputSetPathButton         matlab.ui.control.Button
        SetOutputMatPathButton         matlab.ui.control.Button
        SetOutputPathButton            matlab.ui.control.Button
        SetDatasetPathButton           matlab.ui.control.Button
        DiagnosticFolderNameEditField  matlab.ui.control.EditField
        DiagnosticFolderNameEditFieldLabel  matlab.ui.control.Label
        EEGlabpathEditField            matlab.ui.control.EditField
        EEGlabpathEditFieldLabel       matlab.ui.control.Label
        OutputcsvpathEditField         matlab.ui.control.EditField
        OutputcsvpathEditFieldLabel    matlab.ui.control.Label
        OutputsetpathEditField         matlab.ui.control.EditField
        OutputsetpathEditFieldLabel    matlab.ui.control.Label
        OutputmatpathEditField         matlab.ui.control.EditField
        OutputmatpathEditFieldLabel    matlab.ui.control.Label
        OutputPathEditField            matlab.ui.control.EditField
        OutputPathEditFieldLabel       matlab.ui.control.Label
        DatasetPathEditField           matlab.ui.control.EditField
        DatasetPathEditFieldLabel      matlab.ui.control.Label
        PathStatus                     matlab.ui.control.Lamp
        PathstatustocheckLabel         matlab.ui.control.Label
        HelpButton_3                   matlab.ui.control.Button
        NextButton_3                   matlab.ui.control.Button
        BackButton_2                   matlab.ui.control.Button
        PreprocessingTab               matlab.ui.container.Tab
        uVLabel                        matlab.ui.control.Label
        HzLabel_3                      matlab.ui.control.Label
        HzLabel_2                      matlab.ui.control.Label
        HzLabel                        matlab.ui.control.Label
        sLabel_2                       matlab.ui.control.Label
        sLabel                         matlab.ui.control.Label
        AlgorithmSwitch                matlab.ui.control.Switch
        AlgorithmSwitchLabel           matlab.ui.control.Label
        MaraThresholdEditField         matlab.ui.control.NumericEditField
        MaraThresholdEditFieldLabel    matlab.ui.control.Label
        ChannelInterpolationLabel      matlab.ui.control.Label
        RereferencingLabel             matlab.ui.control.Label
        ASRLabel                       matlab.ui.control.Label
        ICADecompositionLabel          matlab.ui.control.Label
        ICRejectionLabel               matlab.ui.control.Label
        FilteringLabel                 matlab.ui.control.Label
        ResamplingLabel                matlab.ui.control.Label
        SegmentRemovalLabel            matlab.ui.control.Label
        OtherEditField                 matlab.ui.control.NumericEditField
        OtherEditFieldLabel            matlab.ui.control.Label
        LineNoiseEditField             matlab.ui.control.NumericEditField
        LineNoiseEditFieldLabel        matlab.ui.control.Label
        HeartEditField                 matlab.ui.control.NumericEditField
        HeartEditFieldLabel            matlab.ui.control.Label
        ChannelNoiseEditField          matlab.ui.control.NumericEditField
        ChannelNoiseLabel              matlab.ui.control.Label
        EyeEditField                   matlab.ui.control.NumericEditField
        EyeEditFieldLabel              matlab.ui.control.Label
        MuscleEditField                matlab.ui.control.NumericEditField
        MuscleLabel                    matlab.ui.control.Label
        BrainEditField                 matlab.ui.control.NumericEditField
        BrainEditFieldLabel            matlab.ui.control.Label
        SamplingRateEditField          matlab.ui.control.NumericEditField
        SamplingRateLabel              matlab.ui.control.Label
        FinalsegmentEditField          matlab.ui.control.NumericEditField
        FinalsegmentEditFieldLabel     matlab.ui.control.Label
        InitialsegmentEditField        matlab.ui.control.NumericEditField
        InitialsegmentEditFieldLabel   matlab.ui.control.Label
        ICNumberEditField              matlab.ui.control.NumericEditField
        ICNumberEditFieldLabel         matlab.ui.control.Label
        NonLinearityEditField          matlab.ui.control.EditField
        NonLinearityLabel              matlab.ui.control.Label
        TypeEditField                  matlab.ui.control.EditField
        TypeEditFieldLabel             matlab.ui.control.Label
        BurstRejectionSwitch           matlab.ui.control.Switch
        BurstRejectionLabel            matlab.ui.control.Label
        DoubleASRThresholdEditField    matlab.ui.control.NumericEditField
        DoubleASRThresholdLabel        matlab.ui.control.Label
        BurstCriterionEditField        matlab.ui.control.NumericEditField
        BurstCriterionLabel            matlab.ui.control.Label
        WindowCriterionEditField       matlab.ui.control.NumericEditField
        WindowCriterionLabel           matlab.ui.control.Label
        LineNoiseCriterionEditField    matlab.ui.control.NumericEditField
        LineNoiseCriterionLabel        matlab.ui.control.Label
        ChannelCriterionEditField      matlab.ui.control.NumericEditField
        ChannelCriterionLabel          matlab.ui.control.Label
        FlatlineCriterionEditField     matlab.ui.control.NumericEditField
        FlatlineCriterionLabel         matlab.ui.control.Label
        PreprocessingStatus            matlab.ui.control.Lamp
        PreprocessingstatustocheckLabel  matlab.ui.control.Label
        PreprocessingGeneralHelp       matlab.ui.control.Button
        InterpolationMethodEditField   matlab.ui.control.EditField
        InterpolationMethodEditFieldLabel  matlab.ui.control.Label
        StandardReferenceEditField     matlab.ui.control.EditField
        StandardReferenceEditFieldLabel  matlab.ui.control.Label
        HighFreqEditField              matlab.ui.control.NumericEditField
        HighFreqEditFieldLabel         matlab.ui.control.Label
        LowFreqEditField               matlab.ui.control.NumericEditField
        LowFreqEditFieldLabel          matlab.ui.control.Label
        NextButton_4                   matlab.ui.control.Button
        BackButton_3                   matlab.ui.control.Button
        SelectionTab                   matlab.ui.container.Tab
        SelectionStatus                matlab.ui.control.Lamp
        SelectionstatustocheckLabel    matlab.ui.control.Label
        SelectionGeneralHelp           matlab.ui.control.Button
        NameBasedLabel                 matlab.ui.control.Label
        LabelBased                     matlab.ui.control.Label
        SliceBasedLabel                matlab.ui.control.Label
        ObjectsToTakeTextArea          matlab.ui.control.TextArea
        ObjectsToTakeTextAreaLabel     matlab.ui.control.Label
        SessionsToTakeTextArea         matlab.ui.control.TextArea
        SessionsToTakeTextAreaLabel    matlab.ui.control.Label
        SubjectstoTakeTextArea         matlab.ui.control.TextArea
        SubjectstoTakeTextAreaLabel    matlab.ui.control.Label
        LabelValueEditField            matlab.ui.control.EditField
        LabelValueEditFieldLabel       matlab.ui.control.Label
        LabelNameEditField             matlab.ui.control.EditField
        LabelNameEditFieldLabel        matlab.ui.control.Label
        PerformSelectionSwitch         matlab.ui.control.Switch
        PerformSelectionSwitchLabel    matlab.ui.control.Label
        ObjectFinalEditField           matlab.ui.control.NumericEditField
        ObjectFinalEditFieldLabel      matlab.ui.control.Label
        ObjectInitialEditField         matlab.ui.control.NumericEditField
        ObjectInitialEditFieldLabel    matlab.ui.control.Label
        SessionFinalEditField          matlab.ui.control.NumericEditField
        SessionFinalEditFieldLabel     matlab.ui.control.Label
        SessionInitialEditField        matlab.ui.control.NumericEditField
        SessionInitialEditFieldLabel   matlab.ui.control.Label
        SubjectFinalEditField          matlab.ui.control.NumericEditField
        SubjectFinalEditFieldLabel     matlab.ui.control.Label
        SubjectInitialEditField        matlab.ui.control.NumericEditField
        SubjectInitialEditFieldLabel   matlab.ui.control.Label
        NextButton_5                   matlab.ui.control.Button
        BackButton_4                   matlab.ui.control.Button
        RunPreprocessingTab            matlab.ui.container.Tab
        SingleFileDropDown             matlab.ui.control.DropDown
        SingleFileDropDownLabel        matlab.ui.control.Label
        RunGeneralHelp                 matlab.ui.control.Button
        RunFinalChecks                 matlab.ui.control.Lamp
        FinalcheckscontroltableLabel   matlab.ui.control.Label
        ModalityLabel                  matlab.ui.control.Label
        ASRSwitch                      matlab.ui.control.Switch
        ASRSwitchLabel                 matlab.ui.control.Label
        ICADecompositionSwitch         matlab.ui.control.Switch
        ICADecompositionSwitchLabel    matlab.ui.control.Label
        RereferencingSwitch            matlab.ui.control.Switch
        RereferencingSwitchLabel       matlab.ui.control.Label
        FilteringSwitch                matlab.ui.control.Switch
        FilteringSwitchLabel           matlab.ui.control.Label
        ResamplingSwitch               matlab.ui.control.Switch
        ResamplingSwitchLabel          matlab.ui.control.Label
        BaselineRemovalSwitch          matlab.ui.control.Switch
        BaselineRemovalSwitchLabel     matlab.ui.control.Label
        ICRejectionSwitch              matlab.ui.control.Switch
        ICRejectionSwitchLabel         matlab.ui.control.Label
        SegmentRemovalSwitch           matlab.ui.control.Switch
        SegmentRemovalSwitchLabel      matlab.ui.control.Label
        ParallelComputingSwitch        matlab.ui.control.Switch
        ParallelComputingSwitchLabel   matlab.ui.control.Label
        VerboseSwitch                  matlab.ui.control.Switch
        VerboseSwitchLabel             matlab.ui.control.Label
        DatasettoPreprocessDropDown    matlab.ui.control.DropDown
        DatasettoPreprocessDropDownLabel  matlab.ui.control.Label
        ChannelRemovalSwitch           matlab.ui.control.Switch
        ChannelRemovalLabel            matlab.ui.control.Label
        SavesetfilesSwitch             matlab.ui.control.Switch
        SavesetfilesSwitchLabel        matlab.ui.control.Label
        EEGformatSwitch                matlab.ui.control.Switch
        EEGformatSwitchLabel           matlab.ui.control.Label
        SaveMarkerfilesSwitch          matlab.ui.control.Switch
        SaveMarkerfilesSwitchLabel     matlab.ui.control.Label
        SavestructSwitch               matlab.ui.control.Switch
        SavestructSwitchLabel          matlab.ui.control.Label
        SavematfilesSwitch             matlab.ui.control.Switch
        SavematfilesSwitchLabel        matlab.ui.control.Label
        RunButton                      matlab.ui.control.Button
        StepstoPerformLabel            matlab.ui.control.Label
        SaveoptionsLabel               matlab.ui.control.Label
        BackButton_7                   matlab.ui.control.Button
    end

    
    properties (Access = public)
        
        % table variables
        dataset_info_filename = '';
        dataset_info = create_empty_table(1);
        
        % list of setting names
        all_settings = get_stored_settings(true);
        all_settings_nodefault = get_stored_settings();
        
        % initialize all structs
        path_info = set_path_info('silence_warn', true);
        preprocess_info = set_preprocessing_info();
        selection_info = set_selection_info();
        save_info = set_save_info();
        
        % modality selectors (all datasets, single dataset, single file)
        single_file = false;
        single_dataset_name = '';
        single_file_name = '';
        
        % extra things for 
        solve_nogui = false;
        use_parpool = false;
        verbose = true;
        
        % output of last processed EEG
        EEG_data = [];
        
    end
    
    methods (Access = private)
        
        function [] = SilenceSingleFile(app, reset_items)
            
            if nargin<2
                reset_items=true;
            end
            
            app.single_file = false;
            app.single_file_name = '';
            app.SingleFileDropDown.Value = {'All files'};
            app.SingleFileDropDown.Enable = 'off';
            app.SingleFileDropDownLabel.Enable = 'off';
            
            app.DatasettoPreprocessDropDown.Value = 'All';
            if reset_items
                app.DatasettoPreprocessDropDown.Items = {'All'};
                app.single_dataset_name = '';
            end
            
        end
        
        function [] = checkTableStatus(app)
            if isempty(app.UITable.Data)
                app.TableStatusLamp.Color = [1.0, 0.0, 0.0];
                app.TableStatusemptyLabel.Text = 'Table Status: empty';
                SilenceSingleFile(app);
            else
                try
                    check_loaded_table(app.UITable.Data);
                    app.dataset_info = app.UITable.Data;
                    app.TableStatusLamp.Color = [0.0, 1.0, 0.0];
                    app.TableStatusemptyLabel.Text = 'Table Status: OK';
                    % if dataset_path is empty single file was never
                    % enabled, but to be sure we still silence the dropdown
                    % list 
                    if isempty(app.path_info.datasets_path)
                        SilenceSingleFile(app,false)
                    end
                    % check if something should be done for the single
                    % modality modes (ideally if the table is updated,
                    % changes must reflect values in single dataset or file
                    % lists (only if necessary)
                    manageModality(app)
                catch
                    app.TableStatusLamp.Color = [1.0, 0.0, 0.0];
                    app.TableStatusemptyLabel.Text = 'Table Status: wrong format';
                    SilenceSingleFile(app);
                end
            end
            checkFinal(app);
        end
        
        function [] = checkPreproStatus(app, struct2check)
            switch struct2check
                case 'path'
                    try
                        check_path_info(app.path_info, true)
                        CheckEEGLabLaunch(app, 0)
                        if ~isempty(app.path_info.datasets_path) && ...
                                isequal(app.TableStatusLamp.Color, [0.0, 1.0, 0.0]) && ...
                                ~strcmp(app.DatasettoPreprocessDropDown.Value, 'All')
                            app.SingleFileDropDown.Enable = 'On';
                            if strcmp(app.SingleFileDropDown.Value,'All files')
                                regenerate_single_file_list(app, app.single_dataset_name)
                            end
                        end
                        if isequal(app.CheckEEGLabButton.FontColor, [0 1 0]) && ...
                                isequal(app.CheckEEGLabButton.Enable, 'off')
                            app.PathstatustocheckLabel.Text = 'Path status: ok';
                            app.PathStatus.Color = [0 1 0];
                        else
                            app.PathstatustocheckLabel.Text = 'Path status: missing EEGlab';
                            app.PathStatus.Color = [0.93 0.69 0.1];
                        end
                    catch
                        app.PathstatustocheckLabel.Text = 'Path status: to check';
                        app.PathStatus.Color = [1 0 0];
                    end
                case 'preprocessing'
                    try
                        check_preprocessing_info(app.preprocess_info)
                        app.PreprocessingstatustocheckLabel.Text = 'Preprocessing status: ok';
                        app.PreprocessingStatus.Color = [0 1 0];
                    catch
                        app.PreprocessingstatustocheckLabel.Text = 'Preprocessing status: to check';
                        app.PreprocessingStatus.Color = [1 0 0];
                    end
                case 'selection'
                    try
                        check_selection_info(app.selection_info, true)
                        app.SelectionstatustocheckLabel.Text = 'Selection status: ok';
                        app.SelectionStatus.Color = [0 1 0];
                    catch
                        app.SelectionstatustocheckLabel.Text = 'Selection status: to check';
                        app.SelectionStatus.Color = [1 0 0];
                    end
            end
            if isequal(app.PathStatus.Color,[0 1 0]) && ...
                    isequal(app.PreprocessingStatus.Color,[0 1 0]) && ...
                    isequal(app.PathStatus.Color,[0 1 0]) && ...
                    isequal(app.SelectionStatus.Color,[0 1 0])
                app.AllSetStatus.Color = [0 1 0];
                app.AllsettingstatustocheckLampLabel.Text = 'All setting status: ok';
            elseif isequal(app.PathStatus.Color,[0.93 0.69 0.1]) && ...
                    ~isequal(app.PreprocessingStatus.Color,[0 1 0])
                app.AllSetStatus.Color = [1 0 0];
                app.AllsettingstatustocheckLampLabel.Text = 'All setting status: missing EEGlab path';
            else
                app.AllSetStatus.Color = [1 0 0];
                app.AllsettingstatustocheckLampLabel.Text = 'All setting status: to check';
            end
            checkFinal(app);
        end
        
        function [] = updateAllValues(app)
            
            % Paths values
            app.DatasetPathEditField.Value = app.path_info.datasets_path;
            app.OutputPathEditField.Value = app.path_info.output_path;
            app.OutputmatpathEditField.Value = app.path_info.output_mat_path;
            app.OutputcsvpathEditField.Value = app.path_info.output_csv_path;
            app.OutputsetpathEditField.Value = app.path_info.output_set_path;
            app.EEGlabpathEditField.Value = app.path_info.eeglab_path;
            app.DiagnosticFolderNameEditField.Value = app.path_info.diagnostic_folder_name;
            
            % preprocess values
            app.InitialsegmentEditField.Value = app.preprocess_info.dt_i;
            app.FinalsegmentEditField.Value = app.preprocess_info.dt_f;
            app.SamplingRateEditField.Value = app.preprocess_info.sampling_rate;
            app.LowFreqEditField.Value = app.preprocess_info.low_freq;
            app.HighFreqEditField.Value = app.preprocess_info.high_freq;
            app.StandardReferenceEditField.Value = app.preprocess_info.standard_ref;
            app.TypeEditField.Value = app.preprocess_info.ica_type;
            app.NonLinearityEditField.Value = app.preprocess_info.non_linearity;
            app.ICNumberEditField.Value = app.preprocess_info.n_ica;
            if strcmp(app.preprocess_info.ic_rej_type, 'mara')
                app.AlgorithmSwitch.Value = 'MARA';
            else
                app.AlgorithmSwitch.Value = 'ICLabel';
            end
            app.MaraThresholdEditField.Value = app.preprocess_info.mara_threshold;
            app.DoubleASRThresholdEditField.Value = app.preprocess_info.th_reject;
            app.FlatlineCriterionEditField.Value = app.preprocess_info.flatlineC;
            app.ChannelCriterionEditField.Value = app.preprocess_info.channelC;
            app.LineNoiseCriterionEditField.Value = app.preprocess_info.lineC;
            app.WindowCriterionEditField.Value = app.preprocess_info.windowC;
            app.BurstCriterionEditField.Value = app.preprocess_info.burstC;
            app.BurstRejectionSwitch.Value = regexprep(lower(app.preprocess_info.burstR),'(\<[a-z])','${upper($1)}');
            app.InterpolationMethodEditField.Value = app.preprocess_info.interpol_method;
            app.BrainEditField.Value = app.preprocess_info.iclabel_thresholds(1,2);
            app.MuscleEditField.Value = app.preprocess_info.iclabel_thresholds(2,1);
            app.EyeEditField.Value = app.preprocess_info.iclabel_thresholds(3,1);
            app.HeartEditField.Value = app.preprocess_info.iclabel_thresholds(4,1);
            app.LineNoiseEditField.Value = app.preprocess_info.iclabel_thresholds(5,1);
            app.ChannelNoiseEditField.Value = app.preprocess_info.iclabel_thresholds(6,1);
            app.OtherEditField.Value = app.preprocess_info.iclabel_thresholds(7,1);
            
            % save values
            app.SavematfilesSwitch.Value = Bool2Value(app, app.save_info.save_data);
            app.SavestructSwitch.Value = Bool2Value(app, app.save_info.save_struct);
            app.SavesetfilesSwitch.Value = Bool2Value(app, app.save_info.save_set);
            app.SaveMarkerfilesSwitch.Value = Bool2Value(app, app.save_info.save_marker);
            app.EEGformatSwitch.Value =app.save_info.save_data_as;
            
            % selection values
            app.SubjectInitialEditField.Value = ValueOrZero(app, app.selection_info.sub_i);
            app.SubjectFinalEditField.Value = ValueOrZero(app, app.selection_info.sub_f);
            app.SessionInitialEditField.Value  = ValueOrZero(app, app.selection_info.ses_i);
            app.SessionFinalEditField.Value = ValueOrZero(app, app.selection_info.ses_f);
            app.ObjectInitialEditField.Value = ValueOrZero(app, app.selection_info.obj_i);
            app.ObjectFinalEditField.Value = ValueOrZero(app, app.selection_info.obj_f);
            app.PerformSelectionSwitch.Value = Bool2Value(app, app.selection_info.select_subjects, true);
            app.LabelNameEditField.Value = app.selection_info.label_name;
            app.LabelValueEditField.Value = app.selection_info.label_value;
            app.SubjectstoTakeTextArea.Value = emptycell4text( app, app.selection_info.subjects_totake);
            app.SessionsToTakeTextArea.Value = emptycell4text( app, app.selection_info.session_totake);
            app.ObjectsToTakeTextArea.Value = emptycell4text( app, app.selection_info.task_totake);
                
            % steps to preform
            app.ChannelRemovalSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.rmchannels, true);
            app.SegmentRemovalSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.rmsegments, true);
            app.BaselineRemovalSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.rmbaseline, true);
            app.ResamplingSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.resampling, true);
            app.FilteringSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.filtering, true);
            app.RereferencingSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.rereference, true);
            app.ICADecompositionSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.ICA, true);
            app.ICRejectionSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.ICrejection, true);
            app.ASRSwitch.Value = Bool2Value(app, app.preprocess_info.prep_steps.ASR, true);
            
            if app.selection_info.select_subjects
                enable4struct(app,'selection')
            else
                disable4struct(app,'selection')
            end
        end
        
        
        function thresh2add = GetICLabelThresh(app, IClab, newthresh)
            switch IClab
                case 'iclabel_threshold_brain'
                    thresh2add = [0 newthresh;
                            app.MuscleEditField.Value 1;
                            app.EyeEditField.Value 1;
                            app.HeartEditField.Value 1;
                            app.LineNoiseEditField.Value 1;
                            app.ChannelNoiseEditField.Value 1;
                            app.OtherEditField.Value 1
                            ];
                case 'iclabel_threshold_muscle'
                    thresh2add = [0 app.BrainEditField.Value;
                            newthresh 1;
                            app.EyeEditField.Value 1;
                            app.HeartEditField.Value 1;
                            app.LineNoiseEditField.Value 1;
                            app.ChannelNoiseEditField.Value 1;
                            app.OtherEditField.Value 1
                            ];
                case 'iclabel_threshold_eye'
                    thresh2add = [0 app.BrainEditField.Value;
                            app.MuscleEditField.Value 1;
                            newthresh 1;
                            app.HeartEditField.Value 1;
                            app.LineNoiseEditField.Value 1;
                            app.ChannelNoiseEditField.Value 1;
                            app.OtherEditField.Value 1
                            ];
                case 'iclabel_threshold_heart'
                    thresh2add = [0 app.BrainEditField.Value;
                            app.MuscleEditField.Value 1;
                            app.EyeEditField.Value 1;
                            newthresh 1;
                            app.LineNoiseEditField.Value 1;
                            app.ChannelNoiseEditField.Value 1;
                            app.OtherEditField.Value 1
                            ];
                case 'iclabel_threshold_line'
                    thresh2add = [0 app.BrainEditField.Value;
                            app.MuscleEditField.Value 1;
                            app.EyeEditField.Value 1;
                            app.HeartEditField.Value 1;
                            newthresh 1;
                            app.ChannelNoiseEditField.Value 1;
                            app.OtherEditField.Value 1
                            ];
                case 'iclabel_threshold_chan'
                    thresh2add = [0 app.BrainEditField.Value;
                            app.MuscleEditField.Value 1;
                            app.EyeEditField.Value 1;
                            app.HeartEditField.Value 1;
                            app.LineNoiseEditField.Value 1;
                            newthresh 1;
                            app.OtherEditField.Value 1
                            ];
                case 'iclabel_threshold_other'
                    thresh2add = [0 app.BrainEditField.Value;
                            app.MuscleEditField.Value 1;
                            app.EyeEditField.Value 1;
                            app.HeartEditField 1;
                            app.LineNoiseEditField.Value 1;
                            app.ChannelNoiseEditField.Value 1;
                            newthresh 1
                            ];
            end            
        end
        
        
        
        function ComponentValue = Bool2Value( ~, value, onoff)
            if nargin <3
                onoff = false;
            end
            if value
                if onoff
                    ComponentValue = 'On';
                else
                    ComponentValue = 'Yes';
                end
            else
                if onoff
                    ComponentValue = 'Off';
                else
                    ComponentValue = 'No';
                end
            end
            
            
        end
        
        function [] = checkFinal(app)
            
            if isequal(app.AllSetStatus.Color, [0 1 0]) && ...
                    isequal(app.TableStatusLamp.Color, [0 1 0])
                app.RunButton.Enable = 'on';
                app.RunFinalChecks.Color = [0 1 0];
                app.FinalcheckscontroltableLabel.Text = 'Final checks: ready to start';
            else
                app.RunButton.Enable = 'off';
                if ~isequal(app.TableStatusLamp.Color, [0 1 0])
                    app.RunFinalChecks.Color = [1 0 0];
                    app.FinalcheckscontroltableLabel.Text = 'Final checks: control table';
                elseif ~isequal(app.PathStatus.Color, [0 1 0])
                    app.RunFinalChecks.Color = [1 0 0];
                    app.FinalcheckscontroltableLabel.Text = 'Final checks: control paths';
                elseif ~isequal(app.PreprocessingStatus.Color, [0 1 0])
                    app.RunFinalChecks.Color = [1 0 0];
                    app.FinalcheckscontroltableLabel.Text = 'Final checks: control preprocessing';
                else
                    app.RunFinalChecks.Color = [1 0 0];
                    app.FinalcheckscontroltableLabel.Text = 'Final checks: control selection';
                end
                
            end
            
        end
        
        function regenerate_single_file_list(app, dataset_name, reset_value)
            if nargin< 3
                reset_value = true;
            end
            if reset_value
                app.SingleFileDropDown.Value = 'All files';
                app.single_file_name = '';
                app.single_file = false;
            end
            rows=  strcmp( dataset_name , app.dataset_info.dataset_name);
            code_and_format = app.dataset_info{rows,["dataset_code", "eeg_file_extension"]};
            filelist = get_dataset_file_list(app.path_info.datasets_path, ...
                code_and_format{1}, code_and_format{2});
            app.SingleFileDropDown.Items = cat(1, {'All files'}, {filelist(:).name}');
            
        end
        
        function manageModality(app)
            
            % if everything is ok but currently the dataset liss has only the All
            % item, we need to update the dropdown item list and start
            % everything
            if isequal(app.DatasettoPreprocessDropDown.Items, {'All'})
                app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                    app.dataset_info.dataset_name(:) );
                app.DatasettoPreprocessDropDown.Value = 'All';
                SilenceSingleFile(app, false)
                return
            end
            
            % if there's already something, first let's check if the current 
            % selected dataset is still available in the list of names from
            % the table
            
            % if is still available
            dataset_name = app.DatasettoPreprocessDropDown.Value;
            if any( strcmp(dataset_name , cat(1, {'All'}, app.dataset_info.dataset_name(:))) )
                    
                % 1 - update the list without silencing everything nor
                %     updating the dropdown value 
                app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                    app.dataset_info.dataset_name(:) );
                
                % if the current value is All, it means that single dataset
                % is still disabled, so we can exit from this function
                if strcmp(dataset_name, 'All')
                    return
                end
                
                % 2- check if the dataset_code or extensions are the same,
                %    otherwise we need to update the single file list and
                %    reset its value
                
                % if the current selected value is 'All files', we can
                % simply regenerate the list
                if isempty(app.single_file_name)
                    regenerate_single_file_list(app, dataset_name)
                else
                    rows=  strcmp( dataset_name , app.dataset_info.dataset_name);
                    code_and_format = app.dataset_info{rows,["dataset_code", "eeg_file_extension"]};
                    sample_file = app.single_file_name;
                    current_format =  sample_file(find(sample_file =='.',1, 'last'):end);
                    current_code = strsplit(sample_file , app.path_info.datasets_path);
                    current_code = current_code{2};
                    current_code = current_code(1:find(current_code == filesep, 1, 'first')-1);
                    
                    % if something has changed, then reset single file list
                    if ~isequal(current_code, code_and_format{1}) || ...
                           ~isequal(current_format, code_and_format{2}) 
                       filelist = get_dataset_file_list(app.path_info.datasets_path, ...
                           code_and_format{1}, code_and_format{2});
                       app.SingleFileDropDown.Value = 'All files';
                       app.single_file_name = '';
                       app.single_file = false;
                       app.SingleFileDropDown.Items = cat(1, {'All files'}, {filelist(:).name}');    
                    end
                end
            % if the dataset name is not available anymore
            else
                % try to check if there's a dataset name with the same code
                % as the old one. This can be done only if a single_file
                % has been selected, otherwise it is best to simply reset 
                % everything
                if isempty(app.single_file_name)
                    app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                        app.dataset_info.dataset_name(:) );
                    app.DatasettoPreprocessDropDown.Value = 'All';
                    SilenceSingleFile(app, false)
                else
                    sample_file = app.single_file_name;
                    current_format =  sample_file(find(sample_file =='.',1, 'last'):end);
                    current_code = strsplit(sample_file , app.path_info.datasets_path);
                    current_code = current_code{2};
                    current_code = current_code(1:find(current_code == filesep, 1, 'first')-1);

                    % if there's something with the same code
                    if any(strcmp(current_code, app.dataset_info.dataset_code))

                        % 1 - update the list
                        app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                            app.dataset_info.dataset_name(:) );
                        
                        % 2 - update the value
                        rows=  strcmp( current_code , app.dataset_info.dataset_code);
                        name_and_format = app.dataset_info{rows,["dataset_name", "eeg_file_extension"]};
                        app.DatasettoPreprocessDropDown.Value = name_and_format{1};
                        
                        % 3 - update list if file format has changed
                        if ~strcmp(name_and_format{2}, current_format)
                            regenerate_single_file_list(app, name_and_format{1})
                        end
                        
                        % if no dataset_code with the old one is found, reset
                    else
                        app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                            app.dataset_info.dataset_name(:) );
                        app.DatasettoPreprocessDropDown.Value = 'All';
                        SilenceSingleFile(app, false)
                    end                    
                end
            end    
        end
        
        
        
        function value2add = ValueOrZero(~, value, reverse)
            
            if nargin<3
                reverse = false;
            end

            if reverse
                if isequal(value, 0)
                    value2add = [];
                else
                    value2add = round(value);
                end     
            else
                if isempty(value)
                    value2add = 0;
                else
                    value2add = round(value);
                end  
            end
        end
        
        
        function enable4struct(app, struct_type)
            
            if strcmp(struct_type, 'mara')
                app.MaraThresholdEditField.Enable = 'on';
            
            elseif strcmp(struct_type, 'iclabel')
                app.BrainEditField.Enable = 'on';
                app.MuscleEditField.Enable = 'on';
                app.EyeEditField.Enable = 'on';
                app.HeartEditField.Enable = 'on';
                app.LineNoiseEditField.Enable = 'on';
                app.ChannelNoiseEditField.Enable = 'on';
                app.OtherEditField.Enable = 'on';
                
            elseif strcmp(struct_type, 'selection')
                app.SubjectInitialEditField.Enable = 'on';
                app.SubjectFinalEditField.Enable = 'on';
                app.SessionInitialEditField.Enable = 'on';
                app.SessionFinalEditField.Enable = 'on';
                app.ObjectInitialEditField.Enable = 'on';
                app.ObjectFinalEditField.Enable = 'on';
                app.LabelNameEditField.Enable = 'on';
                app.LabelValueEditField.Enable = 'on';
                app.SubjectstoTakeTextArea.Enable = 'on';
                app.SessionsToTakeTextArea.Enable = 'on';
                app.ObjectsToTakeTextArea.Enable = 'on';
            end
            
        end
        
        function disable4struct(app, struct_type)
            
            if strcmp(struct_type, 'mara')
                app.MaraThresholdEditField.Enable = 'off';
            
            elseif strcmp(struct_type, 'iclabel')
                app.BrainEditField.Enable = 'off';
                app.MuscleEditField.Enable = 'off';
                app.EyeEditField.Enable = 'off';
                app.HeartEditField.Enable = 'off';
                app.LineNoiseEditField.Enable = 'off';
                app.ChannelNoiseEditField.Enable = 'off';
                app.OtherEditField.Enable = 'off';
                
            elseif strcmp(struct_type, 'selection')
                app.SubjectInitialEditField.Enable = 'off';
                app.SubjectFinalEditField.Enable = 'off';
                app.SessionInitialEditField.Enable = 'off';
                app.SessionFinalEditField.Enable = 'off';
                app.ObjectInitialEditField.Enable = 'off';
                app.ObjectFinalEditField.Enable = 'off';
                app.LabelNameEditField.Enable = 'off';
                app.LabelValueEditField.Enable = 'off';
                app.SubjectstoTakeTextArea.Enable = 'off';
                app.SessionsToTakeTextArea.Enable = 'off';
                app.ObjectsToTakeTextArea.Enable = 'off';
            end
            
        end
        
        function cell2take = emptycell4text(~, cellinfo, reverse)
            
            if nargin<3 
                reverse = false;
            end
            if reverse
                if isequal(cellinfo, {''}) || isequal(cellinfo, {})
                    cell2take = {{}};
                else 
                    cell2take = cellinfo;
                end
            else
                if isequal(cellinfo, {{}}) || isequal(cellinfo, {})
                    cell2take = {''};
                else 
                    cell2take = cellinfo;
                end
            end
            
        end
        
        function check_empty_selection(app)

            if app.selection_info.select_subjects
                if isempty(app.selection_info.sub_i) && ...
                        isempty(app.selection_info.sub_f) && ...
                        isempty(app.selection_info.ses_i) && ...
                        isempty(app.selection_info.ses_f) && ...
                        isempty(app.selection_info.obj_i) && ...
                        isempty(app.selection_info.obj_f) && ...
                        isempty(app.selection_info.label_name) && ...
                        isempty(app.selection_info.label_value) && ...
                        isequal(app.selection_info.subjects_totake, {{}}) && ...
                        isequal(app.selection_info.session_totake, {{}}) && ...
                        isequal(app.selection_info.task_totake, {{}})

                    app.selection_info.select_subjects = false;
    
                end
            end
            
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % SET HELP BUTTON TAG
            app.HelpButton_4.Tag = 'HelpIntro';
            app.HelpButton.Tag = 'HelpTable';
            app.HelpButton_2.Tag = 'HelpSetting';
            app.HelpButton_3.Tag = 'HelpPath';
            app.PreprocessingGeneralHelp.Tag = 'HelpPreprocessing';
            app.SelectionGeneralHelp.Tag = 'HelpSelection';
            app.RunGeneralHelp.Tag = 'HelpRun';
            
            % SET PATH BUTTON TAG
            app.SetDatasetPathButton.Tag = 'datasets_path';
            app.SetOutputPathButton.Tag = 'output_path';
            app.SetOutputCsvPathButton.Tag = 'output_csv_path';
            app.SetOutputMatPathButton.Tag = 'output_mat_path';
            app.SetOutputSetPathButton.Tag = 'output_set_path';
            app.SetEEGLabPathButton.Tag = 'eeglab_path';
            % SET PATH EDITFIELD TAG
            app.DatasetPathEditField.Tag = 'datasets_path';
            app.OutputPathEditField.Tag = 'output_path';
            app.OutputmatpathEditField.Tag = 'output_mat_path';
            app.OutputcsvpathEditField.Tag = 'output_csv_path';
            app.OutputsetpathEditField.Tag = 'output_set_path';
            app.EEGlabpathEditField.Tag = 'eeglab_path';
            app.DiagnosticFolderNameEditField.Tag = 'diagnostic_folder';
            
            %SET PREPROCESSING EDITFIELD TAG
            app.InitialsegmentEditField.Tag = 'dt_i';
            app.FinalsegmentEditField.Tag = 'dt_f';
            app.SamplingRateEditField.Tag = 'sampling_rate';
            app.LowFreqEditField.Tag = 'low_freq';
            app.HighFreqEditField.Tag = 'high_freq';
            app.StandardReferenceEditField.Tag = 'standard_ref';
            app.TypeEditField.Tag = 'ica_type';
            app.NonLinearityEditField.Tag = 'non_linearity';
            app.ICNumberEditField.Tag = 'n_ica';
            app.AlgorithmSwitch.Tag = 'ic_rej_type';
            app.MaraThresholdEditField.Tag = 'mara_threshold';
            app.DoubleASRThresholdEditField.Tag = 'th_reject';
            app.FlatlineCriterionEditField.Tag = 'flatlineC';
            app.ChannelCriterionEditField.Tag = 'channelC';
            app.LineNoiseCriterionEditField.Tag = 'lineC';
            app.WindowCriterionEditField.Tag = 'windowC';
            app.BurstCriterionEditField.Tag = 'burstC';
            app.BurstRejectionSwitch.Tag = 'burstR';
            app.InterpolationMethodEditField.Tag = 'interpol_method';
            app.BrainEditField.Tag = 'iclabel_threshold_brain';
            app.MuscleEditField.Tag = 'iclabel_threshold_muscle';
            app.EyeEditField.Tag = 'iclabel_threshold_eye';
            app.HeartEditField.Tag = 'iclabel_threshold_heart';
            app.LineNoiseEditField.Tag = 'iclabel_threshold_line';
            app.ChannelNoiseEditField.Tag = 'iclabel_threshold_chan';
            app.OtherEditField.Tag = 'iclabel_threshold_other';
            app.ChannelRemovalSwitch.Tag = 'rmchannels';
            app.SegmentRemovalSwitch.Tag = 'rmsegments';
            app.BaselineRemovalSwitch.Tag = 'rmbaseline';
            app.ResamplingSwitch.Tag = 'resampling';
            app.FilteringSwitch.Tag = 'filtering';
            app.RereferencingSwitch.Tag = 'rereference';
            app.ICADecompositionSwitch.Tag = 'ICA';
            app.ICRejectionSwitch.Tag = 'ICRejection';
            app.ASRSwitch.Tag = 'ASR';
            
            %SET SELECTION TAG
            app.SubjectInitialEditField.Tag = 'sub_i';
            app.SubjectFinalEditField.Tag = 'sub_f';
            app.SessionInitialEditField.Tag  = 'ses_i';
            app.SessionFinalEditField.Tag = 'ses_f';
            app.ObjectInitialEditField.Tag = 'obj_i';
            app.ObjectFinalEditField.Tag = 'obj_f';
            app.PerformSelectionSwitch.Tag = 'select_subjects';
            app.LabelNameEditField.Tag = 'label_name';
            app.LabelValueEditField.Tag = 'label_value';
            app.SubjectstoTakeTextArea.Tag = 'subjects_totake';
            app.SessionsToTakeTextArea.Tag = 'session_totake';
            app.ObjectsToTakeTextArea.Tag = 'task_totake';
            
            %SET SAVE TAG
            app.SavematfilesSwitch.Tag = 'save_data';
            app.SaveMarkerfilesSwitch.Tag = 'save_marker';
            app.SavestructSwitch.Tag = 'save_struct';
            app.SavesetfilesSwitch.Tag = 'save_set';
            app.EEGformatSwitch.Tag = 'save_data_as';
            
            % CHECK EEGlab PATH
            CheckEEGLabLaunch(app, 0)
            
            % CHECK parpool
            if ~contains(struct2array(ver), 'Parallel Computing Toolbox') 
                app.ParallelComputingSwitch.Enable = 'off';
            end

            % disable buttons on selection if necessary
            check_empty_selection(app)
            if app.selection_info.select_subjects
                enable4struct(app, 'selection')
            else
                disable4struct(app, 'selection')
            end
            
            app.UITable.Data = app.dataset_info;
            app.SettingListDropDown.Items = app.all_settings;
            app.RemoveSettingDropDown.Items = app.all_settings_nodefault;
            updateAllValues(app);

            checkPreproStatus(app, 'path')
            checkPreproStatus(app,'preprocessing')
            checkPreproStatus(app, 'selection')


        end

        % Button pushed function: NextButton, NextButton_2, NextButton_3, 
        % ...and 3 other components
        function NextButtonPushed(app, event)
            switch app.TabGroup.SelectedTab.Title
                case 'Intro'
                    app.TabGroup.SelectedTab = app.TableSelection;
                case 'Table Selection'
                    app.TabGroup.SelectedTab = app.SettingLoadTab;
                case 'Setting Load'
                    app.TabGroup.SelectedTab = app.PathsTab;
                case 'Paths'
                    app.TabGroup.SelectedTab = app.PreprocessingTab;
                case 'Preprocessing'
                    app.TabGroup.SelectedTab = app.SelectionTab;
                case 'Selection'
                    app.TabGroup.SelectedTab = app.RunPreprocessingTab;
            end
        end

        % Button pushed function: BackButton, BackButton_2, BackButton_3, 
        % ...and 3 other components
        function BackButtonPushed(app, event)
            switch app.TabGroup.SelectedTab.Title
                case 'Table Selection'
                    app.TabGroup.SelectedTab = app.IntroTab;
                case 'Setting Load'
                    app.TabGroup.SelectedTab = app.TableSelection;
                case 'Paths'
                    app.TabGroup.SelectedTab = app.SettingLoadTab;
                case 'Preprocessing'
                    app.TabGroup.SelectedTab = app.PathsTab;
                case 'Selection'
                    app.TabGroup.SelectedTab = app.PreprocessingTab;
                case 'Run Preprocessing'
                    app.TabGroup.SelectedTab = app.SelectionTab;
            end
        end

        % Button pushed function: SelectFileButton
        function SelectTable(app, event)
            [fileName,filePath] = uigetfile('*.*');
            if isequal(fileName, 0)
                if isempty(app.UITable.Data)
                    checkTableStatus(app)
                end
                return
            else
                app.dataset_info_filename = strcat(filePath,fileName);
                app.dataset_info=readtable(app.dataset_info_filename, 'format',...
                    '%f%s%s%s%s%s%s%s%s%f', 'filetype','text');
                app.UITable.Data = app.dataset_info;
                checkTableStatus(app);
            end
        end

        % Button pushed function: CreateButton
        function GenerateTable(app, event)
            if isempty(app.UITable.Data)
                app.dataset_info = create_empty_table(app.DatasetNumberEditField.Value);
                app.UITable.Data = app.dataset_info;
            elseif app.DatasetNumberEditField.Value < size(app.UITable.Data,1)
                app.dataset_info = app.dataset_info(1:app.DatasetNumberEditField.Value,:);
                app.UITable.Data = app.dataset_info;
            else
                app.dataset_info = create_empty_table( app.DatasetNumberEditField.Value,table2cell(app.UITable.Data));
                app.UITable.Data = app.dataset_info;
            end
            checkTableStatus(app)
        end

        % Button pushed function: EmptyButton
        function EmptyTable(app, event)
            app.dataset_info = create_empty_table(app.DatasetNumberEditField.Value);
            app.UITable.Data = app.dataset_info;
            checkTableStatus(app)
        end

        % Button pushed function: SaveButton
        function SaveTable(app, event)
            % Get the name of the file that the user wants to save.
            startingFolder = pwd;
            defaultFileName = fullfile(startingFolder, '*.csv');
            [baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
            if baseFileName == 0
            	% User clicked the Cancel button.
            	return
            end
            % Get base file name, so we can ignore whatever extension 
            % they may have typed in.
            [~, baseFileNameNoExt, ~] = fileparts(baseFileName);
            fullFileName = fullfile(folder, [baseFileNameNoExt, '.csv']);
            % Now write the table to an Excel workbook.
            writetable(app.UITable.Data, fullFileName);
        end

        % Cell edit callback: UITable
        function UITableCellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            try
                if indices(2) == 1 || indices(2) == 10
                    app.UITable.Data{indices(1), indices(2)} = newData;
                else
                    app.UITable.Data{indices(1), indices(2)} = {newData};
                end
                if isequal(app.TableStatusLamp.Color, [0 1 0])
                    % force to not convert a good table into a bad one
                    check_loaded_table(app.UITable.Data)
                end
                app.dataset_info = app.UITable.Data;
            catch
                app.UITable.Data = app.dataset_info;
            end
            checkTableStatus(app);
        end

        % Button pushed function: LoadSettingButton
        function LoadSetting(app, event)
            
            % load new settings
            value = app.SettingListDropDown.Value;
            [pathinfo,preprocessinfo, selectioninfo, saveinfo] = load_settings(value);
            
            % check if dataset path is changed. It will be used for the
            % single dataset / single file modality.
            if strcmp(pathinfo.datasets_path, app.path_info.datasets_path)
                is_datasetpath_changed = false;
            else
                is_datasetpath_changed = true;
            end
            
            % check each of the loaded struct settings
            try
                % path check - no datasets path requirement
                if isstruct(pathinfo)
                    check_path_info(pathinfo);
                else 
                    pathinfo = app.path_info;
                end
                
                % preprocess info check
                if isstruct(preprocessinfo)
                    check_preprocessing_info(preprocessinfo);
                else
                    preprocessinfo = app.preprocess_info;
                end
                
                % selection info check
                if isstruct(selectioninfo)
                    check_selection_info(selectioninfo);
                else
                    selectioninfo = app.selection_info;
                end
                
                % save info check
                if isstruct(saveinfo)
                    check_save_info(saveinfo);
                else
                    saveinfo = app.save_info;
                end
                
                % overwrite old settings
                app.path_info = pathinfo;
                app.preprocess_info = preprocessinfo;
                app.selection_info = selectioninfo;
                app.save_info = saveinfo;
                updateAllValues(app)
                
                % disable buttons on selection if necessary
                check_empty_selection(app)
                if app.selection_info.select_subjects
                    enable4struct(app, 'selection')
                else
                    disable4struct(app, 'selection')
                end
                
                % disable buttons on preprocessing based on icrejection
                % algorithm
                if strcmp(app.preprocess_info.ic_rej_type, 'mara')
                    app.AlgorithmSwitch.Value = 'MARA';
                    disable4struct(app,'iclabel')
                    enable4struct(app,'mara')
                else
                    app.AlgorithmSwitch.Value = 'ICLabel';
                    disable4struct(app,'mara')
                    enable4struct(app,'iclabel')
                end
                
                % update single_dataset / single_files dropdown list
                if isempty(app.path_info) || is_datasetpath_changed
                    SilenceSingleFile(app, true)
                    if isequal(app.TableStatusLamp.Color, [0 1 0])
                        app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                            app.dataset_info.dataset_name(:) );
                    end
                end
                
                % additional checks mainly for lamp status update
                checkPreproStatus(app,'path')
                checkPreproStatus(app,'preprocessing')
                checkPreproStatus(app,'selection')
                checkPreproStatus(app,'save')
                
            catch
                app.AllsettingstatustocheckLampLabel.Text = 'All setting status: to check';
                app.AllSetStatus.Color = [1 0 0];
            end
        end

        % Button pushed function: RemoveSetting
        function RemoveSet(app, event)
            value = app.RemoveSettingDropDown.Value;
            remove_settings(value)
            app.all_settings = get_stored_settings(true);
            app.all_settings_nodefault = get_stored_settings();
            app.SettingListDropDown.Items = app.all_settings;
            app.RemoveSettingDropDown.Items = app.all_settings_nodefault;   
        end

        % Button pushed function: SaveButton_2
        function SaveSet(app, event)
            new_custom_name = app.EditField.Value;
            if strcmpi(new_custom_name, 'input custom name')
                return
            else
                pathinfo = app.path_info;
                preprocessinginfo = app.preprocess_info;
                selectioninfo = app.selection_info;
                saveinfo = app.save_info;
                try
                    app.path_info = set_path_info(app.path_info, 'store_settings',...
                        true, 'setting_name', new_custom_name);
                catch
                    app.path_info = pathinfo;
                end
                try
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,...
                        'store_settings', true,'setting_name', new_custom_name);
                catch
                    app.preprocess_info = preprocessinginfo;
                end
                try
                    app.selection_info = set_selection_info(app.selection_info, ...
                        'store_settings', true, 'setting_name', new_custom_name);
                catch
                    app.selection_info = selectioninfo;
                end
                try
                    app.save_info = set_save_info(app.save_info, 'store_settings', ...
                        true, 'setting_name', new_custom_name);
                catch
                    app.save_info = saveinfo;
                end
                app.all_settings = get_stored_settings(true);
                app.all_settings_nodefault = get_stored_settings();
                app.SettingListDropDown.Items = app.all_settings;
                app.RemoveSettingDropDown.Items = app.all_settings_nodefault;  
            end
        end

        % Selection changed function: Settinginspect
        function InspectSetting(app, event)
            selectedButton = app.Settinginspect.SelectedObject;
            if strcmpi(app.TextArea.HorizontalAlignment,'center') 
                app.TextArea.HorizontalAlignment = 'left';
            end
            switch selectedButton.Text
                case 'Path info'                    
                    T = evalc('disp(app.path_info)');
                    app.TextArea.Value = T;
                case 'Prepro info'
                    T1 = evalc('app.preprocess_info');
                    T1 = strsplit(T1,'fields:');
                    T2 = evalc('app.preprocess_info.prep_steps');
                    T2 = strsplit(T2,'fields:');
                    T = cat(1, T1(2), T2(2));
                    app.TextArea.Value = T;
                case 'Selection info'
                    T = evalc('disp(app.selection_info)');
                    app.TextArea.Value = T;
                case 'Save info'
                    T = evalc('disp(app.save_info)');
                    app.TextArea.Value = T;     
            end
        end

        % Button pushed function: SetDatasetPathButton, 
        % ...and 5 other components
        function SetPathButtonFnc(app, event)
            path2add = uigetdir();
            if path2add == 0
                return
            else
                switch event.Source.Tag
                    case 'datasets_path'
                        app.path_info = set_path_info(app.path_info, 'datasets_path', path2add);
                        app.DatasetPathEditField.Value = app.path_info.datasets_path;
                        % every time the dataset path is changed it is best
                        % to reset all single dataset/file settings to
                        % avoid possible errors
                        SilenceSingleFile(app, true)
                        if isequal(app.TableStatusLamp.Color, [0 1 0])
                            app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                                app.dataset_info.dataset_name(:) );
                        end
                    case 'output_path'
                        app.path_info = set_path_info(app.path_info, 'output_path', path2add);
                        app.OutputPathEditField.Value = app.path_info.output_path;
                    case 'output_csv_path'
                        app.path_info = set_path_info(app.path_info, 'output_csv_path', path2add);
                        app.OutputcsvpathEditField.Value = app.path_info.output_csv_path;
                    case 'output_mat_path'
                        app.path_info = set_path_info(app.path_info, 'output_mat_path', path2add);
                        app.OutputmatpathEditField.Value = app.path_info.output_mat_path;
                    case 'output_set_path'
                        app.path_info = set_path_info(app.path_info, 'output_set_path', path2add);
                        app.OutputsetpathEditField.Value = app.path_info.output_set_path;
                    case 'eeglab_path'
                        app.path_info = set_path_info(app.path_info, 'eeglab_path', path2add);
                        app.EEGlabpathEditField.Value = app.path_info.eeglab_path;
                        CheckEEGLabLaunch(app, 0)
                end
                checkPreproStatus(app, 'path') 
            end            
        end

        % Button pushed function: CheckEEGLabButton
        function CheckEEGLabLaunch(app, event)
            if isequal(app.CheckEEGLabButton.FontColor, [0 1 0]) && ...
                    isequal(app.CheckEEGLabButton.Enable, 'off')
                return
            end
            if ~isempty(app.path_info.eeglab_path) && ...
                    isfolder(app.path_info.eeglab_path)
                addpath(app.path_info.eeglab_path)
            end
            try
                search_eeglab_path(false, true, true);
                app.CheckEEGLabButton.FontColor = [0 1 0];
                app.CheckEEGLabButton.Enable = 'off';
                checkPreproStatus(app, 'path');
            catch
                app.CheckEEGLabButton.FontColor = [1 0 0];
                app.CheckEEGLabButton.Enable = 'on';
            end
        end

        % Value changed function: DatasetPathEditField, 
        % ...and 6 other components
        function SetPathEditFieldFnc(app, event)
            path2add = event.Source.Value;
            try
                switch event.Source.Tag
                    case 'datasets_path'
                        if isempty(path2add)
                            error('path to datasets cannot be empty')
                        end
                        app.path_info = set_path_info(app.path_info, 'datasets_path', path2add);
                        app.DatasetPathEditField.Value = app.path_info.datasets_path;
                        % every time the dataset path is changed it is best
                        % to reset all single dataset/file settings to
                        % avoid possible errors
                        SilenceSingleFile(app, true)
                        if isequal(app.TableStatusLamp.Color, [0 1 0])
                            app.DatasettoPreprocessDropDown.Items = cat(1, {'All'}, ...
                                app.dataset_info.dataset_name(:) );
                        end
                        
                    case 'output_path'
                        if isempty(path2add)
                            error('output path cannot be empty')
                        end
                        app.path_info = set_path_info(app.path_info, 'output_path', path2add);
                        app.OutputPathEditField.Value = app.path_info.output_path;
                    case 'output_csv_path'
                        app.path_info = set_path_info(app.path_info, 'output_csv_path', path2add);
                        app.OutputcsvpathEditField.Value = app.path_info.output_csv_path;
                    case 'output_mat_path'
                        app.path_info = set_path_info(app.path_info, 'output_mat_path', path2add);
                        app.OutputmatpathEditField.Value = app.path_info.output_mat_path;
                    case 'output_set_path'
                        app.path_info = set_path_info(app.path_info, 'output_set_path', path2add);
                        app.OutputmatpathEditField.Value = app.path_info.output_set_path;
                    case 'eeglab_path'
                        app.path_info = set_path_info(app.path_info, 'eeglab_path', path2add);
                        app.EEGlabpathEditField.Value = app.path_info.eeglab_path;
                        CheckEEGLabLaunch(app, event)
                    case 'diagnostic_folder'
                        app.path_info = set_path_info(app.path_info, 'diagnostic_folder', path2add);
                        app.DiagnosticFolderNameEditField.Value = app.path_info.diagnostic_folder;
                end
            catch
                switch event.Source.Tag
                    case 'datasets_path'
                        app.DatasetPathEditField.Value = app.path_info.datasets_path;
                    case 'output_path'
                        app.OutputPathEditField.Value = app.path_info.output_path;
                    case 'output_csv_path'
                        app.OutputcsvpathEditField.Value = app.path_info.output_csv_path;
                    case 'output_mat_path'
                        app.OutputmatpathEditField.Value = app.path_info.output_mat_path;
                    case 'output_set_path'
                        app.OutputsetpathEditField.Value = app.path_info.output_set_path;
                    case 'eeglab_path'
                        app.EEGlabpathEditField.Value = app.path_info.eeglab_path;
                    case 'diagnostic_folder'
                        app.DiagnosticFolderNameEditField.Value = app.path_info.diagnostic_folder;
                end
            end
            checkPreproStatus(app, 'path') 
            
        end

        % Value changed function: AlgorithmSwitch, BrainEditField, 
        % ...and 24 other components
        function SetParamsFnc(app, event)
            param2add = event.Source.Value;
            try
                switch event.Source.Tag
                    case 'dt_i'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'dt_i', param2add);
                        app.InitialsegmentEditField.Value = app.preprocess_info.dt_i;
                    case 'dt_f'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'dt_f', param2add);
                        app.FinalsegmentEditField.Value = app.preprocess_info.dt_f;
                    case 'sampling_rate'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'sampling_rate', param2add);
                        app.SamplingRateEditField.Value = app.preprocess_info.sampling_rate;
                    case 'low_freq'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'low_freq', param2add);
                        app.LowFreqEditField.Value = app.preprocess_info.low_freq;
                    case 'high_freq'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'high_freq', param2add);
                        app.HighFreqEditField.Value = app.preprocess_info.high_freq;
                    case 'standard_ref'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'standard_ref', param2add);
                        app.StandardReferenceEditField.Value = app.preprocess_info.standard_ref;
                    case 'ica_type'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'ica_type', param2add);
                        app.TypeEditField.Value = app.preprocess_info.ica_type;
                    case 'non_linearity'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'non_linearity', param2add);
                        app.NonLinearityEditField.Value = app.preprocess_info.non_linearity;
                    case 'n_ica'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'n_ica', param2add);
                        app.ICNumberEditField.Value = app.preprocess_info.n_ica;
                    case 'ic_rej_type'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'ic_rej_type', param2add);
                        if strcmp(app.preprocess_info.ic_rej_type, 'mara')
                            app.AlgorithmSwitch.Value = 'MARA';
                            disable4struct(app,'iclabel')
                            enable4struct(app,'mara')
                        else
                            app.AlgorithmSwitch.Value = 'ICLabel';
                            disable4struct(app,'mara')
                            enable4struct(app,'iclabel')
                        end
                    case 'mara_threshold'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'mara_threshold', param2add);
                        app.MaraThresholdEditField.Value = app.preprocess_info.mara_threshold;
                    case 'th_reject'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'th_reject', param2add);
                        app.DoubleASRThresholdEditField.Value = app.preprocess_info.th_reject;
                    case 'flatlineC'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'flatlineC', param2add);
                        app.FlatlineCriterionEditField.Value = app.preprocess_info.flatlineC;
                    case 'channelC'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'channelC', param2add);
                        app.ChannelCriterionEditField.Value = app.preprocess_info.channelC;
                    case 'lineC'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'lineC', param2add);
                        app.LineNoiseCriterionEditField.Value = app.preprocess_info.lineC;
                    case 'windowC'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'windowC', param2add);
                        app.WindowCriterionEditField.Value = app.preprocess_info.windowC;
                    case 'burstC'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'burstC', param2add);
                        app.BurstCriterionEditField.Value = app.preprocess_info.burstC;
                    case 'burstR'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'burstR', lower(param2add));
                        app.BurstRejectionSwitch.Value = regexprep(lower(app.preprocess_info.burstR),'(\<[a-z])','${upper($1)}');
                    case 'interpol_method'
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'interpol_method', param2add);
                        app.InterpolationMethodEditField.Value = app.preprocess_info.interpol_method;
                    case {'iclabel_threshold_brain','iclabel_threshold_muscle','iclabel_threshold_eye',...
                            'iclabel_threshold_heart', 'iclabel_threshold_line', 'iclabel_threshold_chan',...
                            'iclabel_threshold_other'}
                        thresh2add = GetICLabelThresh(app, event.Source.Tag, event.Source.Value);
                        app.preprocess_info = set_preprocessing_info(app.preprocess_info, 'iclabel_thresholds', thresh2add);
                        app.BrainEditField.Value = app.preprocess_info.iclabel_thresholds(1,2);
                        app.MuscleEditField.Value = app.preprocess_info.iclabel_thresholds(2,1);
                        app.EyeEditField.Value = app.preprocess_info.iclabel_thresholds(3,1);
                        app.HeartEditField.Value = app.preprocess_info.iclabel_thresholds(4,1);
                        app.LineNoiseEditField.Value = app.preprocess_info.iclabel_thresholds(5,1);
                        app.ChannelNoiseEditField.Value = app.preprocess_info.iclabel_thresholds(6,1);
                        app.OtherEditField.Value = app.preprocess_info.iclabel_thresholds(7,1);
                end
            catch
                switch event.Source.Tag
                    case 'dt_i'
                        app.InitialsegmentEditField.Value = app.preprocess_info.dt_i;
                    case 'dt_f'
                        app.FinalsegmentEditField.Value = app.preprocess_info.dt_f;
                    case 'sampling_rate'
                        app.SamplingRateEditField.Value = app.preprocess_info.sampling_rate;
                    case 'low_freq'
                        app.LowFreqEditField.Value = app.preprocess_info.low_freq;
                    case 'high_freq'
                        app.HighFreqEditField.Value = app.preprocess_info.high_freq;
                    case 'standard_ref'
                        app.StandardReferenceEditField.Value = app.preprocess_info.standard_ref;
                    case 'ica_type'
                        app.TypeEditField.Value = app.preprocess_info.ica_type;
                    case 'non_linearity'
                        app.NonLinearityEditField.Value = app.preprocess_info.non_linearity;
                    case 'n_ica'
                        app.ICNumberEditField.Value = app.preprocess_info.n_ica;
                    case 'ic_rej_type'
                        if strcmp(app.preprocess_info.ic_rej_type, 'mara')
                            app.AlgorithmSwitch.Value = 'MARA';
                            disable4struct(app,'iclabel')
                            enable4struct(app,'mara')
                        else
                            app.AlgorithmSwitch.Value = 'ICLabel';
                            disable4struct(app,'mara')
                            enable4struct(app,'iclabel')
                        end
                    case 'mara_threshold'
                        app.MaraThresholdEditField.Value = app.preprocess_info.mara_threshold;
                    case 'th_reject'
                        app.DoubleASRThresholdEditField.Value = app.preprocess_info.th_reject;
                    case 'flatlineC'
                        app.FlatlineCriterionEditField.Value = app.preprocess_info.flatlineC;
                    case 'channelC'
                        app.ChannelCriterionEditField.Value = app.preprocess_info.channelC;
                    case 'lineC'
                        app.LineNoiseCriterionEditField.Value = app.preprocess_info.lineC;
                    case 'windowC'
                        app.WindowCriterionEditField.Value = app.preprocess_info.windowC;
                    case 'burstC'
                        app.BurstCriterionEditField.Value = app.preprocess_info.burstC;
                    case 'burstR'
                        app.BurstRejectionSwitch.Value = regexprep(lower(app.preprocess_info.burstR),'(\<[a-z])','${upper($1)}');
                    case 'interpol_method'
                        app.InterpolationMethodEditField.Value = app.preprocess_info.interpol_method;
                    case {'iclabel_threshold_brain','iclabel_threshold_muscle','iclabel_threshold_eye',...
                            'iclabel_threshold_heart', 'iclabel_threshold_line', 'iclabel_threshold_chan',...
                            'iclabel_threshold_other'}
                        app.BrainEditField.Value = app.preprocess_info.iclabel_thresholds(1,2);
                        app.MuscleEditField.Value = app.preprocess_info.iclabel_thresholds(2,1);
                        app.EyeEditField.Value = app.preprocess_info.iclabel_thresholds(3,1);
                        app.HeartEditField.Value = app.preprocess_info.iclabel_thresholds(4,1);
                        app.LineNoiseEditField.Value = app.preprocess_info.iclabel_thresholds(5,1);
                        app.ChannelNoiseEditField.Value = app.preprocess_info.iclabel_thresholds(6,1);
                        app.OtherEditField.Value = app.preprocess_info.iclabel_thresholds(7,1);
                end
                
            end
            checkPreproStatus(app, 'preprocessing') 
        end

        % Value changed function: EEGformatSwitch, SaveMarkerfilesSwitch, 
        % ...and 3 other components
        function SetSaveFnc(app, event)
            savingOpt = event.Source.Value;
            switch event.Source.Tag
                case 'save_data'
                    if strcmp(savingOpt, 'No')
                        app.save_info.save_struct = false;
                        app.SavematfilesSwitch.Value = 'No';
                    end
                    app.save_info = set_save_info(app.save_info,'save_data', string2boolean(savingOpt));
                case 'save_set'
                    app.save_info = set_save_info(app.save_info, 'save_set', string2boolean(savingOpt));
                case 'save_struct'
                    if strcmp(savingOpt, 'Yes')
                        app.save_info.save_data = true;
                        app.SavematfilesSwitch.Value = 'Yes';
                    end
                    app.save_info = set_save_info(app.save_info, 'save_struct',string2boolean(savingOpt));
                case 'save_marker'
                    app.save_info = set_save_info(app.save_info,'save_marker', string2boolean(savingOpt));
                case 'save_data_as'
                    app.save_info = set_save_info(app.save_info, 'save_data_as', savingOpt);                  
            end
        end

        % Value changed function: ASRSwitch, BaselineRemovalSwitch, 
        % ...and 7 other components
        function Step2DoFnc(app, event)
            step2do = event.Source.Value;
            switch event.Source.Tag
                case 'rmchannels'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'rmchannels', string2boolean(step2do));
                case 'rmsegments'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'rmsegments', string2boolean(step2do));
                case 'rmbaseline'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'rmbaseline', string2boolean(step2do));
                case 'resampling'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'resampling', string2boolean(step2do));
                case 'filtering'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'filtering', string2boolean(step2do));
                case 'rereference'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'rereference', string2boolean(step2do));
                case 'ICA'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'ICA', string2boolean(step2do));
                case 'ICRejection'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'ICRejection', string2boolean(step2do));
                case 'ASR'
                    app.preprocess_info = set_preprocessing_info(app.preprocess_info,'ASR', string2boolean(step2do));
            end
        end

        % Value changed function: ParallelComputingSwitch
        function DoParpool(app, event)
            addparpool = app.ParallelComputingSwitch.Value;
            app.use_parpool = string2boolean(addparpool);
        end

        % Value changed function: VerboseSwitch
        function AddVerbose(app, event)
            addverbose = app.VerboseSwitch.Value;
            app.verbose = string2boolean(addverbose);
        end

        % Value changed function: DatasettoPreprocessDropDown
        function SingleDataset(app, event)
            value = app.DatasettoPreprocessDropDown.Value;
            if strcmpi(value,'all')
                SilenceSingleFile(app, false);
            else
                app.single_dataset_name = value;
                if ~isempty(app.path_info.datasets_path)
                    app.SingleFileDropDown.Enable='on';
                    app.SingleFileDropDownLabel.Enable = 'on';
                end
                app.use_parpool = false;
                app.ParallelComputingSwitch.Value = 'Off';
                regenerate_single_file_list(app, app.single_dataset_name);               
            end
        end

        % Value changed function: SingleFileDropDown
        function SingleFile(app, event)
            file2add = app.SingleFileDropDown.Value;
            if strcmp(file2add, 'All files')
                app.single_file = false;
                app.single_file_name = '';
            else
                app.single_file = true;       
                rows=  strcmp( app.single_dataset_name , app.dataset_info.dataset_name);
                code_and_format = app.dataset_info{rows,["dataset_code", "eeg_file_extension"]};
                filelist = get_dataset_file_list(app.path_info.datasets_path, ...
                    code_and_format{1}, code_and_format{2});
                allfilepaths = cell(length(filelist),1);
                for i=1:length(filelist)
                    allfilepaths{i} = [filelist(i).folder filesep filelist(i).name];
                end
                file2add = allfilepaths{contains(allfilepaths, file2add)};
                app.single_file_name = file2add;
            end
            
        end

        % Value changed function: LabelNameEditField, LabelValueEditField, 
        % ...and 10 other components
        function SetSelectionFnc(app, event)
            SelValue = event.Source.Value;
            try
                switch event.Source.Tag
                    case 'sub_i'
                        app.selection_info = set_selection_info(app.selection_info,'sub_i', ValueOrZero(app,SelValue,true));
                    case 'sub_f'
                        app.selection_info = set_selection_info(app.selection_info,'sub_f', ValueOrZero(app,SelValue,true));
                    case 'ses_i'
                        app.selection_info = set_selection_info(app.selection_info,'ses_i', ValueOrZero(app,SelValue,true));
                    case 'ses_f'
                        app.selection_info = set_selection_info(app.selection_info,'ses_f', ValueOrZero(app,SelValue,true));
                    case 'obj_i'
                        app.selection_info = set_selection_info(app.selection_info,'obj_i', ValueOrZero(app,SelValue,true));
                    case 'obj_f'
                        app.selection_info = set_selection_info(app.selection_info,'obj_f', ValueOrZero(app,SelValue,true));
                    case 'select_subjects'
                        app.selection_info = set_selection_info(app.selection_info,'select_subjects', string2boolean(SelValue));
                        if app.selection_info.select_subjects
                            enable4struct(app, 'selection')
                        else
                            disable4struct(app, 'selection')
                        end
                    case 'label_name'
                        app.selection_info = set_selection_info(app.selection_info,'label_name', SelValue);
                    case 'label_value'
                        app.selection_info = set_selection_info(app.selection_info,'label_value', SelValue);
                    case 'subjects_totake'
                        app.selection_info = set_selection_info(app.selection_info,'subjects_totake', ...
                            emptycell4text(app, SelValue, true));
                    case 'session_totake'
                        app.selection_info = set_selection_info(app.selection_info,'session_totake', ...
                            emptycell4text(app, SelValue, true));
                    case 'task_totake'
                        app.selection_info = set_selection_info(app.selection_info,'task_totake', ...
                            emptycell4text(app, SelValue, true));
                end
            catch
                switch event.Source.Tag
                    case 'sub_i'
                        app.SubjectInitialEditField.Value = ValueOrZero(app, app.selection_info.sub_i);
                    case 'sub_f'
                        app.SubjectFinalEditField.Value = ValueOrZero(app, app.selection_info.sub_f);
                    case 'ses_i'
                        app.SessionInitialEditField.Value = ValueOrZero(app, app.selection_info.ses_i);
                    case 'ses_f'
                        app.SessionFinalEditField.Value = ValueOrZero(app, app.selection_info.ses_f);
                    case 'obj_i'
                        app.ObjectInitialEditField.Value = ValueOrZero(app, app.selection_info.obj_i);
                    case 'obj_f'
                        app.ObjectFinalEditField.Value = ValueOrZero(app, app.selection_info.obj_f);
                    case 'select_subjects'
                        app.PerformSelectionSwitch.Value = Bool2Value(app, app.selection_info.select_subjects, true);
                    case 'label_name'
                        app.LabelNameEditField.Value = app.selection_info.label_name;
                    case 'label_value'
                        app.LabelValueEditField.Value = app.selection_info.label_value;
                    case 'subjects_totake'
                        app.SubjectstoTakeTextArea.Value = emptycell4text(app, app.selection_info.subjects_totake);
                    case 'session_totake'
                        app.SessionsToTakeTextArea.Value = emptycell4text(app, app.selection_info.session_totake);
                    case 'task_totake'
                        app.ObjectsToTakeTextArea.Value = emptycell4text(app, app.selection_info.task_totake);
                end
            end
            checkPreproStatus(app, 'selection') 
        end

        % Button pushed function: RunButton
        function RunPreprocessing(app, event)
            app.FinalcheckscontroltableLabel.Text = 'Final checks: Running preprocessing...';
            pause(0.5)
            current_path = pwd;
            try 
                app.EEG_data = preprocess_all( app.dataset_info, ...
                    'path_info', app.path_info, ...
                    'preprocess_info', app.preprocess_info, ...
                    'selection_info', app.selection_info, ...
                    'save_info', app.save_info, ...
                    'setting_name', app.SettingListDropDown.Value, ...
                    'single_file', app.single_file, ...
                    'single_dataset_name', app.single_dataset_name, ...
                    'single_file_name', app.single_file_name, ...
                    'use_parpool', app.use_parpool, ...
                    'solve_nogui', app.solve_nogui, ...
                    'verbose', app.verbose ...
                    );
            
                
            catch e %e is an MException struct
                cd(current_path)
                fprintf('\n The preprocessing function ended unexpectedly with the following error \n')
                fprintf(1,'The identifier was:\n%s',e.identifier);
                fprintf(1,'There was an error! The message was:\n%s',e.message);              
            end
            app.FinalcheckscontroltableLabel.Text = 'Final checks: ready to start';
        end

        % Button pushed function: HelpButton, HelpButton_2, HelpButton_3, 
        % ...and 4 other components
        function HelpFnc(app, event)
            switch event.Source.Tag
                case 'HelpIntro'
                    web('GUI/General_help.html')
                case 'HelpTable'
                    web('GUI/Table_help.html')
                case 'HelpSetting'
                    web('GUI/SettingTab.html')
                case 'HelpPath'
                    web('GUI/PathsTab.html')
                case 'HelpPreprocessing'
                    web('GUI/PreprocessingTab.html')
                case 'HelpSelection'
                    web('GUI/SelectionTab.html')
                case 'HelpRun'
                    web('GUI/RunTab.html')
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 772 491];
            app.UIFigure.Name = 'UI Figure';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [0 0 774 494];

            % Create IntroTab
            app.IntroTab = uitab(app.TabGroup);
            app.IntroTab.Title = 'Intro';
            app.IntroTab.BackgroundColor = [0.8588 0.9608 0.9882];

            % Create NextButton
            app.NextButton = uibutton(app.IntroTab, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.Position = [649 10 100 22];
            app.NextButton.Text = 'Next';

            % Create Image
            app.Image = uiimage(app.IntroTab);
            app.Image.Tooltip = {'That''s a cool logo, isn''t it?'};
            app.Image.Position = [59 349 649 84];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'GUI', 'logo4gui.png');

            % Create Label
            app.Label = uilabel(app.IntroTab);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontSize = 14;
            app.Label.FontColor = [0 0.4471 0.7412];
            app.Label.Position = [76 116 624 118];
            app.Label.Text = {'This library will help you preprocess and align multiple BIDS data sources. '; 'To preprocess your BIDS datasets, you just need to:'; ''; '    -- give a set of information in a table to help BIDSAlign find EEG files and coordinate things --'; '    -- set the paths to the root dataset folder, the output folder, and the eeglab plugin folder --'; '    -- (Optional) Customize your preprocessing with a wide list of parameters --'};

            % Create HelpButton_4
            app.HelpButton_4 = uibutton(app.IntroTab, 'push');
            app.HelpButton_4.ButtonPushedFcn = createCallbackFcn(app, @HelpFnc, true);
            app.HelpButton_4.Tooltip = {'Do you really need some help here? press the next button and start your journey with BIDSAlign.'; ''; 'Jokes aside, remember that you can click the help buttons placed in every tab to open an help window. '};
            app.HelpButton_4.Position = [25 10 49 22];
            app.HelpButton_4.Text = 'Help';

            % Create PathstatustocheckLabel_2
            app.PathstatustocheckLabel_2 = uilabel(app.IntroTab);
            app.PathstatustocheckLabel_2.FontSize = 13;
            app.PathstatustocheckLabel_2.FontWeight = 'bold';
            app.PathstatustocheckLabel_2.Position = [121 10 374 22];
            app.PathstatustocheckLabel_2.Text = 'Check this lamp to see if everything has been set correctly';

            % Create PathStatus_2
            app.PathStatus_2 = uilamp(app.IntroTab);
            app.PathStatus_2.Tooltip = {'If this lamp becomes red, your computer has been hacked!!!'};
            app.PathStatus_2.Position = [91 11 20 20];

            % Create WelcometoBIDSAlignLabel
            app.WelcometoBIDSAlignLabel = uilabel(app.IntroTab);
            app.WelcometoBIDSAlignLabel.FontSize = 18;
            app.WelcometoBIDSAlignLabel.FontWeight = 'bold';
            app.WelcometoBIDSAlignLabel.FontColor = [0 0.4471 0.7412];
            app.WelcometoBIDSAlignLabel.Position = [278 281 206 23];
            app.WelcometoBIDSAlignLabel.Text = 'Welcome to BIDSAlign!';

            % Create TableSelection
            app.TableSelection = uitab(app.TabGroup);
            app.TableSelection.Title = 'Table Selection';
            app.TableSelection.BackgroundColor = [0.8588 0.9608 0.9882];

            % Create UITable
            app.UITable = uitable(app.TableSelection);
            app.UITable.ColumnName = {'dataset_number_reference'; 'dataset_name'; 'dataset_code'; 'channel_location_filename'; 'nose_direction'; 'channel_system'; 'channel_reference'; 'channel_to_remove'; 'eeg_file_extension'; 'samp_rate'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = true;
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Tooltip = {'For a complete description of the entries check the help.'};
            app.UITable.Position = [16 57 742 292];

            % Create NextButton_2
            app.NextButton_2 = uibutton(app.TableSelection, 'push');
            app.NextButton_2.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton_2.IconAlignment = 'right';
            app.NextButton_2.Position = [649 10 100 22];
            app.NextButton_2.Text = 'Next';

            % Create BackButton
            app.BackButton = uibutton(app.TableSelection, 'push');
            app.BackButton.ButtonPushedFcn = createCallbackFcn(app, @BackButtonPushed, true);
            app.BackButton.Position = [531 10 100 22];
            app.BackButton.Text = 'Back';

            % Create SelectFileButton
            app.SelectFileButton = uibutton(app.TableSelection, 'push');
            app.SelectFileButton.ButtonPushedFcn = createCallbackFcn(app, @SelectTable, true);
            app.SelectFileButton.Tooltip = {'Select a table file to open. If you haven''t preprared one, take a look at the tsv file released with the library. You can copy it and modify for your purposes.'};
            app.SelectFileButton.Position = [51 365 100 22];
            app.SelectFileButton.Text = 'Select File';

            % Create SaveButton
            app.SaveButton = uibutton(app.TableSelection, 'push');
            app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveTable, true);
            app.SaveButton.Tooltip = {'Don''t waste your time. Save the current table if not already available as a file.'};
            app.SaveButton.Position = [614 365 100 22];
            app.SaveButton.Text = 'Save';

            % Create CreateButton
            app.CreateButton = uibutton(app.TableSelection, 'push');
            app.CreateButton.ButtonPushedFcn = createCallbackFcn(app, @GenerateTable, true);
            app.CreateButton.Tooltip = {'Create a table with as many rows as the number of datasets.'; 'If a table already exist, it will delete all the rows with an index bigger than dataset Number'};
            app.CreateButton.Position = [267 365 100 22];
            app.CreateButton.Text = 'Create';

            % Create EmptyButton
            app.EmptyButton = uibutton(app.TableSelection, 'push');
            app.EmptyButton.ButtonPushedFcn = createCallbackFcn(app, @EmptyTable, true);
            app.EmptyButton.Tooltip = {'Generate an empty table with a number of rows equals to dataset number'};
            app.EmptyButton.Position = [407 365 100 22];
            app.EmptyButton.Text = 'Empty';

            % Create TableStatusLamp
            app.TableStatusLamp = uilamp(app.TableSelection);
            app.TableStatusLamp.Position = [91 11 20 20];
            app.TableStatusLamp.Color = [1 0 0];

            % Create HelpButton
            app.HelpButton = uibutton(app.TableSelection, 'push');
            app.HelpButton.ButtonPushedFcn = createCallbackFcn(app, @HelpFnc, true);
            app.HelpButton.Position = [25 10 49 22];
            app.HelpButton.Text = 'Help';

            % Create TableStatusemptyLabel
            app.TableStatusemptyLabel = uilabel(app.TableSelection);
            app.TableStatusemptyLabel.FontWeight = 'bold';
            app.TableStatusemptyLabel.Position = [122 10 276 22];
            app.TableStatusemptyLabel.Text = 'Table Status: empty';

            % Create tableInfoLoad
            app.tableInfoLoad = uilabel(app.TableSelection);
            app.tableInfoLoad.HorizontalAlignment = 'center';
            app.tableInfoLoad.FontSize = 13;
            app.tableInfoLoad.Position = [34 400 134 49];
            app.tableInfoLoad.Text = {'Load a table with '; 'the dataset info '; 'directly from file'};

            % Create DatasetNumberLabel
            app.DatasetNumberLabel = uilabel(app.TableSelection);
            app.DatasetNumberLabel.HorizontalAlignment = 'right';
            app.DatasetNumberLabel.FontSize = 13;
            app.DatasetNumberLabel.Position = [314 400 104 22];
            app.DatasetNumberLabel.Text = 'Dataset Number:';

            % Create DatasetNumberEditField
            app.DatasetNumberEditField = uieditfield(app.TableSelection, 'numeric');
            app.DatasetNumberEditField.Limits = [0 Inf];
            app.DatasetNumberEditField.RoundFractionalValues = 'on';
            app.DatasetNumberEditField.HorizontalAlignment = 'center';
            app.DatasetNumberEditField.FontSize = 13;
            app.DatasetNumberEditField.Position = [422 400 38 22];
            app.DatasetNumberEditField.Value = 1;

            % Create SaveTableInfo
            app.SaveTableInfo = uilabel(app.TableSelection);
            app.SaveTableInfo.HorizontalAlignment = 'center';
            app.SaveTableInfo.FontSize = 13;
            app.SaveTableInfo.Position = [618 400 96 41];
            app.SaveTableInfo.Text = {'Save current'; 'table'};

            % Create GenerateTableInfo
            app.GenerateTableInfo = uilabel(app.TableSelection);
            app.GenerateTableInfo.HorizontalAlignment = 'center';
            app.GenerateTableInfo.FontSize = 13;
            app.GenerateTableInfo.Position = [266 421 239 41];
            app.GenerateTableInfo.Text = {'Create a new empty table with the given'; 'dataset number or delete current one '};

            % Create SettingLoadTab
            app.SettingLoadTab = uitab(app.TabGroup);
            app.SettingLoadTab.Title = 'Setting Load';
            app.SettingLoadTab.BackgroundColor = [0.8588 0.9608 0.9882];

            % Create NextButton_8
            app.NextButton_8 = uibutton(app.SettingLoadTab, 'push');
            app.NextButton_8.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton_8.Position = [649 10 100 22];
            app.NextButton_8.Text = 'Next';

            % Create BackButton_8
            app.BackButton_8 = uibutton(app.SettingLoadTab, 'push');
            app.BackButton_8.ButtonPushedFcn = createCallbackFcn(app, @BackButtonPushed, true);
            app.BackButton_8.Position = [531 10 100 22];
            app.BackButton_8.Text = 'Back';

            % Create SettingListDropDown
            app.SettingListDropDown = uidropdown(app.SettingLoadTab);
            app.SettingListDropDown.Items = {};
            app.SettingListDropDown.Editable = 'on';
            app.SettingListDropDown.Tooltip = {'Select a pre-saved configuration to speed up the preprocessing preparation. Click load once you have chosen the right one '};
            app.SettingListDropDown.BackgroundColor = [1 1 1];
            app.SettingListDropDown.Position = [52 349 100 22];
            app.SettingListDropDown.Value = {};

            % Create RemoveSettingDropDown
            app.RemoveSettingDropDown = uidropdown(app.SettingLoadTab);
            app.RemoveSettingDropDown.Items = {};
            app.RemoveSettingDropDown.Editable = 'on';
            app.RemoveSettingDropDown.Tooltip = {'Select a setting to remove. Useful if you have saved a setting or you want to remove old configurations. Do you want to remove the default setting.'; 'NO, YOU CAN''T!'};
            app.RemoveSettingDropDown.BackgroundColor = [1 1 1];
            app.RemoveSettingDropDown.Position = [337 349 100 22];
            app.RemoveSettingDropDown.Value = {};

            % Create HelpButton_2
            app.HelpButton_2 = uibutton(app.SettingLoadTab, 'push');
            app.HelpButton_2.ButtonPushedFcn = createCallbackFcn(app, @HelpFnc, true);
            app.HelpButton_2.Position = [25 10 49 22];
            app.HelpButton_2.Text = 'Help';

            % Create AllsettingstatustocheckLampLabel
            app.AllsettingstatustocheckLampLabel = uilabel(app.SettingLoadTab);
            app.AllsettingstatustocheckLampLabel.FontSize = 13;
            app.AllsettingstatustocheckLampLabel.FontWeight = 'bold';
            app.AllsettingstatustocheckLampLabel.Position = [121 10 171 22];
            app.AllsettingstatustocheckLampLabel.Text = 'All setting status: to check';

            % Create AllSetStatus
            app.AllSetStatus = uilamp(app.SettingLoadTab);
            app.AllSetStatus.Position = [91 11 20 20];
            app.AllSetStatus.Color = [1 0 0];

            % Create EditField
            app.EditField = uieditfield(app.SettingLoadTab, 'text');
            app.EditField.HorizontalAlignment = 'center';
            app.EditField.Tooltip = {'Type here a name for a new setting. Remember that if you use an already existing name, it will overwrite the saved setting'};
            app.EditField.Position = [608 349 112 22];
            app.EditField.Value = 'input custom name';

            % Create SaveButton_2
            app.SaveButton_2 = uibutton(app.SettingLoadTab, 'push');
            app.SaveButton_2.ButtonPushedFcn = createCallbackFcn(app, @SaveSet, true);
            app.SaveButton_2.Tooltip = {'Click here to save your current setting.'};
            app.SaveButton_2.Position = [614 318 100 22];
            app.SaveButton_2.Text = 'Save';

            % Create Settinginspect
            app.Settinginspect = uibuttongroup(app.SettingLoadTab);
            app.Settinginspect.SelectionChangedFcn = createCallbackFcn(app, @InspectSetting, true);
            app.Settinginspect.Tooltip = {'Click one of the button to visualize the current set of parameters. You may want to do a double check before deleting or saving something.'};
            app.Settinginspect.TitlePosition = 'centertop';
            app.Settinginspect.Title = 'Setting inspect';
            app.Settinginspect.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Settinginspect.Position = [40 132 123 118];

            % Create PathinfoButton
            app.PathinfoButton = uiradiobutton(app.Settinginspect);
            app.PathinfoButton.Text = 'Path info';
            app.PathinfoButton.Position = [11 72 69 22];

            % Create PreproinfoButton
            app.PreproinfoButton = uiradiobutton(app.Settinginspect);
            app.PreproinfoButton.Text = 'Prepro info';
            app.PreproinfoButton.Position = [11 50 81 22];
            app.PreproinfoButton.Value = true;

            % Create SelectioninfoButton
            app.SelectioninfoButton = uiradiobutton(app.Settinginspect);
            app.SelectioninfoButton.Text = 'Selection info';
            app.SelectioninfoButton.Position = [11 28 94 22];

            % Create SaveinfoButton
            app.SaveinfoButton = uiradiobutton(app.Settinginspect);
            app.SaveinfoButton.Text = 'Save info';
            app.SaveinfoButton.Position = [11 7 72 22];

            % Create SettingListInfo
            app.SettingListInfo = uilabel(app.SettingLoadTab);
            app.SettingListInfo.HorizontalAlignment = 'center';
            app.SettingListInfo.FontSize = 13;
            app.SettingListInfo.Position = [56 387 91 60];
            app.SettingListInfo.Text = {'Select a set of '; 'parameters'; 'to load from '; 'the current list '};

            % Create SettingRemoveInfo
            app.SettingRemoveInfo = uilabel(app.SettingLoadTab);
            app.SettingRemoveInfo.HorizontalAlignment = 'center';
            app.SettingRemoveInfo.FontSize = 13;
            app.SettingRemoveInfo.Position = [337 387 97 60];
            app.SettingRemoveInfo.Text = {'Select a set of '; 'parameters'; 'to remove from '; 'the current list '};

            % Create SettingSaveInfo
            app.SettingSaveInfo = uilabel(app.SettingLoadTab);
            app.SettingSaveInfo.HorizontalAlignment = 'center';
            app.SettingSaveInfo.FontSize = 13;
            app.SettingSaveInfo.Position = [606 387 117 60];
            app.SettingSaveInfo.Text = {'Save the set '; 'parameters '; 'in a custom setting '; 'to load in the future'};

            % Create TextArea
            app.TextArea = uitextarea(app.SettingLoadTab);
            app.TextArea.Editable = 'off';
            app.TextArea.HorizontalAlignment = 'center';
            app.TextArea.FontSize = 14;
            app.TextArea.Position = [220 77 496 208];
            app.TextArea.Value = {'click on a Setting Inspect button to check current loaded setting. '; ''; 'Might be useful to verify if the loaded setting is the right one '; 'or'; 'to double check a custom setting before saving it'};

            % Create RemoveSetting
            app.RemoveSetting = uibutton(app.SettingLoadTab, 'push');
            app.RemoveSetting.ButtonPushedFcn = createCallbackFcn(app, @RemoveSet, true);
            app.RemoveSetting.Tooltip = {'You must click here to actually remove a setting. Remember that removing a setting does not reset the current preprocessing configuration.'};
            app.RemoveSetting.Position = [337 318 100 22];
            app.RemoveSetting.Text = 'Remove';

            % Create LoadSettingButton
            app.LoadSettingButton = uibutton(app.SettingLoadTab, 'push');
            app.LoadSettingButton.ButtonPushedFcn = createCallbackFcn(app, @LoadSetting, true);
            app.LoadSettingButton.Tooltip = {'You need to press this to actually load the setting'};
            app.LoadSettingButton.Position = [52 318 100 22];
            app.LoadSettingButton.Text = 'Load';

            % Create PathsTab
            app.PathsTab = uitab(app.TabGroup);
            app.PathsTab.Title = 'Paths';
            app.PathsTab.BackgroundColor = [0.8588 0.9608 0.9882];

            % Create BackButton_2
            app.BackButton_2 = uibutton(app.PathsTab, 'push');
            app.BackButton_2.ButtonPushedFcn = createCallbackFcn(app, @BackButtonPushed, true);
            app.BackButton_2.Position = [531 10 100 22];
            app.BackButton_2.Text = 'Back';

            % Create NextButton_3
            app.NextButton_3 = uibutton(app.PathsTab, 'push');
            app.NextButton_3.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton_3.Position = [649 10 100 22];
            app.NextButton_3.Text = 'Next';

            % Create HelpButton_3
            app.HelpButton_3 = uibutton(app.PathsTab, 'push');
            app.HelpButton_3.ButtonPushedFcn = createCallbackFcn(app, @HelpFnc, true);
            app.HelpButton_3.Position = [25 10 49 22];
            app.HelpButton_3.Text = 'Help';

            % Create PathstatustocheckLabel
            app.PathstatustocheckLabel = uilabel(app.PathsTab);
            app.PathstatustocheckLabel.FontSize = 13;
            app.PathstatustocheckLabel.FontWeight = 'bold';
            app.PathstatustocheckLabel.Position = [121 10 136 22];
            app.PathstatustocheckLabel.Text = 'Path status: to check';

            % Create PathStatus
            app.PathStatus = uilamp(app.PathsTab);
            app.PathStatus.Position = [91 11 20 20];
            app.PathStatus.Color = [1 0 0];

            % Create DatasetPathEditFieldLabel
            app.DatasetPathEditFieldLabel = uilabel(app.PathsTab);
            app.DatasetPathEditFieldLabel.HorizontalAlignment = 'right';
            app.DatasetPathEditFieldLabel.Position = [33 370 75 22];
            app.DatasetPathEditFieldLabel.Text = 'Dataset Path';

            % Create DatasetPathEditField
            app.DatasetPathEditField = uieditfield(app.PathsTab, 'text');
            app.DatasetPathEditField.ValueChangedFcn = createCallbackFcn(app, @SetPathEditFieldFnc, true);
            app.DatasetPathEditField.Tooltip = {'Type the full path to the dataset root folder. Or use the button to the right'};
            app.DatasetPathEditField.Position = [123 370 177 22];

            % Create OutputPathEditFieldLabel
            app.OutputPathEditFieldLabel = uilabel(app.PathsTab);
            app.OutputPathEditFieldLabel.HorizontalAlignment = 'right';
            app.OutputPathEditFieldLabel.Position = [36 236 70 22];
            app.OutputPathEditFieldLabel.Text = 'Output Path';

            % Create OutputPathEditField
            app.OutputPathEditField = uieditfield(app.PathsTab, 'text');
            app.OutputPathEditField.ValueChangedFcn = createCallbackFcn(app, @SetPathEditFieldFnc, true);
            app.OutputPathEditField.Tooltip = {'Type the full path to the output folder. BIDSAlign will use this path to create a set of subdirectories to store preprocessed files. '; 'This path will be ignored for file format with a specific assigned output path (three path below)'};
            app.OutputPathEditField.Position = [121 236 177 22];

            % Create OutputmatpathEditFieldLabel
            app.OutputmatpathEditFieldLabel = uilabel(app.PathsTab);
            app.OutputmatpathEditFieldLabel.HorizontalAlignment = 'right';
            app.OutputmatpathEditFieldLabel.Position = [14 198 92 22];
            app.OutputmatpathEditFieldLabel.Text = 'Output mat path';

            % Create OutputmatpathEditField
            app.OutputmatpathEditField = uieditfield(app.PathsTab, 'text');
            app.OutputmatpathEditField.ValueChangedFcn = createCallbackFcn(app, @SetPathEditFieldFnc, true);
            app.OutputmatpathEditField.Tooltip = {'Set a custom path for preprocessed EEGs stored in .mat format. '; 'This path will override the default Output Path '};
            app.OutputmatpathEditField.Position = [121 198 177 22];

            % Create OutputsetpathEditFieldLabel
            app.OutputsetpathEditFieldLabel = uilabel(app.PathsTab);
            app.OutputsetpathEditFieldLabel.HorizontalAlignment = 'right';
            app.OutputsetpathEditFieldLabel.Position = [18 160 88 22];
            app.OutputsetpathEditFieldLabel.Text = 'Output set path';

            % Create OutputsetpathEditField
            app.OutputsetpathEditField = uieditfield(app.PathsTab, 'text');
            app.OutputsetpathEditField.ValueChangedFcn = createCallbackFcn(app, @SetPathEditFieldFnc, true);
            app.OutputsetpathEditField.Tooltip = {'Set a custom path for preprocessed EEGs stored in .set format. '; 'This path will override the default Output Path '};
            app.OutputsetpathEditField.Position = [121 160 177 22];

            % Create OutputcsvpathEditFieldLabel
            app.OutputcsvpathEditFieldLabel = uilabel(app.PathsTab);
            app.OutputcsvpathEditFieldLabel.HorizontalAlignment = 'right';
            app.OutputcsvpathEditFieldLabel.Position = [16 122 90 22];
            app.OutputcsvpathEditFieldLabel.Text = 'Output csv path';

            % Create OutputcsvpathEditField
            app.OutputcsvpathEditField = uieditfield(app.PathsTab, 'text');
            app.OutputcsvpathEditField.ValueChangedFcn = createCallbackFcn(app, @SetPathEditFieldFnc, true);
            app.OutputcsvpathEditField.Tooltip = {'Set a custom path for the EEGs marker files format. '; 'This path will override the default Output Path '};
            app.OutputcsvpathEditField.Position = [121 122 177 22];

            % Create EEGlabpathEditFieldLabel
            app.EEGlabpathEditFieldLabel = uilabel(app.PathsTab);
            app.EEGlabpathEditFieldLabel.HorizontalAlignment = 'right';
            app.EEGlabpathEditFieldLabel.Position = [422 370 74 22];
            app.EEGlabpathEditFieldLabel.Text = 'EEGlab path';

            % Create EEGlabpathEditField
            app.EEGlabpathEditField = uieditfield(app.PathsTab, 'text');
            app.EEGlabpathEditField.ValueChangedFcn = createCallbackFcn(app, @SetPathEditFieldFnc, true);
            app.EEGlabpathEditField.Tooltip = {'Set the path to eeglab. Not necessary to give if eeglab is already included in your search path.'; 'The button check EEGLab will have a green text in such a case.'};
            app.EEGlabpathEditField.Position = [511 370 150 22];

            % Create DiagnosticFolderNameEditFieldLabel
            app.DiagnosticFolderNameEditFieldLabel = uilabel(app.PathsTab);
            app.DiagnosticFolderNameEditFieldLabel.HorizontalAlignment = 'right';
            app.DiagnosticFolderNameEditFieldLabel.Position = [422 227 75 28];
            app.DiagnosticFolderNameEditFieldLabel.Text = {'Diagnostic'; 'Folder Name'};

            % Create DiagnosticFolderNameEditField
            app.DiagnosticFolderNameEditField = uieditfield(app.PathsTab, 'text');
            app.DiagnosticFolderNameEditField.ValueChangedFcn = createCallbackFcn(app, @SetPathEditFieldFnc, true);
            app.DiagnosticFolderNameEditField.Tooltip = {'set the name to the folder with extra diagnostic test, if it exists'};
            app.DiagnosticFolderNameEditField.Position = [512 233 150 22];

            % Create SetDatasetPathButton
            app.SetDatasetPathButton = uibutton(app.PathsTab, 'push');
            app.SetDatasetPathButton.ButtonPushedFcn = createCallbackFcn(app, @SetPathButtonFnc, true);
            app.SetDatasetPathButton.Tooltip = {'Click here to open a path selection window'};
            app.SetDatasetPathButton.Position = [316 370 65 22];
            app.SetDatasetPathButton.Text = 'Set Path';

            % Create SetOutputPathButton
            app.SetOutputPathButton = uibutton(app.PathsTab, 'push');
            app.SetOutputPathButton.ButtonPushedFcn = createCallbackFcn(app, @SetPathButtonFnc, true);
            app.SetOutputPathButton.Tooltip = {'Click here to open a path selection window'};
            app.SetOutputPathButton.Position = [316 233 65 22];
            app.SetOutputPathButton.Text = 'Set Path';

            % Create SetOutputMatPathButton
            app.SetOutputMatPathButton = uibutton(app.PathsTab, 'push');
            app.SetOutputMatPathButton.ButtonPushedFcn = createCallbackFcn(app, @SetPathButtonFnc, true);
            app.SetOutputMatPathButton.Tooltip = {'Click here to open a path selection window'};
            app.SetOutputMatPathButton.Position = [316 198 65 22];
            app.SetOutputMatPathButton.Text = 'Set Path';

            % Create SetOutputSetPathButton
            app.SetOutputSetPathButton = uibutton(app.PathsTab, 'push');
            app.SetOutputSetPathButton.ButtonPushedFcn = createCallbackFcn(app, @SetPathButtonFnc, true);
            app.SetOutputSetPathButton.Tooltip = {'Click here to open a path selection window'};
            app.SetOutputSetPathButton.Position = [316 160 65 22];
            app.SetOutputSetPathButton.Text = 'Set Path';

            % Create SetOutputCsvPathButton
            app.SetOutputCsvPathButton = uibutton(app.PathsTab, 'push');
            app.SetOutputCsvPathButton.ButtonPushedFcn = createCallbackFcn(app, @SetPathButtonFnc, true);
            app.SetOutputCsvPathButton.Tooltip = {'Click here to open a path selection window'};
            app.SetOutputCsvPathButton.Position = [316 122 65 22];
            app.SetOutputCsvPathButton.Text = 'Set Path';

            % Create SetEEGLabPathButton
            app.SetEEGLabPathButton = uibutton(app.PathsTab, 'push');
            app.SetEEGLabPathButton.ButtonPushedFcn = createCallbackFcn(app, @SetPathButtonFnc, true);
            app.SetEEGLabPathButton.Tooltip = {'Click here to open a path selection window'};
            app.SetEEGLabPathButton.Position = [679 370 65 22];
            app.SetEEGLabPathButton.Text = 'Set Path';

            % Create CheckEEGLabButton
            app.CheckEEGLabButton = uibutton(app.PathsTab, 'push');
            app.CheckEEGLabButton.ButtonPushedFcn = createCallbackFcn(app, @CheckEEGLabLaunch, true);
            app.CheckEEGLabButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CheckEEGLabButton.FontColor = [1 0 0];
            app.CheckEEGLabButton.Tooltip = {'Click here to launch an automatic search of the eeglab path or check the given one. '; 'If this button will disable, it means that eeglab was added correctly to your search path.'};
            app.CheckEEGLabButton.Position = [676 317 72 36];
            app.CheckEEGLabButton.Text = {'Check '; 'EEGLab'};

            % Create PathInfoGeneric
            app.PathInfoGeneric = uilabel(app.PathsTab);
            app.PathInfoGeneric.HorizontalAlignment = 'center';
            app.PathInfoGeneric.FontSize = 14;
            app.PathInfoGeneric.FontColor = [0 0.4471 0.7412];
            app.PathInfoGeneric.Position = [560 55 160 122];
            app.PathInfoGeneric.Text = {'NOTE:'; 'At least dataset path and'; ' output path must be set.'; ''; 'EEGlab path must be '; 'added if not available '; 'in your search path list'};

            % Create PreprocessingTab
            app.PreprocessingTab = uitab(app.TabGroup);
            app.PreprocessingTab.Title = 'Preprocessing';
            app.PreprocessingTab.BackgroundColor = [0.8588 0.9608 0.9882];

            % Create BackButton_3
            app.BackButton_3 = uibutton(app.PreprocessingTab, 'push');
            app.BackButton_3.ButtonPushedFcn = createCallbackFcn(app, @BackButtonPushed, true);
            app.BackButton_3.Position = [531 10 100 22];
            app.BackButton_3.Text = 'Back';

            % Create NextButton_4
            app.NextButton_4 = uibutton(app.PreprocessingTab, 'push');
            app.NextButton_4.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton_4.Position = [649 10 100 22];
            app.NextButton_4.Text = 'Next';

            % Create LowFreqEditFieldLabel
            app.LowFreqEditFieldLabel = uilabel(app.PreprocessingTab);
            app.LowFreqEditFieldLabel.HorizontalAlignment = 'right';
            app.LowFreqEditFieldLabel.Position = [66 125 56 22];
            app.LowFreqEditFieldLabel.Text = 'Low Freq';

            % Create LowFreqEditField
            app.LowFreqEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.LowFreqEditField.Limits = [0 Inf];
            app.LowFreqEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.LowFreqEditField.Tooltip = {'The low frequency of the bandpass filter. Every frequency lower than this value will be filtered with a FIR filter'};
            app.LowFreqEditField.Position = [137 125 52 22];

            % Create HighFreqEditFieldLabel
            app.HighFreqEditFieldLabel = uilabel(app.PreprocessingTab);
            app.HighFreqEditFieldLabel.HorizontalAlignment = 'right';
            app.HighFreqEditFieldLabel.Position = [64 103 58 22];
            app.HighFreqEditFieldLabel.Text = 'High Freq';

            % Create HighFreqEditField
            app.HighFreqEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.HighFreqEditField.Limits = [0 Inf];
            app.HighFreqEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.HighFreqEditField.Tooltip = {'The low frequency of the bandpass filter. Every frequency greater than this value will be filtered with a FIR filter'};
            app.HighFreqEditField.Position = [137 103 52 22];

            % Create StandardReferenceEditFieldLabel
            app.StandardReferenceEditFieldLabel = uilabel(app.PreprocessingTab);
            app.StandardReferenceEditFieldLabel.HorizontalAlignment = 'right';
            app.StandardReferenceEditFieldLabel.Position = [586 79 61 28];
            app.StandardReferenceEditFieldLabel.Text = {'Standard'; 'Reference'};

            % Create StandardReferenceEditField
            app.StandardReferenceEditField = uieditfield(app.PreprocessingTab, 'text');
            app.StandardReferenceEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.StandardReferenceEditField.Tooltip = {'The reference to use during rereferencing. It must be COMMON or any other possible channel in the GSN or international system'};
            app.StandardReferenceEditField.Position = [662 85 67 22];

            % Create InterpolationMethodEditFieldLabel
            app.InterpolationMethodEditFieldLabel = uilabel(app.PreprocessingTab);
            app.InterpolationMethodEditFieldLabel.HorizontalAlignment = 'right';
            app.InterpolationMethodEditFieldLabel.Position = [573 165 72 28];
            app.InterpolationMethodEditFieldLabel.Text = {'Interpolation'; 'Method'};

            % Create InterpolationMethodEditField
            app.InterpolationMethodEditField = uieditfield(app.PreprocessingTab, 'text');
            app.InterpolationMethodEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.InterpolationMethodEditField.Tooltip = {'The method used during channel interpolation. It must be invdist, spherical, or spacetime'};
            app.InterpolationMethodEditField.Position = [660 171 67 22];

            % Create PreprocessingGeneralHelp
            app.PreprocessingGeneralHelp = uibutton(app.PreprocessingTab, 'push');
            app.PreprocessingGeneralHelp.ButtonPushedFcn = createCallbackFcn(app, @HelpFnc, true);
            app.PreprocessingGeneralHelp.Position = [25 10 49 22];
            app.PreprocessingGeneralHelp.Text = 'Help';

            % Create PreprocessingstatustocheckLabel
            app.PreprocessingstatustocheckLabel = uilabel(app.PreprocessingTab);
            app.PreprocessingstatustocheckLabel.FontSize = 13;
            app.PreprocessingstatustocheckLabel.FontWeight = 'bold';
            app.PreprocessingstatustocheckLabel.Position = [121 10 199 22];
            app.PreprocessingstatustocheckLabel.Text = 'Preprocessing status: to check';

            % Create PreprocessingStatus
            app.PreprocessingStatus = uilamp(app.PreprocessingTab);
            app.PreprocessingStatus.Position = [91 11 20 20];
            app.PreprocessingStatus.Color = [1 0 0];

            % Create FlatlineCriterionLabel
            app.FlatlineCriterionLabel = uilabel(app.PreprocessingTab);
            app.FlatlineCriterionLabel.HorizontalAlignment = 'right';
            app.FlatlineCriterionLabel.Position = [564 358 93 22];
            app.FlatlineCriterionLabel.Text = 'Flatline Criterion';

            % Create FlatlineCriterionEditField
            app.FlatlineCriterionEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.FlatlineCriterionEditField.Limits = [0 Inf];
            app.FlatlineCriterionEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.FlatlineCriterionEditField.Tooltip = {'Maximum tolerated flatline duration. In seconds. If a channel has a longer flatline than this, it will be considered abnormal. '};
            app.FlatlineCriterionEditField.Position = [672 358 52 22];

            % Create ChannelCriterionLabel
            app.ChannelCriterionLabel = uilabel(app.PreprocessingTab);
            app.ChannelCriterionLabel.HorizontalAlignment = 'right';
            app.ChannelCriterionLabel.Position = [558 336 99 22];
            app.ChannelCriterionLabel.Text = 'Channel Criterion';

            % Create ChannelCriterionEditField
            app.ChannelCriterionEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.ChannelCriterionEditField.Limits = [0 1];
            app.ChannelCriterionEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.ChannelCriterionEditField.Tooltip = {'Minimum channel correlation. If a channel is correlated at less than this value to a reconstruction of it based on other channels, it is considered abnormal in the given time window. This method requires that channel locations are available and roughly correct; otherwise a fallback criterio will be used. '};
            app.ChannelCriterionEditField.Position = [672 336 52 22];

            % Create LineNoiseCriterionLabel
            app.LineNoiseCriterionLabel = uilabel(app.PreprocessingTab);
            app.LineNoiseCriterionLabel.HorizontalAlignment = 'right';
            app.LineNoiseCriterionLabel.Position = [546 314 111 22];
            app.LineNoiseCriterionLabel.Text = 'Line Noise Criterion';

            % Create LineNoiseCriterionEditField
            app.LineNoiseCriterionEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.LineNoiseCriterionEditField.Limits = [0 Inf];
            app.LineNoiseCriterionEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.LineNoiseCriterionEditField.Tooltip = {'If a channel has more line noise relative to its signal than this value, in standard deviations based on the total channel population, it is considered abnormal. '};
            app.LineNoiseCriterionEditField.Position = [672 314 52 22];

            % Create WindowCriterionLabel
            app.WindowCriterionLabel = uilabel(app.PreprocessingTab);
            app.WindowCriterionLabel.HorizontalAlignment = 'right';
            app.WindowCriterionLabel.Position = [560 292 97 22];
            app.WindowCriterionLabel.Text = 'Window Criterion';

            % Create WindowCriterionEditField
            app.WindowCriterionEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.WindowCriterionEditField.Limits = [0 Inf];
            app.WindowCriterionEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.WindowCriterionEditField.Tooltip = {'Criterion for removing time windows that were not repaired completely. This may happen if the artifact in a window was composed of too many simultaneous uncorrelated sources (for example, extreme movements such as jumps). This is the maximum fraction of contaminated channels that are tolerated in the final output data for each considered window. Generally a lower value makes thecriterion more aggressive. Reasonable range: 0.05 (very aggressive) to 0.3 (very lax).'};
            app.WindowCriterionEditField.Position = [672 292 52 22];

            % Create BurstCriterionLabel
            app.BurstCriterionLabel = uilabel(app.PreprocessingTab);
            app.BurstCriterionLabel.HorizontalAlignment = 'right';
            app.BurstCriterionLabel.Position = [575 270 82 22];
            app.BurstCriterionLabel.Text = 'Burst Criterion';

            % Create BurstCriterionEditField
            app.BurstCriterionEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.BurstCriterionEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.BurstCriterionEditField.Tooltip = {'Standard deviation cutoff for removal of bursts (via ASR). Data portions whose variance is larger than this threshold relative to the calibration data are'; 'considered missing data and will be removed. The most aggressive value that can be used without losing much EEG is 3. For new users it is recommended to at first visually inspect the difference between the original and cleaned data to'; 'get a sense of the removed content at various levels. An agressive value is 5 and a quite conservative value is 20.'};
            app.BurstCriterionEditField.Position = [672 270 52 22];

            % Create DoubleASRThresholdLabel
            app.DoubleASRThresholdLabel = uilabel(app.PreprocessingTab);
            app.DoubleASRThresholdLabel.HorizontalAlignment = 'right';
            app.DoubleASRThresholdLabel.Position = [529 380 128 22];
            app.DoubleASRThresholdLabel.Text = 'Double ASR Threshold';

            % Create DoubleASRThresholdEditField
            app.DoubleASRThresholdEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.DoubleASRThresholdEditField.Limits = [0 Inf];
            app.DoubleASRThresholdEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.DoubleASRThresholdEditField.Position = [672 380 52 22];

            % Create BurstRejectionLabel
            app.BurstRejectionLabel = uilabel(app.PreprocessingTab);
            app.BurstRejectionLabel.HorizontalAlignment = 'right';
            app.BurstRejectionLabel.Position = [571 247 87 22];
            app.BurstRejectionLabel.Text = 'Burst Rejection';

            % Create BurstRejectionSwitch
            app.BurstRejectionSwitch = uiswitch(app.PreprocessingTab, 'slider');
            app.BurstRejectionSwitch.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.BurstRejectionSwitch.Tooltip = {'''on'' or ''off''. If ''on'' reject portions of data containing burst instead of correcting them using ASR.'};
            app.BurstRejectionSwitch.FontSize = 10;
            app.BurstRejectionSwitch.Position = [682 249 40 18];
            app.BurstRejectionSwitch.Value = 'On';

            % Create TypeEditFieldLabel
            app.TypeEditFieldLabel = uilabel(app.PreprocessingTab);
            app.TypeEditFieldLabel.HorizontalAlignment = 'right';
            app.TypeEditFieldLabel.Position = [339 376 32 22];
            app.TypeEditFieldLabel.Text = 'Type';

            % Create TypeEditField
            app.TypeEditField = uieditfield(app.PreprocessingTab, 'text');
            app.TypeEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.TypeEditField.Tooltip = {'The ICA method to use. Must be fastica or runica. For fastica, remember to install the proper plugin'};
            app.TypeEditField.Position = [386 376 52 22];

            % Create NonLinearityLabel
            app.NonLinearityLabel = uilabel(app.PreprocessingTab);
            app.NonLinearityLabel.HorizontalAlignment = 'right';
            app.NonLinearityLabel.Position = [295 354 76 22];
            app.NonLinearityLabel.Text = 'Non Linearity';

            % Create NonLinearityEditField
            app.NonLinearityEditField = uieditfield(app.PreprocessingTab, 'text');
            app.NonLinearityEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.NonLinearityEditField.Tooltip = {'The type of linearity to use for fastica. It can be pow3, tanh, gauss or skew'};
            app.NonLinearityEditField.Position = [386 354 52 22];

            % Create ICNumberEditFieldLabel
            app.ICNumberEditFieldLabel = uilabel(app.PreprocessingTab);
            app.ICNumberEditFieldLabel.HorizontalAlignment = 'right';
            app.ICNumberEditFieldLabel.Position = [307 332 64 22];
            app.ICNumberEditFieldLabel.Text = 'IC Number';

            % Create ICNumberEditField
            app.ICNumberEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.ICNumberEditField.Limits = [0 Inf];
            app.ICNumberEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.ICNumberEditField.Tooltip = {'The number of component to calculate, if possible. Use zero to let the algorithm choose the number of components'};
            app.ICNumberEditField.Position = [386 332 52 22];

            % Create InitialsegmentEditFieldLabel
            app.InitialsegmentEditFieldLabel = uilabel(app.PreprocessingTab);
            app.InitialsegmentEditFieldLabel.HorizontalAlignment = 'right';
            app.InitialsegmentEditFieldLabel.Position = [28 381 83 22];
            app.InitialsegmentEditFieldLabel.Text = 'Initial segment';

            % Create InitialsegmentEditField
            app.InitialsegmentEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.InitialsegmentEditField.Limits = [0 Inf];
            app.InitialsegmentEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.InitialsegmentEditField.Tooltip = {'The number of seconds to remove from the start of each EEG.'; 'For example, 1 will remove the first second from each EEG record'};
            app.InitialsegmentEditField.Position = [126 381 52 22];

            % Create FinalsegmentEditFieldLabel
            app.FinalsegmentEditFieldLabel = uilabel(app.PreprocessingTab);
            app.FinalsegmentEditFieldLabel.HorizontalAlignment = 'right';
            app.FinalsegmentEditFieldLabel.Position = [30 359 81 22];
            app.FinalsegmentEditFieldLabel.Text = 'Final segment';

            % Create FinalsegmentEditField
            app.FinalsegmentEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.FinalsegmentEditField.Limits = [0 Inf];
            app.FinalsegmentEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.FinalsegmentEditField.Tooltip = {'The number of seconds to remove at the end of each EEG.'; 'For example, 1 will remove the last second from each EEG record'};
            app.FinalsegmentEditField.Position = [126 359 52 22];

            % Create SamplingRateLabel
            app.SamplingRateLabel = uilabel(app.PreprocessingTab);
            app.SamplingRateLabel.HorizontalAlignment = 'right';
            app.SamplingRateLabel.Position = [32 240 84 22];
            app.SamplingRateLabel.Text = 'Sampling Rate';

            % Create SamplingRateEditField
            app.SamplingRateEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.SamplingRateEditField.Limits = [0 Inf];
            app.SamplingRateEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.SamplingRateEditField.Tooltip = {'The sampling rate (given in Hz) to use during resampling. Every EEG will be resampled using this value'};
            app.SamplingRateEditField.Position = [131 240 52 22];

            % Create BrainEditFieldLabel
            app.BrainEditFieldLabel = uilabel(app.PreprocessingTab);
            app.BrainEditFieldLabel.HorizontalAlignment = 'right';
            app.BrainEditFieldLabel.Position = [337 192 34 22];
            app.BrainEditFieldLabel.Text = 'Brain';

            % Create BrainEditField
            app.BrainEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.BrainEditField.Limits = [0 1];
            app.BrainEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.BrainEditField.Tooltip = {'Rejection threshold for the ICLabel algorithm brain component.'; 'it must be a value  in range [0, 1]. Components with a brain value lower than this one will be rejected. Suggested [0, 0.2] range.'};
            app.BrainEditField.Position = [386 192 52 22];

            % Create MuscleLabel
            app.MuscleLabel = uilabel(app.PreprocessingTab);
            app.MuscleLabel.HorizontalAlignment = 'right';
            app.MuscleLabel.Position = [327 170 44 22];
            app.MuscleLabel.Text = 'Muscle';

            % Create MuscleEditField
            app.MuscleEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.MuscleEditField.Limits = [0 1];
            app.MuscleEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.MuscleEditField.Tooltip = {'Rejection threshold for the ICLabel algorithm Muscle artifact.'; 'it must be a value  in range [0, 1]. Components with a  muscle value greater than this one will be rejected. Suggested [0.7, 0.9] range.'};
            app.MuscleEditField.Position = [386 170 52 22];

            % Create EyeEditFieldLabel
            app.EyeEditFieldLabel = uilabel(app.PreprocessingTab);
            app.EyeEditFieldLabel.HorizontalAlignment = 'right';
            app.EyeEditFieldLabel.Position = [345 148 26 22];
            app.EyeEditFieldLabel.Text = 'Eye';

            % Create EyeEditField
            app.EyeEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.EyeEditField.Limits = [0 1];
            app.EyeEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.EyeEditField.Tooltip = {'Rejection threshold for the ICLabel algorithm Eye artifact.'; 'it must be a value  in range [0, 1]. Components with a n eye value greater than this one will be rejected. Suggested [0.7, 0.9] range.'};
            app.EyeEditField.Position = [386 148 52 22];

            % Create ChannelNoiseLabel
            app.ChannelNoiseLabel = uilabel(app.PreprocessingTab);
            app.ChannelNoiseLabel.HorizontalAlignment = 'right';
            app.ChannelNoiseLabel.Position = [287 82 84 22];
            app.ChannelNoiseLabel.Text = 'Channel Noise';

            % Create ChannelNoiseEditField
            app.ChannelNoiseEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.ChannelNoiseEditField.Limits = [0 1];
            app.ChannelNoiseEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.ChannelNoiseEditField.Tooltip = {'Rejection threshold for the ICLabel algorithm Channel artifact.'; 'it must be a value  in range [0, 1]. Components with a  channel value greater than this one will be rejected. Suggested [0.7, 0.9] range.'};
            app.ChannelNoiseEditField.Position = [386 82 52 22];

            % Create HeartEditFieldLabel
            app.HeartEditFieldLabel = uilabel(app.PreprocessingTab);
            app.HeartEditFieldLabel.HorizontalAlignment = 'right';
            app.HeartEditFieldLabel.Position = [336 126 35 22];
            app.HeartEditFieldLabel.Text = 'Heart';

            % Create HeartEditField
            app.HeartEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.HeartEditField.Limits = [0 1];
            app.HeartEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.HeartEditField.Tooltip = {'Rejection threshold for the ICLabel algorithm Heart artifact.'; 'it must be a value  in range [0, 1]. Components with a  heart value greater than this one will be rejected. Suggested [0.7, 0.9] range.'};
            app.HeartEditField.Position = [386 126 52 22];

            % Create LineNoiseEditFieldLabel
            app.LineNoiseEditFieldLabel = uilabel(app.PreprocessingTab);
            app.LineNoiseEditFieldLabel.HorizontalAlignment = 'right';
            app.LineNoiseEditFieldLabel.Position = [309 104 62 22];
            app.LineNoiseEditFieldLabel.Text = 'Line Noise';

            % Create LineNoiseEditField
            app.LineNoiseEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.LineNoiseEditField.Limits = [0 1];
            app.LineNoiseEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.LineNoiseEditField.Tooltip = {'Rejection threshold for the ICLabel algorithm Line artifact.'; 'it must be a value  in range [0, 1]. Components with a line noise value greater than this one will be rejected. Suggested [0.7, 0.9] range.'};
            app.LineNoiseEditField.Position = [386 104 52 22];

            % Create OtherEditFieldLabel
            app.OtherEditFieldLabel = uilabel(app.PreprocessingTab);
            app.OtherEditFieldLabel.HorizontalAlignment = 'right';
            app.OtherEditFieldLabel.Position = [335 60 36 22];
            app.OtherEditFieldLabel.Text = 'Other';

            % Create OtherEditField
            app.OtherEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.OtherEditField.Limits = [0 1];
            app.OtherEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.OtherEditField.Tooltip = {'Rejection threshold for the ICLabel algorithm Other artifact.'; 'it must be a value  in range [0, 1]. Components with an other value greater than this one will be rejected. Suggested [0.7, 0.9] range.'};
            app.OtherEditField.Position = [386 60 52 22];

            % Create SegmentRemovalLabel
            app.SegmentRemovalLabel = uilabel(app.PreprocessingTab);
            app.SegmentRemovalLabel.FontWeight = 'bold';
            app.SegmentRemovalLabel.FontColor = [0 0.4471 0.7412];
            app.SegmentRemovalLabel.Position = [30 411 176 22];
            app.SegmentRemovalLabel.Text = '=== (1) Segment Removal ===';

            % Create ResamplingLabel
            app.ResamplingLabel = uilabel(app.PreprocessingTab);
            app.ResamplingLabel.FontWeight = 'bold';
            app.ResamplingLabel.FontColor = [0 0.4471 0.7412];
            app.ResamplingLabel.Position = [35 270 182 22];
            app.ResamplingLabel.Text = '====== (2) Resampling ======';

            % Create FilteringLabel
            app.FilteringLabel = uilabel(app.PreprocessingTab);
            app.FilteringLabel.FontWeight = 'bold';
            app.FilteringLabel.FontColor = [0 0.4471 0.7412];
            app.FilteringLabel.Position = [40 155 176 22];
            app.FilteringLabel.Text = '======= (3) Filtering =======';

            % Create ICRejectionLabel
            app.ICRejectionLabel = uilabel(app.PreprocessingTab);
            app.ICRejectionLabel.FontWeight = 'bold';
            app.ICRejectionLabel.FontColor = [0 0.4471 0.7412];
            app.ICRejectionLabel.Position = [282 271 184 22];
            app.ICRejectionLabel.Text = '====== (5) IC Rejection ======';

            % Create ICADecompositionLabel
            app.ICADecompositionLabel = uilabel(app.PreprocessingTab);
            app.ICADecompositionLabel.FontWeight = 'bold';
            app.ICADecompositionLabel.FontColor = [0 0.4471 0.7412];
            app.ICADecompositionLabel.Position = [282 411 183 22];
            app.ICADecompositionLabel.Text = '=== (4) ICA Decomposition ===';

            % Create ASRLabel
            app.ASRLabel = uilabel(app.PreprocessingTab);
            app.ASRLabel.FontWeight = 'bold';
            app.ASRLabel.FontColor = [0 0.4471 0.7412];
            app.ASRLabel.Position = [551 411 182 22];
            app.ASRLabel.Text = '========= (6) ASR =========';

            % Create RereferencingLabel
            app.RereferencingLabel = uilabel(app.PreprocessingTab);
            app.RereferencingLabel.FontWeight = 'bold';
            app.RereferencingLabel.FontColor = [0 0.4471 0.7412];
            app.RereferencingLabel.Position = [551 115 196 22];
            app.RereferencingLabel.Text = '====== (8) Rereferencing ======';

            % Create ChannelInterpolationLabel
            app.ChannelInterpolationLabel = uilabel(app.PreprocessingTab);
            app.ChannelInterpolationLabel.FontWeight = 'bold';
            app.ChannelInterpolationLabel.FontColor = [0 0.4471 0.7412];
            app.ChannelInterpolationLabel.Position = [551 201 197 22];
            app.ChannelInterpolationLabel.Text = '=== (7) Channel Interpolation ===';

            % Create MaraThresholdEditFieldLabel
            app.MaraThresholdEditFieldLabel = uilabel(app.PreprocessingTab);
            app.MaraThresholdEditFieldLabel.HorizontalAlignment = 'right';
            app.MaraThresholdEditFieldLabel.Position = [281 214 90 22];
            app.MaraThresholdEditFieldLabel.Text = 'Mara Threshold';

            % Create MaraThresholdEditField
            app.MaraThresholdEditField = uieditfield(app.PreprocessingTab, 'numeric');
            app.MaraThresholdEditField.Limits = [0 1];
            app.MaraThresholdEditField.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.MaraThresholdEditField.Tooltip = {'Rejection threshold for the MARA algorithm.'; 'it must be a value  in range [0, 1]. Values near 1 will make MARA more conservative (less rejection), values closed to 0 the opposite (more rejection)'};
            app.MaraThresholdEditField.Position = [386 214 52 22];

            % Create AlgorithmSwitchLabel
            app.AlgorithmSwitchLabel = uilabel(app.PreprocessingTab);
            app.AlgorithmSwitchLabel.HorizontalAlignment = 'right';
            app.AlgorithmSwitchLabel.Position = [287 236 56 22];
            app.AlgorithmSwitchLabel.Text = 'Algorithm';

            % Create AlgorithmSwitch
            app.AlgorithmSwitch = uiswitch(app.PreprocessingTab, 'slider');
            app.AlgorithmSwitch.Items = {'MARA', 'ICLabel'};
            app.AlgorithmSwitch.ValueChangedFcn = createCallbackFcn(app, @SetParamsFnc, true);
            app.AlgorithmSwitch.Tooltip = {'The IC Rejection algorithm to use. MARA rejects components using a binary SVM classifier. ICLabel distinguishes between different artifacts based on a neural network multi-class classifier'};
            app.AlgorithmSwitch.FontSize = 10;
            app.AlgorithmSwitch.Position = [393 238 40 18];
            app.AlgorithmSwitch.Value = 'MARA';

            % Create sLabel
            app.sLabel = uilabel(app.PreprocessingTab);
            app.sLabel.FontSize = 13;
            app.sLabel.Position = [188 381 25 22];
            app.sLabel.Text = 's';

            % Create sLabel_2
            app.sLabel_2 = uilabel(app.PreprocessingTab);
            app.sLabel_2.FontSize = 13;
            app.sLabel_2.Position = [188 360 25 22];
            app.sLabel_2.Text = 's';

            % Create HzLabel
            app.HzLabel = uilabel(app.PreprocessingTab);
            app.HzLabel.FontSize = 13;
            app.HzLabel.Position = [194 240 25 22];
            app.HzLabel.Text = 'Hz';

            % Create HzLabel_2
            app.HzLabel_2 = uilabel(app.PreprocessingTab);
            app.HzLabel_2.FontSize = 13;
            app.HzLabel_2.Position = [195 125 25 22];
            app.HzLabel_2.Text = 'Hz';

            % Create HzLabel_3
            app.HzLabel_3 = uilabel(app.PreprocessingTab);
            app.HzLabel_3.FontSize = 13;
            app.HzLabel_3.Position = [195 104 25 22];
            app.HzLabel_3.Text = 'Hz';

            % Create uVLabel
            app.uVLabel = uilabel(app.PreprocessingTab);
            app.uVLabel.FontSize = 13;
            app.uVLabel.Position = [729 381 25 22];
            app.uVLabel.Text = 'uV';

            % Create SelectionTab
            app.SelectionTab = uitab(app.TabGroup);
            app.SelectionTab.Title = 'Selection';
            app.SelectionTab.BackgroundColor = [0.8588 0.9608 0.9882];

            % Create BackButton_4
            app.BackButton_4 = uibutton(app.SelectionTab, 'push');
            app.BackButton_4.ButtonPushedFcn = createCallbackFcn(app, @BackButtonPushed, true);
            app.BackButton_4.Position = [531 10 100 22];
            app.BackButton_4.Text = 'Back';

            % Create NextButton_5
            app.NextButton_5 = uibutton(app.SelectionTab, 'push');
            app.NextButton_5.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton_5.Position = [649 10 100 22];
            app.NextButton_5.Text = 'Next';

            % Create SubjectInitialEditFieldLabel
            app.SubjectInitialEditFieldLabel = uilabel(app.SelectionTab);
            app.SubjectInitialEditFieldLabel.HorizontalAlignment = 'right';
            app.SubjectInitialEditFieldLabel.Position = [57 293 77 22];
            app.SubjectInitialEditFieldLabel.Text = 'Subject Initial';

            % Create SubjectInitialEditField
            app.SubjectInitialEditField = uieditfield(app.SelectionTab, 'numeric');
            app.SubjectInitialEditField.Limits = [0 Inf];
            app.SubjectInitialEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.SubjectInitialEditField.Tooltip = {'The starting index of the slice selection at the subject level. 0 means start with the first available subject'};
            app.SubjectInitialEditField.Position = [149 293 52 22];

            % Create SubjectFinalEditFieldLabel
            app.SubjectFinalEditFieldLabel = uilabel(app.SelectionTab);
            app.SubjectFinalEditFieldLabel.HorizontalAlignment = 'right';
            app.SubjectFinalEditFieldLabel.Position = [59 271 75 22];
            app.SubjectFinalEditFieldLabel.Text = 'Subject Final';

            % Create SubjectFinalEditField
            app.SubjectFinalEditField = uieditfield(app.SelectionTab, 'numeric');
            app.SubjectFinalEditField.Limits = [0 Inf];
            app.SubjectFinalEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.SubjectFinalEditField.Tooltip = {'The ending index of the slice selection at the subject level. 0 means end with the last available subject'};
            app.SubjectFinalEditField.Position = [149 271 52 22];

            % Create SessionInitialEditFieldLabel
            app.SessionInitialEditFieldLabel = uilabel(app.SelectionTab);
            app.SessionInitialEditFieldLabel.HorizontalAlignment = 'right';
            app.SessionInitialEditFieldLabel.Position = [54 213 80 22];
            app.SessionInitialEditFieldLabel.Text = 'Session Initial';

            % Create SessionInitialEditField
            app.SessionInitialEditField = uieditfield(app.SelectionTab, 'numeric');
            app.SessionInitialEditField.Limits = [0 Inf];
            app.SessionInitialEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.SessionInitialEditField.Tooltip = {'The starting index of the slice selection at the session level. 0 means start with the first available session'};
            app.SessionInitialEditField.Position = [149 213 52 22];

            % Create SessionFinalEditFieldLabel
            app.SessionFinalEditFieldLabel = uilabel(app.SelectionTab);
            app.SessionFinalEditFieldLabel.HorizontalAlignment = 'right';
            app.SessionFinalEditFieldLabel.Position = [56 191 78 22];
            app.SessionFinalEditFieldLabel.Text = 'Session Final';

            % Create SessionFinalEditField
            app.SessionFinalEditField = uieditfield(app.SelectionTab, 'numeric');
            app.SessionFinalEditField.Limits = [0 Inf];
            app.SessionFinalEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.SessionFinalEditField.Tooltip = {'The ending index of the slice selection at the session level. 0 means end with the last available session'};
            app.SessionFinalEditField.Position = [149 191 52 22];

            % Create ObjectInitialEditFieldLabel
            app.ObjectInitialEditFieldLabel = uilabel(app.SelectionTab);
            app.ObjectInitialEditFieldLabel.HorizontalAlignment = 'right';
            app.ObjectInitialEditFieldLabel.Position = [62 136 72 22];
            app.ObjectInitialEditFieldLabel.Text = 'Object Initial';

            % Create ObjectInitialEditField
            app.ObjectInitialEditField = uieditfield(app.SelectionTab, 'numeric');
            app.ObjectInitialEditField.Limits = [0 Inf];
            app.ObjectInitialEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.ObjectInitialEditField.Tooltip = {'The starting index of the slice selection at the object level. 0 means start with the first available object'};
            app.ObjectInitialEditField.Position = [149 136 52 22];

            % Create ObjectFinalEditFieldLabel
            app.ObjectFinalEditFieldLabel = uilabel(app.SelectionTab);
            app.ObjectFinalEditFieldLabel.HorizontalAlignment = 'right';
            app.ObjectFinalEditFieldLabel.Position = [64 114 70 22];
            app.ObjectFinalEditFieldLabel.Text = 'Object Final';

            % Create ObjectFinalEditField
            app.ObjectFinalEditField = uieditfield(app.SelectionTab, 'numeric');
            app.ObjectFinalEditField.Limits = [0 Inf];
            app.ObjectFinalEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.ObjectFinalEditField.Tooltip = {'The ending index of the slice selection at the object level. 0 means end with the last available object'};
            app.ObjectFinalEditField.Position = [149 114 52 22];

            % Create PerformSelectionSwitchLabel
            app.PerformSelectionSwitchLabel = uilabel(app.SelectionTab);
            app.PerformSelectionSwitchLabel.HorizontalAlignment = 'center';
            app.PerformSelectionSwitchLabel.Position = [314 425 100 22];
            app.PerformSelectionSwitchLabel.Text = 'Perform Selection';

            % Create PerformSelectionSwitch
            app.PerformSelectionSwitch = uiswitch(app.SelectionTab, 'slider');
            app.PerformSelectionSwitch.Items = {'On', 'Off'};
            app.PerformSelectionSwitch.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.PerformSelectionSwitch.Tooltip = {'Whether to select a subset of files or not. Not that if you turn it to on, you must also give some selection criteria.  '};
            app.PerformSelectionSwitch.Position = [343 396 45 20];

            % Create LabelNameEditFieldLabel
            app.LabelNameEditFieldLabel = uilabel(app.SelectionTab);
            app.LabelNameEditFieldLabel.HorizontalAlignment = 'right';
            app.LabelNameEditFieldLabel.Position = [272 293 70 22];
            app.LabelNameEditFieldLabel.Text = 'Label Name';

            % Create LabelNameEditField
            app.LabelNameEditField = uieditfield(app.SelectionTab, 'text');
            app.LabelNameEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.LabelNameEditField.Tooltip = {'The column name of the participant file to look for a selection'};
            app.LabelNameEditField.Position = [357 293 100 22];

            % Create LabelValueEditFieldLabel
            app.LabelValueEditFieldLabel = uilabel(app.SelectionTab);
            app.LabelValueEditFieldLabel.HorizontalAlignment = 'right';
            app.LabelValueEditFieldLabel.Position = [274 272 68 22];
            app.LabelValueEditFieldLabel.Text = 'Label Value';

            % Create LabelValueEditField
            app.LabelValueEditField = uieditfield(app.SelectionTab, 'text');
            app.LabelValueEditField.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.LabelValueEditField.Tooltip = {'The participant file columnn value to use for the selection. Subjects with this label will be included during the preprocessing'};
            app.LabelValueEditField.Position = [357 272 100 22];

            % Create SubjectstoTakeTextAreaLabel
            app.SubjectstoTakeTextAreaLabel = uilabel(app.SelectionTab);
            app.SubjectstoTakeTextAreaLabel.HorizontalAlignment = 'right';
            app.SubjectstoTakeTextAreaLabel.Position = [511 271 52 42];
            app.SubjectstoTakeTextAreaLabel.Text = {'Subjects'; 'to'; 'Take'};

            % Create SubjectstoTakeTextArea
            app.SubjectstoTakeTextArea = uitextarea(app.SelectionTab);
            app.SubjectstoTakeTextArea.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.SubjectstoTakeTextArea.Tooltip = {'Input a set of name parts to be used as selectors. Write only one part per line.'};
            app.SubjectstoTakeTextArea.Position = [578 255 150 60];
            app.SubjectstoTakeTextArea.Value = {'Input a set of name parts to be used as selectors. Write only one part per line.'};

            % Create SessionsToTakeTextAreaLabel
            app.SessionsToTakeTextAreaLabel = uilabel(app.SelectionTab);
            app.SessionsToTakeTextAreaLabel.HorizontalAlignment = 'right';
            app.SessionsToTakeTextAreaLabel.Position = [510 191 54 42];
            app.SessionsToTakeTextAreaLabel.Text = {'Sessions'; 'To'; 'Take'};

            % Create SessionsToTakeTextArea
            app.SessionsToTakeTextArea = uitextarea(app.SelectionTab);
            app.SessionsToTakeTextArea.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.SessionsToTakeTextArea.Tooltip = {'Input a set of name parts to be used as selectors. Write only one part per line.'};
            app.SessionsToTakeTextArea.Position = [579 175 150 60];
            app.SessionsToTakeTextArea.Value = {'Input a set of name parts to be used as selectors. Write only one part per line.'};

            % Create ObjectsToTakeTextAreaLabel
            app.ObjectsToTakeTextAreaLabel = uilabel(app.SelectionTab);
            app.ObjectsToTakeTextAreaLabel.HorizontalAlignment = 'right';
            app.ObjectsToTakeTextAreaLabel.Position = [519 103 46 42];
            app.ObjectsToTakeTextAreaLabel.Text = {'Objects'; 'To'; 'Take'};

            % Create ObjectsToTakeTextArea
            app.ObjectsToTakeTextArea = uitextarea(app.SelectionTab);
            app.ObjectsToTakeTextArea.ValueChangedFcn = createCallbackFcn(app, @SetSelectionFnc, true);
            app.ObjectsToTakeTextArea.Tooltip = {'Input a set of name parts to be used as selectors. Write only one part per line.'};
            app.ObjectsToTakeTextArea.Position = [580 87 150 60];
            app.ObjectsToTakeTextArea.Value = {'Input a set of name parts to be used as selectors. Write only one part per line.'};

            % Create SliceBasedLabel
            app.SliceBasedLabel = uilabel(app.SelectionTab);
            app.SliceBasedLabel.FontWeight = 'bold';
            app.SliceBasedLabel.FontColor = [0 0.4471 0.7412];
            app.SliceBasedLabel.Tooltip = {'Slice selection is performed after Label and name based selections. For example, if subject initial and final are respectively 2 and 5, the algorithm will select from the second to the fifth of the remaining subjects'};
            app.SliceBasedLabel.Position = [55 332 150 22];
            app.SliceBasedLabel.Text = '===== Slice Based =====';

            % Create LabelBased
            app.LabelBased = uilabel(app.SelectionTab);
            app.LabelBased.FontWeight = 'bold';
            app.LabelBased.FontColor = [0 0.4471 0.7412];
            app.LabelBased.Position = [299 332 153 22];
            app.LabelBased.Text = '===== Label Based =====';

            % Create NameBasedLabel
            app.NameBasedLabel = uilabel(app.SelectionTab);
            app.NameBasedLabel.FontWeight = 'bold';
            app.NameBasedLabel.FontColor = [0 0.4471 0.7412];
            app.NameBasedLabel.Position = [562 332 154 22];
            app.NameBasedLabel.Text = '===== Name Based =====';

            % Create SelectionGeneralHelp
            app.SelectionGeneralHelp = uibutton(app.SelectionTab, 'push');
            app.SelectionGeneralHelp.ButtonPushedFcn = createCallbackFcn(app, @HelpFnc, true);
            app.SelectionGeneralHelp.Position = [25 10 49 22];
            app.SelectionGeneralHelp.Text = 'Help';

            % Create SelectionstatustocheckLabel
            app.SelectionstatustocheckLabel = uilabel(app.SelectionTab);
            app.SelectionstatustocheckLabel.FontSize = 13;
            app.SelectionstatustocheckLabel.FontWeight = 'bold';
            app.SelectionstatustocheckLabel.Position = [122 10 166 22];
            app.SelectionstatustocheckLabel.Text = 'Selection status: to check';

            % Create SelectionStatus
            app.SelectionStatus = uilamp(app.SelectionTab);
            app.SelectionStatus.Position = [91 11 20 20];
            app.SelectionStatus.Color = [1 0 0];

            % Create RunPreprocessingTab
            app.RunPreprocessingTab = uitab(app.TabGroup);
            app.RunPreprocessingTab.Title = 'Run Preprocessing';
            app.RunPreprocessingTab.BackgroundColor = [0.8588 0.9608 0.9882];

            % Create BackButton_7
            app.BackButton_7 = uibutton(app.RunPreprocessingTab, 'push');
            app.BackButton_7.ButtonPushedFcn = createCallbackFcn(app, @BackButtonPushed, true);
            app.BackButton_7.Position = [531 10 100 22];
            app.BackButton_7.Text = 'Back';

            % Create SaveoptionsLabel
            app.SaveoptionsLabel = uilabel(app.RunPreprocessingTab);
            app.SaveoptionsLabel.FontWeight = 'bold';
            app.SaveoptionsLabel.FontColor = [0 0.4471 0.7412];
            app.SaveoptionsLabel.Position = [237 425 301 22];
            app.SaveoptionsLabel.Text = '=============== Save options ===============';

            % Create StepstoPerformLabel
            app.StepstoPerformLabel = uilabel(app.RunPreprocessingTab);
            app.StepstoPerformLabel.FontWeight = 'bold';
            app.StepstoPerformLabel.FontColor = [0 0.4471 0.7412];
            app.StepstoPerformLabel.Position = [60 292 323 22];
            app.StepstoPerformLabel.Text = '=============== Steps to Perform ===============';

            % Create RunButton
            app.RunButton = uibutton(app.RunPreprocessingTab, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunPreprocessing, true);
            app.RunButton.FontSize = 13;
            app.RunButton.FontWeight = 'bold';
            app.RunButton.Position = [652 10 100 23];
            app.RunButton.Text = 'Run';

            % Create SavematfilesSwitchLabel
            app.SavematfilesSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.SavematfilesSwitchLabel.HorizontalAlignment = 'center';
            app.SavematfilesSwitchLabel.FontSize = 13;
            app.SavematfilesSwitchLabel.FontWeight = 'bold';
            app.SavematfilesSwitchLabel.Position = [60 390 101 22];
            app.SavematfilesSwitchLabel.Text = 'Save .mat files';

            % Create SavematfilesSwitch
            app.SavematfilesSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.SavematfilesSwitch.Items = {'Yes', 'No'};
            app.SavematfilesSwitch.ValueChangedFcn = createCallbackFcn(app, @SetSaveFnc, true);
            app.SavematfilesSwitch.Position = [91 359 45 20];
            app.SavematfilesSwitch.Value = 'Yes';

            % Create SavestructSwitchLabel
            app.SavestructSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.SavestructSwitchLabel.HorizontalAlignment = 'center';
            app.SavestructSwitchLabel.FontSize = 13;
            app.SavestructSwitchLabel.FontWeight = 'bold';
            app.SavestructSwitchLabel.Position = [326 390 101 22];
            app.SavestructSwitchLabel.Text = 'Save struct';

            % Create SavestructSwitch
            app.SavestructSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.SavestructSwitch.Items = {'Yes', 'No'};
            app.SavestructSwitch.ValueChangedFcn = createCallbackFcn(app, @SetSaveFnc, true);
            app.SavestructSwitch.Tooltip = {'Whether to save mat files as struct with other information or not, If no, the .mat file will only have eeg values. If yes, save .mat files will be set to yes'};
            app.SavestructSwitch.Position = [357 359 45 20];
            app.SavestructSwitch.Value = 'Yes';

            % Create SaveMarkerfilesSwitchLabel
            app.SaveMarkerfilesSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.SaveMarkerfilesSwitchLabel.HorizontalAlignment = 'center';
            app.SaveMarkerfilesSwitchLabel.FontSize = 13;
            app.SaveMarkerfilesSwitchLabel.FontWeight = 'bold';
            app.SaveMarkerfilesSwitchLabel.Position = [459 390 112 22];
            app.SaveMarkerfilesSwitchLabel.Text = 'Save Marker files';

            % Create SaveMarkerfilesSwitch
            app.SaveMarkerfilesSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.SaveMarkerfilesSwitch.Items = {'Yes', 'No'};
            app.SaveMarkerfilesSwitch.ValueChangedFcn = createCallbackFcn(app, @SetSaveFnc, true);
            app.SaveMarkerfilesSwitch.Position = [495 359 45 20];
            app.SaveMarkerfilesSwitch.Value = 'Yes';

            % Create EEGformatSwitchLabel
            app.EEGformatSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.EEGformatSwitchLabel.HorizontalAlignment = 'center';
            app.EEGformatSwitchLabel.FontSize = 13;
            app.EEGformatSwitchLabel.FontWeight = 'bold';
            app.EEGformatSwitchLabel.Position = [600 390 101 22];
            app.EEGformatSwitchLabel.Text = 'EEG format';

            % Create EEGformatSwitch
            app.EEGformatSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.EEGformatSwitch.Items = {'matrix', 'tensor'};
            app.EEGformatSwitch.ValueChangedFcn = createCallbackFcn(app, @SetSaveFnc, true);
            app.EEGformatSwitch.Tooltip = {'The eeg structure to use for mat files. '; 'Matrix is a 2D matrix with dimesnions Channel x Sample. '; 'Tensor is a 3D array with dimensions Channel x Channel x Sample'};
            app.EEGformatSwitch.Position = [631 359 45 20];
            app.EEGformatSwitch.Value = 'matrix';

            % Create SavesetfilesSwitchLabel
            app.SavesetfilesSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.SavesetfilesSwitchLabel.HorizontalAlignment = 'center';
            app.SavesetfilesSwitchLabel.FontSize = 13;
            app.SavesetfilesSwitchLabel.FontWeight = 'bold';
            app.SavesetfilesSwitchLabel.Position = [197 390 101 22];
            app.SavesetfilesSwitchLabel.Text = 'Save .set files';

            % Create SavesetfilesSwitch
            app.SavesetfilesSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.SavesetfilesSwitch.Items = {'Yes', 'No'};
            app.SavesetfilesSwitch.ValueChangedFcn = createCallbackFcn(app, @SetSaveFnc, true);
            app.SavesetfilesSwitch.Position = [228 359 45 20];
            app.SavesetfilesSwitch.Value = 'No';

            % Create ChannelRemovalLabel
            app.ChannelRemovalLabel = uilabel(app.RunPreprocessingTab);
            app.ChannelRemovalLabel.HorizontalAlignment = 'center';
            app.ChannelRemovalLabel.Position = [52 260 101 22];
            app.ChannelRemovalLabel.Text = 'Channel Removal';

            % Create ChannelRemovalSwitch
            app.ChannelRemovalSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.ChannelRemovalSwitch.Items = {'On', 'Off'};
            app.ChannelRemovalSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.ChannelRemovalSwitch.Position = [78 234 45 20];

            % Create DatasettoPreprocessDropDownLabel
            app.DatasettoPreprocessDropDownLabel = uilabel(app.RunPreprocessingTab);
            app.DatasettoPreprocessDropDownLabel.HorizontalAlignment = 'right';
            app.DatasettoPreprocessDropDownLabel.Position = [491 241 66 28];
            app.DatasettoPreprocessDropDownLabel.Text = {'Dataset to '; 'Preprocess'};

            % Create DatasettoPreprocessDropDown
            app.DatasettoPreprocessDropDown = uidropdown(app.RunPreprocessingTab);
            app.DatasettoPreprocessDropDown.Items = {'All'};
            app.DatasettoPreprocessDropDown.Editable = 'on';
            app.DatasettoPreprocessDropDown.ValueChangedFcn = createCallbackFcn(app, @SingleDataset, true);
            app.DatasettoPreprocessDropDown.BackgroundColor = [1 1 1];
            app.DatasettoPreprocessDropDown.Position = [572 247 100 22];
            app.DatasettoPreprocessDropDown.Value = 'All';

            % Create VerboseSwitchLabel
            app.VerboseSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.VerboseSwitchLabel.HorizontalAlignment = 'right';
            app.VerboseSwitchLabel.Position = [507 128 50 22];
            app.VerboseSwitchLabel.Text = 'Verbose';

            % Create VerboseSwitch
            app.VerboseSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.VerboseSwitch.Items = {'On', 'Off'};
            app.VerboseSwitch.ValueChangedFcn = createCallbackFcn(app, @AddVerbose, true);
            app.VerboseSwitch.Tooltip = {'whther to print messages from the eeglab function and from BIDSAlign or not. Errors will still be reported'};
            app.VerboseSwitch.Position = [609 129 45 20];

            % Create ParallelComputingSwitchLabel
            app.ParallelComputingSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.ParallelComputingSwitchLabel.HorizontalAlignment = 'right';
            app.ParallelComputingSwitchLabel.Position = [493 83 64 28];
            app.ParallelComputingSwitchLabel.Text = {'Parallel'; 'Computing'};

            % Create ParallelComputingSwitch
            app.ParallelComputingSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.ParallelComputingSwitch.Items = {'On', 'Off'};
            app.ParallelComputingSwitch.ValueChangedFcn = createCallbackFcn(app, @DoParpool, true);
            app.ParallelComputingSwitch.Tooltip = {'Whether to preprocess datasets with the parallel computing toolbox or not. Can be used only if multiple datasets are preprocessed in a single run'};
            app.ParallelComputingSwitch.Position = [609 87 45 20];

            % Create SegmentRemovalSwitchLabel
            app.SegmentRemovalSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.SegmentRemovalSwitchLabel.HorizontalAlignment = 'center';
            app.SegmentRemovalSwitchLabel.Position = [173 260 104 22];
            app.SegmentRemovalSwitchLabel.Text = 'Segment Removal';

            % Create SegmentRemovalSwitch
            app.SegmentRemovalSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.SegmentRemovalSwitch.Items = {'On', 'Off'};
            app.SegmentRemovalSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.SegmentRemovalSwitch.Position = [200 234 45 20];

            % Create ICRejectionSwitchLabel
            app.ICRejectionSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.ICRejectionSwitchLabel.HorizontalAlignment = 'center';
            app.ICRejectionSwitchLabel.Position = [306 194 71 22];
            app.ICRejectionSwitchLabel.Text = 'IC Rejection';

            % Create ICRejectionSwitch
            app.ICRejectionSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.ICRejectionSwitch.Items = {'On', 'Off'};
            app.ICRejectionSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.ICRejectionSwitch.Tooltip = {'If this is on, ICA decomposition will automatically set to on'};
            app.ICRejectionSwitch.Position = [317 168 45 20];

            % Create BaselineRemovalSwitchLabel
            app.BaselineRemovalSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.BaselineRemovalSwitchLabel.HorizontalAlignment = 'center';
            app.BaselineRemovalSwitchLabel.Position = [291 260 102 22];
            app.BaselineRemovalSwitchLabel.Text = 'Baseline Removal';

            % Create BaselineRemovalSwitch
            app.BaselineRemovalSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.BaselineRemovalSwitch.Items = {'On', 'Off'};
            app.BaselineRemovalSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.BaselineRemovalSwitch.Position = [317 234 45 20];

            % Create ResamplingSwitchLabel
            app.ResamplingSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.ResamplingSwitchLabel.HorizontalAlignment = 'center';
            app.ResamplingSwitchLabel.Position = [69 194 69 22];
            app.ResamplingSwitchLabel.Text = 'Resampling';

            % Create ResamplingSwitch
            app.ResamplingSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.ResamplingSwitch.Items = {'On', 'Off'};
            app.ResamplingSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.ResamplingSwitch.Position = [79 168 45 20];

            % Create FilteringSwitchLabel
            app.FilteringSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.FilteringSwitchLabel.HorizontalAlignment = 'center';
            app.FilteringSwitchLabel.Position = [202 194 48 22];
            app.FilteringSwitchLabel.Text = 'Filtering';

            % Create FilteringSwitch
            app.FilteringSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.FilteringSwitch.Items = {'On', 'Off'};
            app.FilteringSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.FilteringSwitch.Position = [201 168 45 20];

            % Create RereferencingSwitchLabel
            app.RereferencingSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.RereferencingSwitchLabel.HorizontalAlignment = 'center';
            app.RereferencingSwitchLabel.Position = [185 128 81 22];
            app.RereferencingSwitchLabel.Text = 'Rereferencing';

            % Create RereferencingSwitch
            app.RereferencingSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.RereferencingSwitch.Items = {'On', 'Off'};
            app.RereferencingSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.RereferencingSwitch.Position = [201 102 45 20];

            % Create ICADecompositionSwitchLabel
            app.ICADecompositionSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.ICADecompositionSwitchLabel.HorizontalAlignment = 'center';
            app.ICADecompositionSwitchLabel.Position = [288 128 108 22];
            app.ICADecompositionSwitchLabel.Text = 'ICA Decomposition';

            % Create ICADecompositionSwitch
            app.ICADecompositionSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.ICADecompositionSwitch.Items = {'On', 'Off'};
            app.ICADecompositionSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.ICADecompositionSwitch.Tooltip = {'This step will be performed two times if the '};
            app.ICADecompositionSwitch.Position = [317 102 45 20];

            % Create ASRSwitchLabel
            app.ASRSwitchLabel = uilabel(app.RunPreprocessingTab);
            app.ASRSwitchLabel.HorizontalAlignment = 'center';
            app.ASRSwitchLabel.Position = [88 128 30 22];
            app.ASRSwitchLabel.Text = 'ASR';

            % Create ASRSwitch
            app.ASRSwitch = uiswitch(app.RunPreprocessingTab, 'slider');
            app.ASRSwitch.Items = {'On', 'Off'};
            app.ASRSwitch.ValueChangedFcn = createCallbackFcn(app, @Step2DoFnc, true);
            app.ASRSwitch.Position = [79 102 45 20];

            % Create ModalityLabel
            app.ModalityLabel = uilabel(app.RunPreprocessingTab);
            app.ModalityLabel.FontWeight = 'bold';
            app.ModalityLabel.FontColor = [0 0.4471 0.7412];
            app.ModalityLabel.Position = [473 292 216 22];
            app.ModalityLabel.Text = '=========== Modality ===========';

            % Create FinalcheckscontroltableLabel
            app.FinalcheckscontroltableLabel = uilabel(app.RunPreprocessingTab);
            app.FinalcheckscontroltableLabel.FontSize = 13;
            app.FinalcheckscontroltableLabel.FontWeight = 'bold';
            app.FinalcheckscontroltableLabel.Position = [121 10 275 22];
            app.FinalcheckscontroltableLabel.Text = 'Final checks: control table';

            % Create RunFinalChecks
            app.RunFinalChecks = uilamp(app.RunPreprocessingTab);
            app.RunFinalChecks.Position = [91 11 20 20];
            app.RunFinalChecks.Color = [1 0 0];

            % Create RunGeneralHelp
            app.RunGeneralHelp = uibutton(app.RunPreprocessingTab, 'push');
            app.RunGeneralHelp.ButtonPushedFcn = createCallbackFcn(app, @HelpFnc, true);
            app.RunGeneralHelp.Position = [25 10 49 22];
            app.RunGeneralHelp.Text = 'Help';

            % Create SingleFileDropDownLabel
            app.SingleFileDropDownLabel = uilabel(app.RunPreprocessingTab);
            app.SingleFileDropDownLabel.HorizontalAlignment = 'right';
            app.SingleFileDropDownLabel.Enable = 'off';
            app.SingleFileDropDownLabel.Position = [495 199 62 22];
            app.SingleFileDropDownLabel.Text = 'Single File';

            % Create SingleFileDropDown
            app.SingleFileDropDown = uidropdown(app.RunPreprocessingTab);
            app.SingleFileDropDown.Items = {'All files'};
            app.SingleFileDropDown.Editable = 'on';
            app.SingleFileDropDown.ValueChangedFcn = createCallbackFcn(app, @SingleFile, true);
            app.SingleFileDropDown.Enable = 'off';
            app.SingleFileDropDown.BackgroundColor = [1 1 1];
            app.SingleFileDropDown.Position = [572 199 100 22];
            app.SingleFileDropDown.Value = 'All files';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = BIDSAlign_GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end