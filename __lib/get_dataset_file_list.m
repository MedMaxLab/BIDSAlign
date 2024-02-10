function filelist = get_dataset_file_list(dataset_path, dataset_code, fileformat)
    switch nargin
        
        case 1
            d = dir([dataset_path '**']);
        case 2
            d = dir([dataset_path dataset_code filesep '**']);
        case 3
            d = dir([dataset_path dataset_code filesep '**' filesep '*' fileformat]);
    end

    filelist = d( boolean(1-[d(:).isdir]) );


end