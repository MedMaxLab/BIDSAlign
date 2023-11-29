
function [obj_info] = extract_filenames(obj_info, path_info, data_info)
    % Function: extract_filenames
    % Description: Extracts filenames for channel and electrode information
    % based on the folder structure and user-defined naming conventions.
    %
    % Input:
    %   - check_ch0_root, check_ch1_root, check_ch2_root: Root folder objects
    %     for channel files at different levels of the dataset structure.
    %   - check_el0_root, check_el1_root, check_el2_root: Root folder objects
    %     for electrode files at different levels of the dataset structure.
    %   - raw_filepath: Path to the directory where the raw EEG data file is located.
    %   - raw_filename: Name of the raw EEG data file.
    %   - data_info: A structure containing information about the EEG data,
    %     including the EEG file extension and channel information.
    %
    % Output:
    %   - data_info: Updated structure containing channels and electrodes
    %     filenames.
    %
    % Usage example:
    %   [data_info] = extract_filenames(check_ch0_root, check_ch1_root, check_ch2_root, ...
    %                                   check_el0_root, check_el1_root, check_el2_root, ...
    %                                   '/path/to/raw/', 'raw_data.set', data_info_struct);
    %
    % Notes:
    %   - This function examines the dataset folder structure to determine the
    %     appropriate filenames for channel and electrode information.
    %   - It updates the data_info structure with channel folder information.
    %
    % Author: [Andrea Zanola]
    % Date: [04/10/2023]
    
    % Note: This function is designed to work with a specific dataset structure
    % and naming conventions, the BIDS format. The logic for determining filenames 
    % is based on the provided inputs and dataset organization.

    %% Check _channel.tsv file ----------------------------------
    if length(obj_info.check_ch0_root)>1 || length(obj_info.check_ch1_root)>1
        error('ERROR: TO MUCH CHANNELS FILE IN THE WRONG PLACE');
    end

    if length(obj_info.check_ch0_root)==1
        %case when _channels.tsv is in the dataset folder (equal for all
        %subjects)
        obj_info.channels_filename = [obj_info.check_ch0_root.folder '/' obj_info.check_ch0_root.name];

    elseif isempty(obj_info.check_ch0_root) && length(obj_info.check_ch1_root)==1
        %case when _channels.tsv is in the subject folder (equal for all
        %sessions)
        obj_info.channels_filename = [obj_info.check_ch1_root.folder '/' obj_info.check_ch1_root.name];

    elseif isempty(obj_info.check_ch1_root) && length(obj_info.check_ch2_root)==1
        %case when _channels.tsv is in the session folder (equal for all
        %objects)
        obj_info.channels_filename = [obj_info.check_ch2_root.folder '/' obj_info.check_ch2_root.name];

    elseif length(obj_info.check_ch2_root)>1
        %case when there is a _channels.tsv for each object
        % the operation -4 is because eeg files names terminate with "_eeg"
        obj_info.channels_filename = [obj_info.raw_filepath '/' obj_info.raw_filename(1:length(obj_info.raw_filename)-length(data_info.eeg_file_extension)-4) '_channels.tsv'];
    
    elseif isempty(obj_info.check_ch2_root)
        obj_info.channels_filename = [];
    end

    %% Check _electrodes.tsv file 
    obj_info.channel_location_filename = data_info.channel_location_filename;

    if length(obj_info.check_el0_root)>1 || length(obj_info.check_el1_root)>1
        error('ERROR: TO MUCH ELECTRODES FILE IN THE WRONG PLACE');
    end

    if ~isempty(obj_info.channel_location_filename)
        if isequal(obj_info.channel_location_filename,'loaded')
            obj_info.electrodes_filename = [];
        else
            obj_info.electrodes_filename = [path_info.dataset_path obj_info.channel_location_filename];
        end
    elseif length(obj_info.check_el0_root)==1
        obj_info.electrodes_filename = [obj_info.check_el0_root.folder '/' obj_info.check_el0_root.name];

    elseif isempty(obj_info.check_el0_root) && length(obj_info.check_el1_root)==1
        obj_info.electrodes_filename  = [obj_info.check_el1_root.folder '/' obj_info.check_el1_root.name];

    elseif isempty(obj_info.check_el1_root) && length(obj_info.check_el2_root)==1
        obj_info.electrodes_filename  = [obj_info.check_el2_root.folder '/' obj_info.check_el2_root.name];

    elseif isempty(obj_info.check_el1_root) && length(obj_info.check_el2_root)>1
        obj_info.electrodes_filename  = [obj.raw_filepath '/' obj.raw_filename(1:length(obj.raw_filename)-length(data_info.eeg_file_extension)-4) '_electrodes.tsv'];

    elseif isempty(obj_info.check_el2_root)
        obj_info.electrodes_filename = [];
    end

end
