function [] = install_eeglab_from_scratch(target_path)
% FUNCTION: install_eeglab_from_scratch
%
% Description: Run a new fresh installation of eeglab and the list of plugins requires
%              by BIDSAlign inside the target directory.
%
% Syntax:
%   install_eeglab_from_scratch( target_path )
%
% Input:
%   - target_path (char): String or char array with the target path. eeglab will be
%                         installed in this path. (Default: current working directory)
%
% Output: 
%   - None. It throws an error if the installation fails.
%
% Author: [Federico Del Pup]
% Date: [15/07/2024]
%

if nargin == 0
    target_path = pwd;
end
current_path = pwd;

try
    disp(newline)
    disp('-------------------------------------------------------------------')
    disp('The installation of eeglab and all the plugins will take some time.')
    disp('-------------------------------------------------------------------')
    disp(newline)
    disp('Installing eeglab via git in the target directory')
    cd(target_path)
    try
        !git clone --recurse-submodules https://github.com/sccn/eeglab.git
    catch
        disp('git not available. Downloading zip file from github')
        websave( ...
            'eeglab.zip', ...
            'https://github.com/sccn/eeglab/archive/refs/heads/develop.zip' ...
        );
        unzip('eeglab.zip', target_path)
        movefile('eeglab-develop', 'eeglab')
        delete eeglab.zip
        cd('eeglab')
        websave( ...
            'tutorial_scripts.zip', ...
            'https://github.com/sccn/eeglab_tutorial_scripts/archive/refs/heads/master.zip' ...
        );
        unzip('tutorial_scripts.zip')
        delete tutorial_scripts.zip
        movefile('eeglab_tutorial_scripts-master', 'tutorial_scripts')
        cd('plugins')
        rmdir('*')
        cd('..')
        cd('..')
    end
    addpath('eeglab')
    eeglab nogui
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
        disp(['Installing the following dependencies (plugins):' newline])
        for i=1:length(plugin_to_install)
            disp([num2str(i) '- ' plugin_to_install{i}])
        end
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
        newline ...
        'You can now use BIDSAlign without problems (hopefully)'
    ])
catch
    disp('Something went wrong.')
    disp('Failed to install a fresh eeglab with all the plugins.')
    disp('Go to https://eeglab.org/ and follow the installation guide.')
    disp("Then, try to run 'bidsalign nogui' to install all the dependencies")
    disp('or use the plugin manager (GUI based)')
    cd(current_path)
end
end