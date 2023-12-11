
function [data_info, path_info, template_info, T] = load_info(data_info, path_info, params_info, save_info)
    % Function: load_info
    % Description: Loads information related to EEG dataset, paths, preprocessing parameters, 
    % and save configurations. Checks the integrity of imported data, sets necessary paths,
    % creates a template structure for channel information, and imports participant and diagnostic files.
    %
    % Input:
    %   - data_info: Structure containing information about the EEG dataset.
    %   - path_info: Structure containing paths to datasets and libraries.
    %   - params_info: Structure containing preprocessing parameters.
    %   - save_info: Structure containing information about saving preprocessed data.
    %
    % Output:
    %   - data_info: Updated structure containing EEG dataset information.
    %   - path_info: Updated structure containing paths.
    %   - template_info: Structure containing template information for channel selection.
    %   - T: Table containing participant information.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]

    %% Check if the imported data has correct values

    if data_info.samp_rate < 0 || mod(data_info.samp_rate, 1) ~= 0
        error('ERROR: NEGATIVE OR NON-INTEGER SAMPLING RATE');
    end
    %filter frequencies
    if params_info.low_freq>params_info.high_freq || params_info.low_freq<0 || params_info.high_freq<0
        error('ERROR: CHECK THE FREQUENCIES FOR THE FILTER');
    end
    
    %% Set Folder/Files Path
    path_info.dataset_path = [path_info.root_datasets_path data_info.dataset_code '/' ];
    cd(path_info.dataset_path);
    
    %% Create template struct
    %channel system supported
    data_info.channel_systems = {'10_20', '10_10', '10_5', 'GSN129', 'GSN257'};

    % Create the template struct to store channel template information
    template_folder           = [path_info.lib_path '/template/template_channel_selection/'];
    tensor_template_filename  = 'tensor_channel_template.mat';
    matrix_template_filename  = 'matrix_channel_template.mat';
    
    % Load the matrix template file
    template_matrix = load([template_folder matrix_template_filename]);
    template_matrix = upper(template_matrix.matrix_channel_template);
    
    % Load the tensor template file
    template_tensor = load([template_folder tensor_template_filename]);
    template_tensor = upper(template_tensor.tensor_channel_template);
    
    % Load the conversion files based on the channel system
    conversion_folder         = [path_info.lib_path '/template/template_channel_conversion/'];
    conv_GSN129_1010_filename = 'conv_GSN129_1010.mat';
    conv_GSN257_1010_filename = 'conv_GSN257_1010.mat';
    
    % Load standard channel location file from templates
    channel_location_folder = [path_info.lib_path '/template/template_channel_location/'];
    
    if isequal(data_info.channel_system,data_info.channel_systems{4})
        conversion = load([conversion_folder  conv_GSN129_1010_filename]);
        conversion = upper(conversion.convGSN129);
        if length(conversion(:,1)) < length(template_matrix)
            error('ERROR: CONVERSION FILE SHORTER THAN TEMPLATE FILE')
        end
        standard_chanloc = [channel_location_folder 'chanloc_template_' data_info.channel_system '.sfp'];
    
    elseif isequal(data_info.channel_system,data_info.channel_systems{5})
        conversion = load([conversion_folder  conv_GSN257_1010_filename]);
        conversion = upper(conversion.convGSN257);
        if length(conversion(:,1)) < length(template_matrix)
            error('ERROR: CONVERSION FILE SHORTER THAN TEMPLATE FILE')
        end
        standard_chanloc = [channel_location_folder 'chanloc_template_' data_info.channel_system '.sfp'];
    
    elseif isequal(data_info.channel_system,data_info.channel_systems{1}) || isequal(data_info.channel_system, data_info.channel_systems{2}) || isequal(data_info.channel_system,data_info.channel_systems{3})
        conversion = 'nan';
        standard_chanloc = [channel_location_folder 'chanloc_template_' '10_5' '.sfp'];

    else
        error('ERROR: UNSUPPORTED CHANNEL SYSTEM');
    end
    
    template_info = struct('template_matrix',template_matrix, ...
                           'template_tensor',template_tensor, ...
                           'conversion',conversion,...
                           'standard_chanloc',standard_chanloc); 
    
    %% Import participant file
    % Read the participant file
    if isfile([path_info.dataset_path 'participants.csv'])
        T = readtable([path_info.dataset_path 'participants.csv'],'FileType','text');

    elseif isfile([path_info.dataset_path 'participants.tsv'])
        T = readtable([path_info.dataset_path 'participants.tsv'],'FileType','text');

    elseif ~isempty(dir([path_info.dataset_path 'participants.*']))
        T = [];
        warning('PARTICIPANT FILE FOUND BUT UNABLE TO IMPORT THE ASSOCIATED FILE FORMAT. PLEASE CONVERT IT IN .TSV/.CSV'); 
    else
        T = [];
        warning(['PARTICIPANT FILE NOT FOUND IN: ' path_info.dataset_path]);
    end

    %% Import diagnostic test
    path_info.diagnostic_folder_path = [path_info.dataset_path path_info.diagnostic_folder_name];
    S = dir(fullfile(path_info.diagnostic_folder_path,'*'));
    N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of _test

    for ii = 1:numel(N)
        
        K1 = dir(fullfile(path_info.diagnostic_folder_path,N{ii},'*.tsv'));
        K2 = dir(fullfile(path_info.diagnostic_folder_path,N{ii},'*.csv'));
        K = [K1,K2];
        C = {K(~[K.isdir]).name}; % .tsv/.csv files in subfolder.

        for jj = 1:numel(C)
            F = fullfile(path_info.diagnostic_folder_path,N{ii},C{jj});
            
            T_new = readtable(F,'FileType','text');
            emptyCells = cellfun(@isempty,T_new.Var1); %remove rows with no subjID
            T_new(emptyCells,:) = [];

            if ~isempty(T)
                T = outerjoin(T,T_new,'Keys',{'Var1'},'MergeKeys',true); %join tables
            else
                T = T_new;
            end
        end
    end

    %% Check if folder already exist otherwise create set_preprocessed folder
    if save_info.save_set
        path_info.set_folder = [path_info.root_folder_path 'set_preprocessed_' data_info.dataset_code '/'];
        if ~exist(path_info.set_folder, 'dir')
            mkdir(path_info.set_folder)
        end
    end
end


    % Function: preprocess_dataset
    % Description: Preprocesses a dataset of EEG recordings, extracts relevant information,
    % and saves the preprocessed data to a template-based data structure or matrix format.
    %
    % Input:
    %   - root_datasets_path: The root path to the datasets.
    %   - lib_path: The path to the library folder containing template files.
    %   - dataset_info: Structure containing dataset-specific information.
    %   - dataset_name: The name of the dataset to preprocess.
    %   - params_info: Structure containing preprocessing parameters.
    %   - diagnostic_folder_name: The name of the diagnostic folder within the dataset.
    %
    % Output:
    %   - EEG: EEG data structure after preprocessing.
    %   - DATA_STRUCT: Structure containing preprocessed data information.
    %
    % Notes:
    %   - This function preprocesses all the EEG data for a specified dataset, 
    %     including loading participant and diagnostic files, extracting channel 
    %     information, interpolating missing channels, and saving the data.
    %
    % Author: [Andrea Zanola]
    % Date: [04/10/2023] 
