
function [minPSD, maxPSD] = plot_channels_PSD(m,s,norm_factor, color, F, minPSD, maxPSD)
    % FUNCTION: plot_channels_PSD
    %
    % Description: Plot power spectral density (PSD) with shaded error bars representing standard deviation.
    %
    % Syntax:
    %   [minPSD, maxPSD] = plot_channels_PSD(m, s, norm_factor, color, group, F, minPSD, maxPSD)
    %
    % Input:
    %   - m (numeric array): Mean PSD.
    %   - s (numeric array): Standard deviation of PSD.
    %   - norm_factor (numeric): Normalization factor for standard deviation.
    %   - color (char): Color for the plot.
    %   - F (numeric array): Frequency vector.
    %   - minPSD (numeric): Minimum PSD value.
    %   - maxPSD (numeric): Maximum PSD value.
    %
    % Output:
    %   - minPSD (numeric): Updated minimum PSD value.
    %   - maxPSD (numeric): Updated maximum PSD value.
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]
    %

    upper = m + s*norm_factor;
    lower = m - s*norm_factor;

    maxPSD = max([maxPSD, max(upper,[],'all')]); 
    minPSD = min([minPSD, min(lower,[],'all')]);

    [~] = shadedErrorBar(F,m,s*norm_factor, {'Color',color}); hold on;

end