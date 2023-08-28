
function [raw_channels_filename, data_info] = extract_filenames(check_ch0_root, check_ch1_root, check_ch2_root, ...
                                                                check_el0_root, check_el1_root, check_el2_root, ...
                                                                raw_filepath, raw_filename, data_info)


    %% Check _channel.tsv file ----------------------------------
    if length(check_ch0_root)==1
        raw_channels_filename = [check_ch0_root.folder '/' check_ch0_root.name];

    elseif isempty(check_ch0_root) && length(check_ch1_root)==1
        raw_channels_filename = [check_ch1_root.folder '/' check_ch1_root.name];

    elseif isempty(check_ch1_root) && length(check_ch2_root)==1
        raw_channels_filename = [check_ch2_root.folder '/' check_ch2_root.name];

    elseif length(check_ch2_root)>1
        %this case is when length(check_ch2_root)>1, so for every file
        %there is the corresponding _channels.tsv
        raw_channels_filename = [raw_filepath '/' raw_filename(1:length(raw_filename)-length(data_info.eeg_file_extension)-4) '_channels.tsv'];
    
    elseif isempty(check_ch1_root)
        raw_channels_filename = [];
    end

    %% Check _electrodes.tsv file ----------------------------------
    if length(check_el0_root)==1
        raw_electrodes_filename = [check_el0_root.folder '/' check_el0_root.name];
        data_info.channel_folder  = raw_electrodes_filename;

    elseif isempty(check_el0_root) && length(check_el1_root)==1
        raw_electrodes_filename = [check_el1_root.folder '/' check_el1_root.name];
        data_info.channel_folder  = raw_electrodes_filename;

    elseif isempty(check_el1_root) && length(check_el2_root)==1
        raw_electrodes_filename = [check_el2_root.folder '/' check_el2_root.name];
        data_info.channel_folder  = raw_electrodes_filename;

    elseif isempty(check_el1_root) && length(check_el2_root)>1
        raw_electrodes_filename = [raw_filepath '/' raw_filename(1:length(raw_filename)-length(data_info.eeg_file_extension)-4) '_electrodes.tsv'];
        data_info.channel_folder  = raw_electrodes_filename;

    elseif isempty(check_el2_root) || (isempty(data_info.channel_location_filename) || strcmp(data_info.channel_location_filename,"loaded"))
        data_info.channel_folder  = [];
    else
        channel_location_filepath = [data_info.data_dataset_path data_info.channel_location_filename];
        data_info.channel_folder  = channel_location_filepath;
    end

end
