
function EEG = import_data(raw_filename, raw_filepath, data_info)
    
    eeg_file_extension = convertCharsToStrings(data_info.eeg_file_extension);
    %nchan              = data_info.nchan;

    if eeg_file_extension == ".set"
        EEG = pop_loadset('filename',raw_filename,'filepath',raw_filepath);

    elseif eeg_file_extension == ".vhdr"
        EEG = pop_loadbv(raw_filepath, raw_filename,  [1:-1], [1:-1]);

    elseif eeg_file_extension == ".edf" || eeg_file_extension == ".bdf"
        EEG = pop_biosig(raw_filename); 

%     elseif eeg_file_extension == ".csv" && ~isempty(nchan) 
%         %number of channels
%         if nchan < 0 || mod(nchan, 1) ~= 0
%             error("ERROR: NEGATIVE OR NON-INTEGER NUMBER OF CHANNELS");
%         else
%             raw_file = csvread(raw_filename);
%             if min(size(raw_file))==1                   %IF DATA ARE SAVED WITH A ONE COLUMN FORMAT. (see TDBRAIN)
%                 L = length(raw_file)/nchan;             
%                 if rem(length(raw_file),nchan)==0
%                     raw_file = reshape(raw_file,[L,nchan]);
%                     raw_file = raw_file';
%                 else
%                     error("ERROR: LENGHT OF DATA NOT MULTIPLE OF CHANNEL NUMBERS");
%                 end
%             %else is not needed, because raw_file already calculated
%             end
%             EEG = pop_importdata('dataformat','array','nbchan',nchan,'data',raw_file,'srate',data_info.samp_rate,'chanlocs',data_info.channel_location_filename,...
%                                  'pnts',0,'xmin',0);
%         end
    else
        error("ERROR: UNSUPPORTED EEG FILE EXTENSION");
    end


end