
function [EEG, obj_info] = get_reference(EEG, data_info, obj_info, verbose)
    % FUNCTION: get_reference
    %
    % Description: Check and update the EEG reference based on information from JSON reference.
    %
    % Syntax:
    %   [EEG] = get_reference(EEG, data_info, obj_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG structure.
    %   - data_info (struct): Information about the dataset.
    %   - obj_info (struct): Information about the EEG file.
    %   - verbose (logical): Flag to control verbosity of output.
    %
    % Output:
    %   - EEG (struct): Updated EEG structure with reference information.
    %   - obj_info (struct): Updated struct with reference EEG information.
    %
    % Author: [Andrea Zanola]
    % Date: [28/02/2024]
    %

    %% Check what is present in JSON reference
    json_reference = [];

    if ~isempty(obj_info.EEGReference)
        a = load('full_channel_list.mat');
        all_channel_list = a.all_channel_list;
        c = 0;
        for i=1:length(all_channel_list)
            chan = upper(all_channel_list{i});
            if contains(upper(obj_info.EEGReference), chan) 
                if c==0
                    json_reference = [json_reference chan];
                else
                    if ~contains(json_reference, chan)
                        json_reference = [json_reference '-' chan];
                    end
                end
                c = c+1;
            end
        end
    end

    %% Check what is present in EEG reference
    if isfield(EEG,'ref')
        loaded_reference = EEG.ref;
    else
        loaded_reference = [];
    end
    
    if isequal(data_info.channel_system,'GSN129')
        if isequal(upper(json_reference),'CZ')
            json_reference = 'E129';
        end
    elseif isequal(data_info.channel_system,'GSN257')
        if isequal(upper(json_reference),'CZ')
            json_reference = 'E257';
        end
    end

    if verbose
        if ~isempty(json_reference) && ~isempty(loaded_reference)
            if ~isequal(json_reference,loaded_reference)
                if verbose
                    warning('JSON reference differs from loaded reference.');
                end
            end
        end
        if ~isempty(json_reference) && ~isempty(data_info.channel_reference)
            if ~isequal(json_reference,data_info.channel_reference)
                if verbose
                    warning('DATASET_INFO reference differs from JSON reference.');
                end
            end
        end
        if ~isempty(loaded_reference) && ~isempty(data_info.channel_reference)
            if ~isequal(loaded_reference, data_info.channel_reference)
                if verbose
                    warning('DATASET_INFO reference differs from loaded reference.');
                end
            end
        end
    end

    %% Set dataset reference
    if ~isempty(json_reference) && ~isempty(data_info.channel_reference)
        dataset_reference = data_info.channel_reference; %data_info priority

    elseif isempty(json_reference) && ~isempty(data_info.channel_reference)
        dataset_reference = data_info.channel_reference;

    elseif ~isempty(json_reference) && isempty(data_info.channel_reference)
        dataset_reference = json_reference;

    elseif ~isempty(loaded_reference) && isempty(json_reference) && isempty(data_info.channel_reference)
        dataset_reference = loaded_reference;
        if verbose
            warning("Both json and data-reference are empty, thus loaded reference is considered.");
        end
    end

    %% Overwrite EEG reference
    EEG.ref = dataset_reference;
    obj_info.old_reference = EEG.ref;

end