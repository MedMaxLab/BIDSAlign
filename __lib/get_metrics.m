
function [ mPxx, sPxx, norm_factor] = get_metrics(Pxx, ch_index, sub_index, mean_over)
    % FUNCTION: get_metrics
    %
    % Description: Calculate mean and standard deviation of power spectral density (PSD) across channels and/or subjects.
    %
    % Syntax:
    %   [mPxx, sPxx, norm_factor] = get_metrics(Pxx, ch_index, sub_index)
    %
    % Input:
    %   - Pxx (numeric array): Power spectral density matrix (subjects x
    %   frequency x channels).
    %   - ch_index (numeric array): Indices of channels to consider.
    %   - sub_index (numeric array): Indices of subjects to consider.
    %   - mean_over (numeric array): Specify in which direction perform the
    %   mean (1: subjects, 2: frequency, 3: channels).
    %
    % Output:
    %   - mPxx (numeric array): Mean PSD across specified channels and/or subjects.
    %   - sPxx (numeric array): Standard deviation of PSD across specified channels and/or subjects.
    %   - norm_factor (numeric): Normalization factor for standard deviation calculation.
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]
    %
    % Examples:
    %   [mPxx, sPxx, norm_factor] = get_metrics(Pxx, [3], [1,2,3])

    %%
    [Nsubj,~,Nch] = size(Pxx);

    if isempty(sub_index)
        sub_index = ':';
    else
        Nsubj = length(sub_index);
    end

    if isempty(ch_index)
        ch_index = ':';
    else
        Nch = length(ch_index);
    end
    
    if (Nch*Nsubj - 1)~=0
        norm_factor = 1/sqrt(Nch*Nsubj - 1);
    else
        norm_factor = 0;
    end

    %norm_factor = 1;

    mPxx = squeeze(mean(Pxx(sub_index,:,ch_index),   mean_over));
    sPxx = squeeze( std(Pxx(sub_index,:,ch_index),[],mean_over));


end