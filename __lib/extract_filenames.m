
function [obj_info] = extract_filenames(obj_info, path_info, data_info, template_info)
    % FUNCTION: extract_filenames
    %
    % Description: Extracts filenames related to EEG data, including channels, electrodes and event files.
    %
    % Syntax:
    %   [obj_info] = extract_filenames(obj_info, path_info, data_info)
    %
    % Input:
    %   - obj_info (struct): Structure containing information about the EEG data file.
    %   - path_info (struct): Structure containing paths for saving preprocessed data.
    %   - data_info (struct): Structure containing information about the EEG dataset.
    %   - template_info (struct): Structure containing template information.
    %
    % Output:
    %   - obj_info (struct): Updated structure with filenames extracted.
    %
    % Notes:
    %   - This function checks for the presence of channel, electrodes,
    %     event and json files at objects level.
    %
    % Author: [Andrea Zanola]
    % Date: [11/12/2023]

    %% Check _channel.tsv file ----------------------------------
    if length(obj_info.check_ch0_root)>1 || length(obj_info.check_ch1_root)>1
        error('ERROR: TO MUCH CHANNEL FILES IN THE WRONG PLACE');
    end

    if length(obj_info.check_ch0_root)==1
        %case when _channels.tsv is in the dataset folder (equal for all
        %subjects)
        obj_info.channels_filename = [obj_info.check_ch0_root.folder filesep ...
            obj_info.check_ch0_root.name];

    elseif isempty(obj_info.check_ch0_root) && length(obj_info.check_ch1_root)==1
        %case when _channels.tsv is in the subject folder (equal for all
        %sessions)
        obj_info.channels_filename = [obj_info.check_ch1_root.folder filesep ...
            obj_info.check_ch1_root.name];

    elseif isempty(obj_info.check_ch1_root) && length(obj_info.check_ch2_root)==1
        %case when _channels.tsv is in the session folder (equal for all
        %objects)
        obj_info.channels_filename = [obj_info.check_ch2_root.folder filesep ...
            obj_info.check_ch2_root.name];

    elseif length(obj_info.check_ch2_root)>1
        %case when there is a _channels.tsv for each object
        % the operation -4 is because eeg files names terminate with "_eeg"
        obj_info.channels_filename = [obj_info.raw_filepath filesep ...
            obj_info.raw_filename( 1:length(obj_info.raw_filename) - ...
                                   length(data_info.eeg_file_extension)-4) ...
            '_channels.tsv'];
    
    elseif isempty(obj_info.check_ch2_root)
        obj_info.channels_filename = [];
    end

    %% Check _electrodes.tsv file 
    obj_info.channel_location_filename = data_info.channel_location_filename;

    if length(obj_info.check_el0_root)>1 || length(obj_info.check_el1_root)>1
        error('ERROR: TO MUCH ELECTRODE FILES IN THE WRONG PLACE');
    end

    if ~isempty(obj_info.channel_location_filename)
        if isequal(obj_info.channel_location_filename,'loaded')
            obj_info.electrodes_filename = [];
        elseif isequal(obj_info.channel_location_filename,'default')

            obj_info.electrodes_filename = template_info.standard_chanloc;

        else
            obj_info.electrodes_filename = [path_info.dataset_path  ...
                obj_info.channel_location_filename];
        end
    elseif length(obj_info.check_el0_root)==1
        obj_info.electrodes_filename = [obj_info.check_el0_root.folder filesep ...
            obj_info.check_el0_root.name];

    elseif isempty(obj_info.check_el0_root) && length(obj_info.check_el1_root)==1
        obj_info.electrodes_filename  = [obj_info.check_el1_root.folder filesep ...
            obj_info.check_el1_root.name];

    elseif isempty(obj_info.check_el1_root) && length(obj_info.check_el2_root)==1
        obj_info.electrodes_filename  = [obj_info.check_el2_root.folder filesep ...
            obj_info.check_el2_root.name];

    elseif isempty(obj_info.check_el1_root) && length(obj_info.check_el2_root)>1
        obj_info.electrodes_filename  = [obj_info.raw_filepath filesep ...
            obj_info.raw_filename(1:length(obj_info.raw_filename) - ...
                             length(data_info.eeg_file_extension)-4) ...
            '_electrodes.tsv'];

    elseif isempty(obj_info.check_el2_root)
        obj_info.electrodes_filename = [];
    end

    %% Extract Event Filename
    l = strfind(obj_info.raw_filename,'_');
    if ~isempty(l)
        event_name = [obj_info.raw_filename(1:l(end)) 'events.tsv'];
        if isfile(event_name)
            obj_info.event_filename = event_name;
        else
            obj_info.event_filename = [];
        end
    else
        obj_info.event_filename = [];
    end

    %% Extract information from json file
    a = dir('*_eeg.json');
    if length(a)>1
        l = strfind(obj_info.raw_filename,'.');
        jsonFileName = [obj_info.raw_filename(1:l) 'json'];
    elseif length(a)==1
        jsonFileName = a.name;
    else
        jsonFileName = [];
    end

    obj_info.EEGReference       = [];
    obj_info.SamplingFrequency  = [];
    obj_info.PowerLineFrequency = [];
    obj_info.SoftwareFilters    = [];

    if ~isempty(jsonFileName)
        if isfile(jsonFileName)
            obj_info.eegjson_filename = jsonFileName;
            jsonStr = fileread(jsonFileName);
            jsonData = jsondecode(jsonStr);
    
            if ~isequal(jsonData.EEGReference,'n/a')
                obj_info.EEGReference       = jsonData.EEGReference;
            end
            if ~isequal(jsonData.SamplingFrequency,'n/a') 
                if mod(jsonData.SamplingFrequency, 1) == 0
                    obj_info.SamplingFrequency = jsonData.SamplingFrequency;
                else
                    obj_info.SamplingFrequency = round(jsonData.SamplingFrequency);
                end
            end
            if ~isequal(jsonData.PowerLineFrequency,'n/a')
                obj_info.PowerLineFrequency = jsonData.PowerLineFrequency;
            end
            if ~isequal(jsonData.SoftwareFilters,'n/a')
                obj_info.SoftwareFilters    = jsonData.SoftwareFilters;
            end
        end
    end
end
