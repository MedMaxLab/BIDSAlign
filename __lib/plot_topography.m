
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

    title_size = 26;
    labels_size = 24;
    ticks_size = 22;
    ax_size = 2;

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
        range = norm;
    end

    %topoplot(mr,chanloc,'electrodes',electrode_mode,'maplimits',range,'colormap',cmap,'verbose',verb);
    topoplot(mA,chanloc,'electrodes',electrode_mode,'maplimits',range,'colormap',cmap,'verbose',verb);

    if ~fdr_plot
        if length(groups)>1 && length(pipelines)==1
            title([band_name{i} ' @' sprintf('%0.1f',F(ind_f(i))) '-' sprintf('%0.1f',F(ind_f(i+1))) 'Hz | ' groups{j}],'FontSize',title_size);
        elseif length(groups)==1 && length(pipelines)>1
            title([band_name{i} ' @' sprintf('%0.1f',F(ind_f(i))) '-' sprintf('%0.1f',F(ind_f(i+1))) 'Hz | ' pipelines{j}],'FontSize',title_size);
        elseif length(groups)==1 && length(pipelines)==1
            title([band_name{i} ' @' sprintf('%0.1f',F(ind_f(i))) '-' sprintf('%0.1f',F(ind_f(i+1))) 'Hz | ' groups{1} '- ' pipelines{1}],'FontSize',title_size);
        end
        cbar = colorbar;
        cbar.Label.String = 'PSD [\muV^2/Hz]';
        cbar.FontSize = labels_size;
    else
        if length(groups)>1 && length(pipelines)==1
            title([groups{1} ' vs ' groups{2} ' | ' string_topoplot ' FDR correct'],'FontSize',title_size);
        elseif length(groups)==1 && length(pipelines)>1
            title([pipelines{1} ' vs ' pipelines{2} ' | ' string_topoplot ' FDR correct'],'FontSize',title_size);
        end
        cbar = colorbar;
        cbar.Label.String = 't statistic';
        if maxPSD ~=0
            cbar.Ticks = ceil(minPSD):1:floor(maxPSD);
            if length(cbar.Ticks)>10
                cbar.Ticks = ceil(minPSD):4:floor(maxPSD);
            elseif length(cbar.Ticks)>5
                cbar.Ticks = ceil(minPSD):2:floor(maxPSD);
            end
        else
            cbar.Ticks = linspace(-1,1,5);
        end
        cbar.FontSize = labels_size;

    end
    
end