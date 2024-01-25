
function [] = search_eeglab_path(verbose)
    % FUNCTION: search_eeglab_path
    %
    % Description: Searches for the path to the EEGLAB toolbox in your current search path list and adds it to the MATLAB search path.
    % In case it is not found, this function will try to search and add automatically the path 
    % by looking at the toolbox folder and in your current working directory. 
    % If nothing is found, a waring is generated and the user is asked to add the path
    % manually by running the following command:
    % 
    %     addpath(' path/to/eeglab')
    %
    % Syntax:
    %   search_eeglab_path(verbose)
    %
    % Input:
    %   - verbose (optional): A boolean flag indicating whether to display additional information (default: false).
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %

    if nargin ~= 1
        verbose = false;
    end
    
    try 
        [~] = evalc('eeglab no gui;');
        return
    catch
        if verbose
            disp("eeglab not present in your current search path. Trying to add it automatically")
        end
    end

    % try searching in the current list of paths
    addedpath= false;
    all_search = strsplit( path ,':');
    for i=1:length(all_search)
        ith_path = strfind(all_search{i},'eeglab');
        if not(isempty(ith_path))
            if verbose
                disp('Found eeglab path in MATLAB search path')
            end
            return
        end
    end

    % try searching in the toolbox folder
    % maybe it has been added in the toolbox folder but not in the path
    if ismac
        d = dir('/Application/MATLAB_R*/**');
    elseif isunix
        ver = version;
        ver = ver(length(ver)-6:length(ver)-1);
        d = dir(['/usr/local/pkgs/MATLAB/' ver '/toolbox/']);
        if isempty(d)
            d = dir(['/usr/local/MATLAB/' ver '/toolbox/']);
        end
    elseif ispc
        d = dir('/Application/MATLAB_R*/**');
    else
        disp('Platform not supported')
        d = struct;
    end

    % remove all files (isdir property is 0)
    dfolders = d([d(:).isdir]);
    % remove '.' and '..' 
    dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
    folder_names = {dfolders.name};
    for i=1:length(folder_names)
        ith_path = strfind(folder_names{i},'eeglab');
        if not(isempty(ith_path))
            if verbose
                disp('Found eeglab path in MATLAB toolbox folder')
                disp(folder_names{i})
                disp('adding it to the current path list')
            end
            addpath(folder_names{i})
            return
        end
    end


    %try searching in your current path and subpaths
    d = dir('**');
    dfolders = d([d(:).isdir]);
    dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
    folder_names = {dfolders.name};
    for i=1:length(folder_names)
        ith_path = strfind(folder_names{i},'eeglab');
        if not(isempty(ith_path))
            if verbose
                disp('Found a folder with eeglab in its name in the following path in MATLAB')
                disp(folder_names{i})
                disp('Adding it to the current path list')
            end
            addpath(folder_names{i})
            addedpath=true;
        end
    end

    if addedpath
        try 
            [~] = evalc('eeglab no gui;');
        catch
            error("added paths were not associated to the eeglab toolbox. " +...
                "Please add the correct path manually by running the following " + ...
                " command: addpath('path/to/eeglab')")
        end
    else
            error("wasn't able to find a path to eeglab. " +...
            "Please add the path manually by running the following " + ...
            " command: addpath('path/to/eeglab')")
    end
    
end
