
function plot_topography(ind_f, groups, mA, chanloc, band_name, F, pipelines, j, minPSD, maxPSD, norm, cmap, i, fdr_plot, string_topoplot, verbose)  
    % FUNCTION: plot_topography
    %
    % Description: Plot topographic maps of mean power spectral density (PSD) for specified frequency bands.
    %
    % Syntax:
    %   plot_topography(ind_f, groups, mA, chanloc, band_name, F, pipelines, j, minPSD, maxPSD, norm, cmap, i, verbose)
    %
    % Input:
    %   - ind_f (numeric array): Indices of frequency bands.
    %   - groups (cell array): groups or condition names.
    %   - m (numeric array): Mean PSD values.
    %   - chanloc (struct array): Channel locations.
    %   - band_name (cell array): Names of frequency bands.
    %   - F (numeric array): Frequency vector.
    %   - pipelines (cell array): groupss or conditions to plot.
    %   - j (numeric): Index of the groups or condition to plot.
    %   - minPSD: Minimum value of PSD for groups, for each frequency band.
    %   - maxPSD: Maximum value of PSD for groups, for each frequency band.
    %   - cmap: Colormap used for the topoplots.
    %   - norm: Normalization option for colorbar in the topoplot.
    %   - fdr_plot: Boolean indicating if fdr plot.
    %   - string_topoplot: Topoplot FDR custom title.
    %   - verbose: Boolean setting the verbosity level.
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]
    %

    if verbose
        verb = 'on';
    else
        verb = 'off';
    end

    nexttile;

    if length(chanloc) > 20
        electrode_mode = 'on';
    else
        electrode_mode = 'labels';
    end

    if isempty(norm)
        range = [minPSD maxPSD];
    else
        range = 'minmax';
    end

    %topoplot(mr,chanloc,'electrodes',electrode_mode,'maplimits',range,'colormap',cmap,'verbose',verb);
    topoplot(mA,chanloc,'electrodes',electrode_mode,'maplimits',range,'colormap',cmap,'verbose',verb);

    if ~fdr_plot
        if length(groups)>1 && length(pipelines)==1
            title([band_name{i} ' @' num2str(F(ind_f(i)),3) '-' num2str(F(ind_f(i+1)),3) 'Hz | ' groups{j}],'FontSize',14);
        elseif length(groups)==1 && length(pipelines)>1
            title([band_name{i} ' @' num2str(F(ind_f(i)),3) '-' num2str(F(ind_f(i+1)),3) 'Hz | ' pipelines{j}],'FontSize',14);
        elseif length(groups)==1 && length(pipelines)==1
            title([band_name{i} ' @' num2str(F(ind_f(i)),3) '-' num2str(F(ind_f(i+1)),3) 'Hz | ' groups{1} '- ' pipelines{1}],'FontSize',14);
        end
        cbar = colorbar;
        cbar.Label.String = 'PSD [\muV^2/Hz]';
        cbar.FontSize = 10;
    else
        if length(groups)>1 && length(pipelines)==1
            title([groups{1} ' vs ' groups{2} ' | ' string_topoplot ' FDR corrected'],'FontSize',14);
        elseif length(groups)==1 && length(pipelines)>1
            title([pipelines{1} ' vs ' pipelines{2} ' | ' string_topoplot ' FDR corrected'],'FontSize',14);
        end
        cbar = colorbar;
        cbar.Label.String = 't statistic';
        cbar.FontSize = 10;
        if maxPSD ~=0
            cbar.Ticks = linspace(minPSD,maxPSD,7);
        end
    end
    
end