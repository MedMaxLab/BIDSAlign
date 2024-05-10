
function [listB, chanloc, NFFT, WINDOW, Nch, ind_f, Lf] = get_info_file(folder, exclude_subj, freq_vec, srate)
    % FUNCTION: get_info_file
    %
    % Description: Extracts information from an EEG data file.
    %
    % Syntax:
    %   [listB, chanloc, NFFT, WINDOW, Nch, ind_f, Lf] = get_info_file(folder, exclude_subj, freq_vec, srate)
    %
    % Input:
    %   - folder (string): Path to the folder containing EEG data files.
    %   - exclude_subj (cell array of strings): List of subjects to exclude from analysis.
    %   - freq_vec (vector): Frequency vector.
    %   - srate (double): Sampling rate loaded from the preprocessing info setting.
    %
    % Output:
    %   - listB (cell array of strings): List of channel names.
    %   - chanloc (struct array): EEG channel locations.
    %   - NFFT (integer): Length of the FFT.
    %   - WINDOW (vector): Hanning window.
    %   - Nch (integer): Number of channels.
    %   - ind_f (vector): Indices corresponding to frequency vector.
    %   - Lf (integer): Length of frequency vector.
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]

    try
        a = dir([folder '/*.set']);
        out = size(a,1)-length(exclude_subj);   
        path_file = [a(1).folder '/' a(1).name];
        [~,EEG] = evalc("pop_loadset(path_file);");
    catch
        a = dir([folder '/*.mat']);
        out = size(a,1)-length(exclude_subj);   
        path_file = [a(1).folder '/' a(1).name];

        EEGmat = load(path_file);
        EEG.data = EEGmat.DATA_STRUCT.data;
        EEG.srate = srate;
        [EEG.nbchan, EEG.pnts] = size(EEG.data);
        for i=1:EEG.nbchan
            EEG.chanlocs(i).labels = EEGmat.DATA_STRUCT.template(i,:);
        end
        EEG.xmin = 0;
        EEG.xmax = EEG.pnts/EEG.srate;
    end

    % Get Channel Names
    listB = strings(1,length(EEG.chanlocs));
    for t=1:length(EEG.chanlocs)
        listB(t) = string(EEG.chanlocs(t).labels);                             
    end

    % PSD metrics
    NFFT    = 2^(nextpow2(EEG.srate)+1); %next power for 0.5Hz 
    WINDOW  = hanning(NFFT);
    [~,F] = pwelch(EEG.data',WINDOW,[],NFFT,EEG.srate);
    Nch = EEG.nbchan;

    t = length(freq_vec);
    ind_f = zeros(1,t);
    for i=1:t
        [~,ind_f(i)] = min(abs(F-freq_vec(i)));
    end
    Lf = length(F(1:ind_f(end)));

    chanloc = EEG.chanlocs;

end