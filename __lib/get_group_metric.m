
function [Pxx_group, F, paf_mean, paf_std] = get_group_metric(folder, filename, NFFT, WINDOW, Lf, Nch, exclude_subj, iav, norm, verbose)
    % FUNCTION: get_group_metric
    %
    % Description: Computes group-level metrics from EEG data.
    %
    % Syntax:
    %   [Pxx_group, F, paf_mean, paf_std] = get_group_metric(folder, filename, ind_f, NFFT, WINDOW, Lf, Nch, exclude_subj, iav, norm, verbose)
    %
    % Input:
    %   - folder (char): Path to the folder containing EEG data.
    %   - filename (char): Filename of a specific EEG recording.
    %   - NFFT (numeric): Length of the FFT window.
    %   - WINDOW (numeric): Window vector.
    %   - Lf (numeric): Length of the frequency vector.
    %   - Nch (numeric): Number of EEG channels.
    %   - exclude_subj (cell array): List of subjects to exclude from analysis.
    %   - iav (logical): Flag indicating whether to compute IAF metrics.
    %   - norm (logical): Standardize channels.
    %   - verbose: Boolean setting the verbosity level.
    %
    % Output:
    %   - Pxx_group (numeric array): Power spectral density tensor for each group.
    %   - F (numeric array): Frequency vector.
    %   - paf_mean (numeric array): Mean peak alpha frequency for each subject.
    %   - paf_std (numeric array): Standard deviation of peak alpha frequency for each subject.
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]
    %
    % See also: restingIAF
    %
    % Examples:
    %   [Pxx_group, F, paf_mean, paf_std] = get_group_metric('data_folder', 256, hanning(256), 128, 64, {'5_1_1_1'}, true)

    modality = 'cog';

    if isempty(filename)
        a = dir([folder '/*.set']);
    else
        a = dir([folder '/' filename '.set']);
    end
    out = size(a,1);

    Pxx_group = zeros(out-length(exclude_subj),Lf,Nch); 
    paf_mean  = zeros(out-length(exclude_subj),1);
    paf_std   = zeros(out-length(exclude_subj),1);

    t=1;
    for i=1:length(a)
        path_file = [folder '/' a(i).name];

        c = true;
        for k = 1:length(exclude_subj)
            c = c && ~contains(path_file,exclude_subj{k});
        end

        if c
            if verbose
                EEG = pop_loadset(path_file);
            else
                [~,EEG] = evalc("pop_loadset(path_file);");
            end
            dataN = EEG.data;


            if norm
                dataN = normalize(dataN,2,'zscore');
            end

            try
                [Pxx,F] = pwelch(dataN',WINDOW,[],NFFT,EEG.srate);
                %Pxx = Pxx./mean(Pxx,1);
            catch
                error(['ERROR IN: ' a(i).name]);
            end

            Pxx_group(t,:,:) = Pxx(2:Lf+1,:);
            F = F(2:Lf+1);

            if iav
                PA_range = [7,14];

                try
                    if verbose
                        [o,~,~] = restingIAF(EEG.data,length(EEG.chanlocs), 3, [1 45],...
                                                EEG.srate, [PA_range], 7, 5, 'nfft',NFFT, 'taper','hanning');
                    else
                        [~,o,~,~] = evalc("restingIAF(EEG.data,length(EEG.chanlocs), 3, [1 45], EEG.srate, PA_range, 7, 5, 'nfft',NFFT, 'taper','hanning');");
                    end
                    
                    if isequel(modality,'paf')
                        paf_mean(t) = o.paf;
                        paf_std(t)  = o.pafStd;
                    elseif isequel(modality,'cog')
                        paf_mean(t) = o.cog;
                        paf_std(t)  = o.cogStd;
                    else
                        error('OTHER METRIC');
                    end

                catch
                    paf_mean(t) = nan;
                    paf_std(t)  = nan;
                end
            
                % %Pxx_group(t,:,:) = [b(:).pxx];
                paf_mean(t) = o.paf;
                paf_std(t)  = o.pafStd;
                % %F = c';
                % 
                % p = plot(F, mean(Pxx(2:Lf+1,:),2));
                % hold on, xline(o.paf,'Color',p.Color);

            end
            t = t+1;
        else
            if verbose
                disp(['File Excluded: ' path_file]);
            end
        end
        c = true;
    end
    % disp(folder)
    % p = plot(squeeze(mean(Pxx_group(:,:,:),[1 3])));
    % hold on, xline(o.paf,'Color',p.Color);
end
