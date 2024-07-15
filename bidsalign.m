function bidsalign( guistatus )

filePath = mfilename('fullpath');
filePath = filePath(1:length(filePath)-9);
s  = pathsep;
pathStr = [s, path, s];

libpath = [filePath '__lib'];
onPathLib  = contains(pathStr, [s, libpath, s], 'IgnoreCase', ispc);

GUIpath = [filePath '__lib' filesep 'GUI'];
onPathGUI  = contains(pathStr, [s, GUIpath, s], 'IgnoreCase', ispc);

if ~(onPathLib && onPathGUI)
    addpath([filePath filesep '__lib'])
    addpath([filePath filesep '__lib' filesep 'GUI'])
    disp('Added Path to BIDSAlign function')
end

try
    disp('Searching for an existing eeglab path or one to add')
    search_eeglab_path(true, false, false)
    eeglab nogui
    disp('Checking all the dependencies')
    plugin_dependency = { ...
        'clean_rawdata', ...
        'ICLabel', ...
        'Biosig', ...
        'Fileio',  ...
        'MARA', ...
        'eegstats', ...
        'bva-io', ...
        'dipfit', ...
        'firfilt' ...
        'FastICA', ...
    };
    is_plugin_installed = false(1, length(plugin_dependency));
    for i=1:length(plugin_dependency)
        if plugin_status(plugin_dependency{i})
            is_plugin_installed(i) = true;
        end
    end
    plugin_to_install = plugin_dependency(not(is_plugin_installed));
    if ~isempty(plugin_to_install)
        disp(['The following EEGLAB plugins are needed by BIDSAlign'...
            ' but are not installed.' newline])
        for i=1:length(plugin_to_install)
            disp([num2str(i) '- ' plugin_to_install{i}])
        end
        disp([newline 'Installing them one by one (this may take some time)'])
        for i=1:length(plugin_to_install)
            if strcmp(plugin_to_install{i}, 'FastICA')
                eeglab_plugin_path = fullfile(fileparts(which('eeglab.m')), 'plugins');
                websave([eeglab_plugin_path filesep 'fastica.zip'], ...
                    'http://research.ics.aalto.fi/ica/fastica/code/FastICA_2.5.zip');
                unzip([eeglab_plugin_path filesep 'fastica.zip'], ...
                    [eeglab_plugin_path filesep])
                delete([eeglab_plugin_path filesep 'fastica.zip'])
            else
                [~] = evalc('plugin_askinstall(plugin_to_install{i}, [], true);');
            end
            close all
            disp(['Installed ' plugin_to_install{i} ' plugin'] )
        end
        disp([newline 'All the plugins installed successfully. Restarting eeglab'])
        eeglab nogui
    end
    disp([ ...
        newline ...
        'EEGLAB with all the plugins are included in the current MATLAB search path' ...
        newline
    ])

catch
    disp( ...
        "Unable to found any eeglab installation." + newline + ...
        "Please download it or add its path manually by running the command" + ...
        "addpath('/path/to/eeglab')." + newline + ...
        "Make sure to also install all the required plugins:" +...
        "1-  Biosig (v3.8.3+)" + newline +...
        "2-  FastICA (link: http://research.ics.aalto.fi/ica/fastica/)" + newline + ...
        "3-  Fileio (v20240111+)" + newline + ...
        "4-  ICLabel (v1.4+)" + newline + ...
        "5-  MARA (v1.2+)" + newline + ...
        "6-  bva-io (v1.73+)" + newline + ...
        "7-  clean_rawdata (v2.91+)" + newline + ...
        "8-  dipfit (v5.3+)" + newline + ...
        "9-  firfilt (v2.7.1+)" + newline + ...
        "10- eegstats (v1.2+)" + newline ...
    )
    disp(newline + "You can also launch a fresh installation with the function" + ...
        "'install_eeglab_from_scratch(target_path)'")
end

switch nargin
    case 0
        BIDSAlign_GUI
    case 1
        if strcmpi(guistatus, 'nogui')
            disp(newline)
            disp('---------------------------------------------------------')
            disp('  BIDSAlign functions can be excecuted without problems.')
            disp('  To open the GUI, simply run bidsalign.')
            disp('---------------------------------------------------------')
            disp(newline)
        end
end

end