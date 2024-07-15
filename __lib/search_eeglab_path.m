
function [] = search_eeglab_path(verbose, forcestart, nogui_launch)
    % FUNCTION: search_eeglab_path
    %
    % Description: Searches for the path to the EEGLAB toolbox 
    % in your current search path list and adds it to the MATLAB search path.
    % In case it is not found, this function will try to search and add automatically 
    % the path by looking at the toolbox folder and in your current working
    % directory. Note that by deafult the function will look if the eeglab.m file
    % exist in your current search path.
    % If nothing is found, a warning is generated and the user is asked to add the path
    % manually by running the following command:
    % 
    %     addpath(' path/to/eeglab')
    %
    % Syntax:
    %   search_eeglab_path(verbose)
    %
    % Input:
    %   - verbose (logical): (optional) A boolean flag indicating whether to display 
    %           additional information (default: false).
    %   - forcestart (logical): (optional) A boolean indicating whether to try to
    %           actually run the command "eeglab" or not. (default: true)
    %   - nogui_launch (logical): (optional) A boolean indicating whether to try to
    %           launch eeglab with the nogui option or not. (default: true)
    %
    % Output: None.
    %
    % Author: [Federico Del Pup]
    % Date: [25/01/2024]
    %

    switch nargin
        case 0
            verbose = false;
            forcestart = false;
            nogui_launch = true;
        case 1
            forcestart = false;
            nogui_launch = true;
        case 2
            nogui_launch = true;
    end
    
    if forcestart
        try 
            if nogui_launch
                [~] = evalc('eeglab nogui;');
            else
                [~] = evalc('eeglab; close;');
            end
            return
        catch
            if verbose
                disp(['eeglab not present in your current search path. ' ...
                    newline 'Trying to add it automatically'])
            end
        end
    else 
        if isequal(exist('eeglab','file'),2)
            if verbose
                disp(['It seems that an eeglab.m file can be accessed'...
                    'from your current search path. Returning'])
            end
            return
        else
            if verbose
                disp(['eeglab not present in your current search path.' ...
                    newline 'Trying to add it automatically'])
            end
        end
    end

    %list of path added
    addedpath = false;
    totPath = 0;
    pathAddedList = cell(100,1);
    
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
                disp(['Folder name: ' folder_names{i}])
                disp('Adding folder to the current path list')
            end
            addpath(folder_names{i})
            addedpath = true;
            if forcestart
                try 
                    if nogui_launch
                        [~] = evalc('eeglab nogui;');
                    else
                        [~] = evalc('eeglab; close;');
                    end
                    if verbose
                        disp('Found path to EEGLab')
                    end
                    return
                catch
                    totPath = totPath + 1;
                    pathAddedList{totPath} = folder_names{i};
                end
            else
                if isequal(exist('eeglab','file'),2)
                    if verbose
                        disp( ...
                            ['added path to an eeglab folder with an eeglab.m file' ...
                             'form your list of available toolboxes']...
                        )
                    end
                    return
                else
                    totPath = totPath + 1;
                    pathAddedList{totPath} = folder_names{i};
                end
            end
        end
    end


    % try searching in your current path and subpaths
    % or, if possible, in all subdirectories inside the MATLAB folder.
    % In other words, if you are in a subdirectory of MATLAB, dir
    % search will be extended
    current_path = pwd;
    mat_idx = strfind(current_path, 'MATLAB');
    if mat_idx
        d = dir([current_path(1:mat_idx+5) filesep '**' filesep 'eeglab*']);
    else
        d = dir('**');
    end
    dfolders = d([d(:).isdir]);
    dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
    folder_names = {dfolders.name};
    folder_paths = {dfolders.folder};
    for i=1:length(folder_names)
        ith_path = strfind(folder_names{i},'eeglab');
        if not(isempty(ith_path))
            if exist([folder_paths{i} filesep folder_names{i} filesep 'eeglab.m'], 'file')
                if verbose
                    disp('Found a folder eeglab in its name and an eeglab.m file in it.')
                    disp(folder_names{i})
                    disp('Adding it to the path list for the current MATLAB session')
                end
                addpath(folder_names{i})
                addedpath = true;
                if forcestart
                    try
                        if nogui_launch
                            [~] = evalc('eeglab nogui;');
                        else
                            [~] = evalc('eeglab; close;');
                        end
                        if verbose
                            disp('Found path to EEGLab. Search completed')
                        end
                        return
                    catch
                        totPath = totPath + 1;
                        pathAddedList{totPath} = folder_names{i};
                    end
                else
                    if isequal(exist('eeglab','file'), 2)
                        if verbose
                            disp( ...
                                ['An eeglab.m file placed inside an eeglab folder ' ...
                                'is now in your current search path.'] ...
                            )
                        end
                        return
                    else
                        totPath = totPath + 1;
                        pathAddedList{totPath} = folder_names{i};
                    end
                end
            end
        end
    end

    if addedpath
        if verbose 
            disp('added the following paths without success: ')
            disp(pathAddedList{1:totPath})
        end
        try 
            % just to be sure that it does not run
            if nogui_launch
                [~] = evalc('eeglab nogui;');
            else
                [~] = evalc('eeglab; close;');
            end
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
