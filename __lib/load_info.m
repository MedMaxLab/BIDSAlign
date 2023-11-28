
function [data_info, template_info, T] = load_info(root_datasets_path, lib_path, dataset_info, dataset_name, ...
                                                   params_info, diagnostic_folder_name)
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
    
    %% Create data_info struct
    % Find the row corresponding to the dataset name
    dataset_index = find(strcmp(dataset_info.dataset_name, dataset_name));
 
    % Create the data_info struct to store dataset-specific information
    data_info = struct('dataset_number_reference', dataset_index, ...
                       'dataset_code', dataset_info.dataset_code{dataset_index}, ...
                       'channel_location_filename', dataset_info.channel_location_filename{dataset_index},...
                       'channel_system', dataset_info.channel_system{dataset_index},...
                       'channel_reference', dataset_info.channel_reference{dataset_index},...
                       'eeg_file_extension', dataset_info.eeg_file_extension{dataset_index},...
                       'samp_rate', dataset_info.samp_rate(dataset_index),...
                       'dataset_name', dataset_name,...
                       'channel_to_remove',dataset_info.channel_to_remove{dataset_index},...
                       'nose_dir',dataset_info.nose_direction{dataset_index});
     
    % Extract the channels to remove from the dataset information
    data_info.channel_to_remove = strsplit(dataset_info.channel_to_remove{dataset_index}, ','); 

    %% Check if the imported data has correct values
    %samp rate
    if data_info.samp_rate < 0 || mod(data_info.samp_rate, 1) ~= 0
        error("ERROR: NEGATIVE OR NON-INTEGER SAMPLING RATE");
    end
    %filter frequencies
    if params_info.low_freq>params_info.high_freq || params_info.low_freq<0 || params_info.high_freq<0
        error("ERROR: CHECK THE FREQUENCIES FOR THE FILTER");
    end
    
    %% Set Folder/Files Path
    data_info.dataset_path = [root_datasets_path data_info.dataset_code '/' ];
    cd(data_info.dataset_path);
    
    %% Create template struct
    %channel system supported
    data_info.channel_systems = {'10_20', '10_10', '10_5', 'GSN129', 'GSN257'};

    % Create the template struct to store channel template information
    template_folder           = [lib_path '/template/template_channel_selection/'];
    tensor_template_filename  = 'tensor_channel_template.mat';
    matrix_template_filename  = 'matrix_channel_template.mat';
    
    % Load the matrix template file
    template_matrix = load([template_folder matrix_template_filename]);
    template_matrix = upper(template_matrix.matrix_channel_template);
    
    % Load the tensor template file
    template_tensor = load([template_folder tensor_template_filename]);
    template_tensor = upper(template_tensor.tensor_channel_template);
    
    % Load the conversion files based on the channel system
    conversion_folder         = [lib_path '/template/template_channel_conversion/'];
    conv_GSN129_1010_filename = 'conv_GSN129_1010.mat';
    conv_GSN257_1010_filename = 'conv_GSN257_1010.mat';
    
    % Load standard channel location file from templates
    channel_location_folder = [lib_path '/template/template_channel_location/'];
    
    if strcmp(data_info.channel_system,data_info.channel_systems{4})
        conversion = load([conversion_folder  conv_GSN129_1010_filename]);
        conversion = upper(conversion.convGSN129);
        if length(conversion(:,1)) < length(template_matrix)
            error('ERROR: CONVERSION FILE SHORTER THAN TEMPLATE FILE')
        end
        data_info.standard_chanloc = [channel_location_folder 'chanloc_template_' data_info.channel_system '.sfp'];
    
    elseif strcmp(data_info.channel_system,data_info.channel_systems{5})
        conversion = load([conversion_folder  conv_GSN257_1010_filename]);
        conversion = upper(conversion.convGSN257);
        if length(conversion(:,1)) < length(template_matrix)
            error('ERROR: CONVERSION FILE SHORTER THAN TEMPLATE FILE')
        end
        data_info.standard_chanloc = [channel_location_folder 'chanloc_template_' data_info.channel_system '.sfp'];
    
    elseif  strcmp(data_info.channel_system,data_info.channel_systems{1}) || strcmp(data_info.channel_system, data_info.channel_systems{2}) || strcmp(data_info.channel_system,data_info.channel_systems{3})
        conversion = "nan";
        data_info.standard_chanloc = [channel_location_folder 'chanloc_template_' '10_5' '.sfp'];

    else
        error('ERROR: UNSUPPORTED CHANNEL SYSTEM');
    end
    
    template_info = struct('template_matrix',template_matrix,'template_tensor',template_tensor,'conversion',conversion); 
    
    %% Import participant file

    % Read the participant file
    if isfile([data_info.dataset_path 'participants.csv'])
        T = readtable([data_info.dataset_path 'participants.csv'],'FileType','text');

    elseif isfile([data_info.dataset_path 'participants.tsv'])
        T = readtable([data_info.dataset_path 'participants.tsv'],'FileType','text');

    elseif ~isempty(dir([data_info.dataset_path 'participants.*']))
        T = [];
        warning('PARTICIPANT FILE FOUND BUT UNABLE TO IMPORT THE ASSOCIATED FILE FORMAT. PLEASE CONVERT IT IN .TSV/.CSV'); 
    else
        T = [];
        warning(['PARTICIPANT FILE NOT FOUND IN: ' data_info.dataset_path]);
    end

    %% Import diagnostic test
    diagnostic_folder_path = [data_info.dataset_path diagnostic_folder_name];
    S = dir(fullfile(diagnostic_folder_path,'*'));
    N = setdiff({S([S.isdir]).name},{'.','..'}); % list of subfolders of _test

    for ii = 1:numel(N)
        
        K1 = dir(fullfile(diagnostic_folder_path,N{ii},'*.tsv'));
        K2 = dir(fullfile(diagnostic_folder_path,N{ii},'*.csv'));
        K = [K1,K2];
        C = {K(~[K.isdir]).name}; % .tsv/.csv files in subfolder.

        for jj = 1:numel(C)
            F = fullfile(diagnostic_folder_path,N{ii},C{jj});
            
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
end