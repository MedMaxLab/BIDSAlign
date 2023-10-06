
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

function [data_info] = extract_filenames(check_ch0_root, check_ch1_root, check_ch2_root, ...
                                         check_el0_root, check_el1_root, check_el2_root, ...
                                         raw_filepath, raw_filename, data_info)


    %% Check _channel.tsv file ----------------------------------
    if length(check_ch0_root)>1 || length(check_ch1_root)>1
        error('ERROR: TO MUCH CHANNELS FILE IN THE WRONG PLACE');
    end

    if length(check_ch0_root)==1
        %case when _channels.tsv is in the dataset folder (equal for all
        %subjects)
        data_info.channels_filename = [check_ch0_root.folder '/' check_ch0_root.name];

    elseif isempty(check_ch0_root) && length(check_ch1_root)==1
        %case when _channels.tsv is in the subject folder (equal for all
        %sessions)
        data_info.channels_filename = [check_ch1_root.folder '/' check_ch1_root.name];

    elseif isempty(check_ch1_root) && length(check_ch2_root)==1
        %case when _channels.tsv is in the session folder (equal for all
        %objects)
        data_info.channels_filename = [check_ch2_root.folder '/' check_ch2_root.name];

    elseif length(check_ch2_root)>1
        %case when there is a _channels.tsv for each object
        % the operation -4 is because eeg files names terminate with "_eeg"
        data_info.channels_filename = [raw_filepath '/' raw_filename(1:length(raw_filename)-length(data_info.eeg_file_extension)-4) '_channels.tsv'];
    
    elseif isempty(check_ch2_root)
        data_info.channels_filename = [];
    end

    %% Check _electrodes.tsv file 
    if length(check_el0_root)>1 || length(check_el1_root)>1
        error('ERROR: TO MUCH ELECTRODES FILE IN THE WRONG PLACE');
    end

    if length(check_el0_root)==1
        data_info.electrodes_filename = [check_el0_root.folder '/' check_el0_root.name];

    elseif isempty(check_el0_root) && length(check_el1_root)==1
        data_info.electrodes_filename  = [check_el1_root.folder '/' check_el1_root.name];

    elseif isempty(check_el1_root) && length(check_el2_root)==1
        data_info.electrodes_filename  = [check_el2_root.folder '/' check_el2_root.name];

    elseif isempty(check_el1_root) && length(check_el2_root)>1
        data_info.electrodes_filename  = [raw_filepath '/' raw_filename(1:length(raw_filename)-length(data_info.eeg_file_extension)-4) '_electrodes.tsv'];

    elseif isempty(check_el2_root) || (isempty(data_info.channel_location_filename) || strcmp(data_info.channel_location_filename,"loaded"))
        data_info.electrodes_filename = [];
    else
        data_info.electrodes_filename = [data_info.dataset_path data_info.channel_location_filename];
    end

end
