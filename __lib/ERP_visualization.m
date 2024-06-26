function ERP_visualization(folder,dataset,groups,pipelines,filename,save_img,event_name,epoch_lims,exclude_subj,times,channels,verbose)
    % ERP_visualization: Visualizes event-related potentials (ERPs) for a group of subjects.
    %
    % Description: Visualization function, that allows to shows average and
    % grand-average ERP, for multiple channels and events. If there is only
    % one event, scalp topography is plotted at various time steps.
    %
    % Syntax:
    %   ERP_visualization(folder, dataset, groups, pipelines, filename, save_img, 
    %                     event_name, epoch_lims, exclude_subj, times, channels, verbose)
    %
    % Input:
    %   - folder (string): Path to the folder containing EEG data files.
    %   - dataset (string): Name of the dataset.
    %   - groups (cell array of strings): List of group names.
    %   - pipelines (cell array of strings): List of pipeline names.
    %   - filename (string): Name of the EEG data file.
    %   - save_img (string): Optional. Path to save the generated images.
    %   - event_name (string): Name of the event marker.
    %   - epoch_lims (array): Epoch limits [start_time, end_time].
    %   - exclude_subj (cell array of strings): List of subjects to exclude from analysis.
    %   - times (array): Time steps in which display scalp topographies.
    %   - channels (list): List of channels to visualize ERP.
    %   - verbose (logical): Flag indicating whether to display progress messages.
    %
    % Output: None.
    %
    % Author: [Andrea Zanola]
    % Date: [08/03/2024]
    %
    % Example of use:
    %
    % folder   = '/Users/.../_set_preprocessed';
    % save_img = '/Users/.../_png_group_comp/';
    % dataset = 'ds004621';
    % groups = {'ODDBALL'};
    % pipelines = {'FILT','ICA'};
    % filename = [];
    % verbose = false;
    % exclude_subj = {};
    % event_name = {'S  6'}; %S 5 standard, S 7 deviant, S 6 target
    % epoch_lims = [-0.2 1];
    % times = [65 110 180];
    % channels = ["C3","FCZ","C4"];
    %
    % ERP_visualization(folder,dataset,groups,pipelines,filename,save_img,event_name,epoch_lims,exclude_subj,times,channels,verbose);
    %

    %% Optional Inputs
    smooth = 5;
    Nticks = 5;
    colors = {'k','g','r','m','k','c','y'};
    cmap = 'turbo';
    title_size = 16;
    labels_size = 14;
    ticks_size = 12;
    ax_size = 2;

    %% Load First Example
    folder = [folder '/' dataset];
    group = [groups{1} '_' pipelines{1}];
    a = dir([folder group '/*.set']);
    out = size(a,1)-length(exclude_subj);        
    path_file = [a(1).folder '/' a(1).name];
    
    [~,EEG] = evalc("pop_loadset(path_file);");
    [~,EEG] = evalc("pop_epoch(EEG, event_name, epoch_lims, 'epochinfo', 'yes');");
    [~,EEG] = evalc("pop_rmbase(EEG, [epoch_lims(1) 0] ,[]);");
    [a,LERP,c] = size(EEG.data);
    
    listB = strings(1,length(EEG.chanlocs));
    for t=1:length(EEG.chanlocs)
        listB(t) = string(EEG.chanlocs(t).labels);                             
    end
    
    if length(groups)>1 && length(pipelines)==1
        for i=1:length(groups)
            group = [groups{i} '_' pipelines{1}];
            [ERP] = get_group_ERP([folder group], filename, listB, listB, event_name, epoch_lims, LERP, exclude_subj, verbose);
            evalc(['ERP_' pipelines{i} '=ERP']);
        end
        gint = groups;
        pint = pipelines;
    elseif length(pipelines)>=1 && length(groups)==1
        for i=1:length(pipelines)
            group = [groups{1} '_' pipelines{i}];
            [ERP] = get_group_ERP([folder group], filename, listB, listB, event_name, epoch_lims, LERP, exclude_subj, verbose);
            evalc(['ERP_' pipelines{i} '=ERP']);
        end
        gint = groups;
        pint = pipelines;
        groups = pipelines;
        pipelines = gint;
    end
    
    %% Group ERP (x pipelines)
    FigH1 = figure('Position', get(0, 'Screensize'));
    tiledlayout(length(event_name), length(channels),  'Padding', 'compact', 'TileSpacing', 'tight');
    for k=1:length(event_name)
        for i=1:length(channels)
            nexttile;
            for j=1:length(groups)
                ERP = eval(['ERP_' groups{j}]);

                [~,d,~,~] = size(ERP);
                if d~=1
                    norm_factor = 1/sqrt(d-1);
                else
                    norm_factor = 1;
                end
                [channel_index, ~] = get_indexch(listB, channels(i));
    
                m = squeeze(mean(ERP(k,:,:,channel_index),2));
                s = squeeze(std(ERP(k,:,:,channel_index),[],2));
                shadedErrorBar(EEG.times, m, s*norm_factor,{'Color',colors{j}}); hold on;
            end

            title(['event: ' event_name{k} ' | ' convertStringsToChars(channels(i))],'FontSize',title_size);
            lgd = legend(groups);
            lgd.Location ='northeast';
            lgd.FontSize = ticks_size;
            ax = gca;
            ax.XTick = linspace(epoch_lims(1),epoch_lims(2),Nticks)*1000;
            ax.LineWidth = ax_size;
            ax.FontSize = ticks_size;
            xlim([epoch_lims(1) epoch_lims(2)]*1000);
            xlabel('t [ms]','FontSize',labels_size);
            ylabel('\muV','FontSize',labels_size);
            xline(0,'k','HandleVisibility','off');
            yline(0,'k','HandleVisibility','off');
        end
    end
    % if isempty(filename)
    %     if length(gint)==1
    %         sgtitle([dataset ' - Group: ' pipelines{1} ' | Pipelines Comparison']);
    %     else
    %         sgtitle([dataset ' - Pipeline: ' pipelines{1} ' | Groups Comparison']);
    %     end
    % else
    %     sgtitle([filename ' | Pipelines Comparison'],'Interpreter','none');
    % end

    %% Group ERP (x conditions)
    FigH2 = figure('Position', get(0, 'Screensize'));
    tiledlayout(length(groups), length(channels),  'Padding', 'compact', 'TileSpacing', 'tight');

    for j=1:length(groups)
        for i=1:length(channels)
            nexttile;
            for k=1:length(event_name)
                ERP = eval(['ERP_' groups{j}]);
                [~,d,~,~] = size(ERP);
                if d~=1
                    norm_factor = 1/sqrt(d-1);
                else
                    norm_factor = 1;
                end
                [channel_index, ~] = get_indexch(listB, channels(i));
    
                m = squeeze(mean(ERP(k,:,:,channel_index),2));
                s = squeeze(std(ERP(k,:,:,channel_index),[],2));
                shadedErrorBar(EEG.times, m, s*norm_factor,{'Color',colors{k}}); hold on;
            end

            title(['Group: ' groups{j} ' | ' convertStringsToChars(channels(i))],'FontSize',title_size);
            lgd = legend(event_name);
            lgd.Location ='northeast';
            lgd.FontSize = labels_size;
            ax = gca;
            ax.XTick = linspace(epoch_lims(1),epoch_lims(2),Nticks)*1000;
            ax.LineWidth = ax_size;
            ax.FontSize = ticks_size;
            xlim([epoch_lims(1) epoch_lims(2)]*1000);
            xlabel('t [ms]','FontSize',labels_size);
            ylabel('\muV','FontSize',labels_size);
            xline(0,'k','HandleVisibility','off');
            yline(0,'k','HandleVisibility','off');
        end
    end

    % if isempty(filename)
    %     if length(gint)==1
    %         sgtitle([dataset ' - Group: ' pipelines{1} ' | Events Comparison']);
    %     else
    %         sgtitle([dataset ' - Pipeline: ' pipelines{1} ' | Events Comparison']);
    %     end
    % else
    %     sgtitle([filename ' | Events Comparison'],'Interpreter','none');
    % end
    % 
    %% Plot ERP topography
    if verbose
        verb = 'on';
    else
        verb = 'off';
    end
    
    if length(EEG.chanlocs) > 20
        electrode_mode = 'on';
    else
        electrode_mode = 'labels';
    end

    if length(event_name)==1
        FigH3 = figure('Position', get(0, 'Screensize'));
        cmap = colormap(cmap);
        tiledlayout(length(groups),length(times), 'Padding', 'compact', 'TileSpacing', 'tight');
        
        for i=1:length(groups)
            for j=1:length(times)
                m = squeeze(mean(eval(['ERP_' groups{i}]),2));
                [~,ind_t] = min(abs(EEG.times-times(j)));
                nexttile;
                topoplot(m(ind_t,:),EEG.chanlocs,'electrodes',electrode_mode,'colormap',cmap,'maplimits','minmax','verbose',verb);
                title([num2str(EEG.times(ind_t)) ' ms | ' groups{i}],'FontSize',title_size);
        
                cbar = colorbar;
                cbar.Label.String = '\muV';
                cbar.FontSize = labels_size;
            end
        end
        
        % if isempty(filename)
        %     if length(gint)==1
        %         sgtitle([dataset ' - Group: ' pipelines{1} ' | Time Comparison']);
        %     else
        %         sgtitle([dataset ' - Pipeline: ' pipelines{1} ' | Time Comparison']);
        %     end
        % else
        %     sgtitle([filename ' | Time Comparison'],'Interpreter','none');
        % end
    end

    %% Single file ERP
    minPSD = 10^20;
    maxPSD = 10^(-20);
    
    if ~isempty(filename) && length(event_name)==1
        FigH4 = figure('Position', get(0, 'Screensize'));
        tiledlayout(length(groups)+1,length(channels), 'Padding', 'compact', 'TileSpacing', 'tight');
        count=1;
        for i=1:length(groups)
            if length(gint)>1
                [~,EEG] = evalc("pop_loadset([folder gint{i} '_' pint{1} '/' filename '.set']);");
            else
                [~,EEG] = evalc("pop_loadset([folder gint{1} '_' pint{i} '/' filename '.set']);");
            end
            [~,EEG] = evalc("pop_epoch(EEG, event_name, epoch_lims, 'epochinfo', 'yes');");
            [~,EEG] = evalc("pop_rmbase(EEG, [epoch_lims(1) 0] ,[]);");
            [~] = evalc(['EEG_' groups{i} '=EEG;']);

            for j=1:length(channels)

                [channel_index, ~] = get_indexch(listB, channels(j));
                if isempty(channel_index)
                    error('CHANNEL NOT FOUND');
                else
                    titl = [EEG.chanlocs(channel_index).labels ' | ' groups{i}];
                end
    
                nexttile;
                ERP_matrix = squeeze(EEG.data(channel_index,:,:))';
                ERP_matrix_mean = movmean(ERP_matrix,smooth);
    
                imagesc(EEG.times,1:1:c,ERP_matrix_mean);
                ylabel('Trials','FontSize',labels_size);
                xlabel('Time [ms]','FontSize',labels_size);
                cmap = colormap('jet');
                title(titl,'FontSize',title_size);

                ax = gca;
                ax.LineWidth = ax_size;
                ax.FontSize = ticks_size;
                ax.XTick = linspace(epoch_lims(1),epoch_lims(2),5)*1000;
                cbar = colorbar(ax);
                cbar.FontSize = labels_size;

                minPSD = min([minPSD min(ERP_matrix_mean,[],"all")]);
                maxPSD = max([maxPSD max(ERP_matrix_mean,[],"all")]);
                count = count+1;
            end
        end
   
        for j=1:length(channels)
            nexttile;
            [channel_index, ~] = get_indexch(listB, channels(j));
            for i=1:length(groups)
                EEG = eval(['EEG_' groups{i}]);
                channel_ERP_mean = squeeze(mean(EEG.data(channel_index,:,:),3)');
                channel_ERP_std  = squeeze(std(EEG.data(channel_index,:,:),[],3)');
                norm_factor = 1/sqrt(c-1);
                shadedErrorBar(EEG.times,channel_ERP_mean, channel_ERP_std*norm_factor,{'Color',colors{i}}); hold on;
            end
            title([EEG.chanlocs(channel_index).labels],'FontSize',title_size)
            lgd = legend(groups);
            lgd.Location ='northwest';
            lgd.FontSize = ticks_size;
            ax = gca;
            ax.LineWidth = ax_size;
            ax.FontSize = ticks_size;
            ax.XTick = linspace(epoch_lims(1),epoch_lims(2),5)*1000;
            xlabel('Time [ms]','FontSize',labels_size);
            ylabel('Potential [\muV]','FontSize',labels_size);
        end

        %sgtitle([filename ' event: ' event_name{1} ' | ERP Comparison'],'Interpreter','none');
    end
    
    %% Save Imgs
    if ~isempty(save_img)
        saveas(FigH1,[save_img dataset '_' pipelines{1} '_AVGERP.png']);
        saveas(FigH2,[save_img dataset '_events_AVGERP.png']);
        if length(event_name)==1
            saveas(FigH3,[save_img dataset '_' pipelines{1} '_topoplot.png']);
        end
        if ~isempty(filename) && length(event_name)==1
            saveas(FigH4,[save_img dataset '_' pipelines{1} '_ERP.png']);
        end
    end

end