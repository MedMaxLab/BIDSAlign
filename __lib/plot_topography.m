
function [c] = plot_topography(paf_mean, paf, ind_f, groups, mA, chanloc, band_name, F, pipelines, j, c, minPSD, maxPSD, norm, cmap, verbose)  
    % FUNCTION: plot_topography
    %
    % Description: Plot topographic maps of mean power spectral density (PSD) for specified frequency bands.
    %
    % Syntax:
    %   [c] = plot_topography(ind_f, groups, m, chanloc, band_name, F, pipelines, j, c, minPSD, maxPSD, norm, verbose)
    %
    % Input:
    %   - paf_mean (numeric array): Vector of peak alpha frequency (PAF) for each subject.
    %   - paf (logical): Flag indicating whether to consider PAF.
    %   - ind_f (numeric array): Indices of frequency bands.
    %   - groups (cell array): groups or condition names.
    %   - m (numeric array): Mean PSD values.
    %   - chanloc (struct array): Channel locations.
    %   - band_name (cell array): Names of frequency bands.
    %   - F (numeric array): Frequency vector.
    %   - pipelines (cell array): groupss or conditions to plot.
    %   - j (numeric): Index of the groups or condition to plot.
    %   - c (numeric): Index of the subplot.
    %   - minPSD: Minimum value of PSD for groups, for each frequency band.
    %   - maxPSD: Maximum value of PSD for groups, for each frequency band.
    %   - cmap: Colormap used for the topoplots.
    %   - norm: Normalization option for colorbar in the topoplot.
    %   - verbose: Boolean setting the verbosity level.
    %
    % Output:
    %   - c (numeric): Updated index of the subplot.
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]
    %
    % Examples:
    %   c = plot_topography(ind_f, groups, m, chanloc, band_name, F, pipelines, j, c)

    if verbose
        verb = 'on';
    else
        verb = 'off';
    end

    for i=1:length(ind_f)-1
        % if length(groups)>1 && length(pipelines)==1
        %     if length(groups)==2
        %         tiledlayout(length(groups)+1,length(ind_f)-1, 'Padding', 'none', 'TileSpacing', 'compact')
        %         %subplot(length(groups)+1,length(ind_f)-1,c);
        %     else
        %         tiledlayout(length(groups),length(ind_f)-1, 'Padding', 'none', 'TileSpacing', 'compact')
        %         %subplot(length(groups),length(ind_f)-1,c);
        %     end
        % elseif length(groups)==1 && length(pipelines)>1
        %     if length(pipelines)==2
        %         tiledlayout(length(pipelines)+1,length(ind_f)-1, 'Padding', 'none', 'TileSpacing', 'compact')
        %         %subplot(length(pipelines)+1,length(ind_f)-1,c);
        %     else
        %         tiledlayout(length(pipelines),length(ind_f)-1, 'Padding', 'none', 'TileSpacing', 'compact')
        %         %subplot(length(pipelines),length(ind_f)-1,c);
        %     end
        % elseif length(groups)==1 && length(pipelines)==1
        %     tiledlayout(1,length(ind_f)-1, 'Padding', 'none', 'TileSpacing', 'compact')
        %     %subplot(1,length(ind_f)-1,c);
        % end

        [~, ind_f_iafA] = band_content([],paf_mean,paf,ind_f,F,i);

        channelNumbers = length(chanloc);
        [numberOfSubjectsA, ~] = size(ind_f_iafA);

        
        if length(size(mA))==3
            TEST_A = zeros(channelNumbers,numberOfSubjectsA);
            for k=1:numberOfSubjectsA
                TEST_A(:,k) = mean(squeeze(mA(k,ind_f_iafA(k,i):ind_f_iafA(k,i+1),:)),1)';
            end
        elseif length(size(mA))==2
            TEST_A = mA(ind_f_iafA(i):ind_f_iafA(i+1),:)';
        end

        mr = mean(TEST_A,2);
        nexttile;
        if isempty(norm)
            if channelNumbers>20
                topoplot(mr,chanloc,'maplimits',[minPSD(i) maxPSD(i)],'colormap',cmap,'verbose',verb);
            else
                topoplot(mr,chanloc,'electrodes','labels','maplimits',[minPSD(i) maxPSD(i)],'colormap', cmap,'verbose',verb);
            end
        elseif isequal(norm, 'minmax')
            if length(chanloc)>20
                topoplot(mr,chanloc,'maplimits','minmax','colormap',cmap,'verbose',verb);
            else
                topoplot(mr,chanloc,'electrodes','labels','maplimits','minmax','colormap',cmap,'verbose',verb);
            end
        end

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
        c = c+1;
    end
end