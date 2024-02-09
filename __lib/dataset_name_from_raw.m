function dataset_name = dataset_name_from_raw(raw_filepath, datasets_path)

    raw_split = strsplit(raw_filepath, datasets_path);
    raw_split = raw_split{2};
    if strcmp(raw_split, raw_filepath)
        error('dataset path is not included in raw_filepath.')
    end
    raw_split = strsplit(raw_split, '/');
    dataset_name = raw_split{1};

end