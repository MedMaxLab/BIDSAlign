
% Function: import_data
% Description: Imports EEG data from various file formats using EEGLAB functions.
%
% Input:
%   - raw_filename: Name of the EEG data file (including the file extension).
%   - raw_filepath: Path to the directory where the EEG data file is located.
%
% Output:
%   - EEG: EEG data structure loaded from the specified file. If loading fails
%          or the file format is unsupported, EEG will be an empty array ([]).
%
% Supported EEG File Formats:
%   - .set: EEG data is loaded using 'pop_loadset' from EEGLAB.
%   - .vhdr: EEG data is loaded using 'pop_loadbv' from EEGLAB.
%   - .edf or .bdf: EEG data is loaded using 'pop_biosig' from EEGLAB.
%
% Usage example:
%   EEG = import_data('sample_data.set', '/path/to/data/', struct('eeg_file_extension', '.set'));
%
% Note: Make sure EEGLAB is installed and configured properly in your MATLAB environment.

% Author: [Andrea Zanola]
% Date: [04/10/2023]

function EEG = import_data(raw_filename, raw_filepath)
    
    [~,~,eeg_file_extension] = fileparts(raw_filename);

    if isequal(eeg_file_extension,'.set')
        try
            EEG = pop_loadset('filename',raw_filename,'filepath',raw_filepath);
        catch
            EEG = [];
            disp(['CORRUPTED .SET FILE: ' raw_filepath raw_filename]);
        end

    elseif isequal(eeg_file_extension,'.vhdr')
        try
            EEG = pop_loadbv(raw_filepath, raw_filename,  [1:-1], [1:-1]);
        catch
            EEG = [];
            disp(['CORRUPTED .VHDR FILE: ' raw_filepath raw_filename]);
        end
    elseif isequal(eeg_file_extension,'.edf') || isequal(eeg_file_extension,'.bdf')
        try
            EEG = pop_biosig(raw_filename); 
        catch
            EEG = [];
            disp(['CORRUPTED .EDF or .BDF FILE: ' raw_filepath raw_filename]);
        end
    else
        error('ERROR: UNSUPPORTED EEG FILE EXTENSION');
    end


end
