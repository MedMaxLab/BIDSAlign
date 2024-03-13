
function groups_visualization(folder, filename, save_img, git_path, dataset, groups, pipelines, paf, exclude_subj, channel_system, verbose)
    % FUNCTION: groups_visualization
    %
    % Description: Generates visualizations of EEG data for different groups.
    %
    % Syntax:
    %   groups_visualization(folder, save_img, dataset, groups, pipelines, paf, exclude_subj)
    %
    % Input:
    %   - folder (char): Path to the folder containing EEG data.
    %   - filename (char): Specific Filename to be visualized.
    %   - save_img (char): Path to save the generated images.
    %   - lib_path (char): Path to the BIDSAlign folder.
    %   - dataset (char): Name of the dataset.
    %   - groups (cell array): Group names for visualization.
    %   - pipelines (cell array): Pipelines names for visualization.
    %   - paf (logical): Indicates whether to calculate and plot Peak Alpha Frequency (PAF) or not.
    %   - exclude_subj (cell array): File names of subject to exclude from visualization.
    %   - channel_system (char): Channel system used in the dataset.
    %   - verbose: Boolean setting the verbosity level.
    %
    % Output:
    %   None
    %
    % Author: [Andrea Zanola]
    % Date: [23/02/2024]
    %
    % See also: get_group_metric, plot_channels_PSD, plot_topography
    %

    if length(groups)>1 && length(pipelines)>1
        error('YOU CANNOT PREPROCESS MULTIPLE GROUPS WITH MULTIPLE PIPELINES');
    end

    %% Optional Input Variables
    
    freq_vec = [0.1,4,8,13,30,44];
    pth = 0.05;
    norm_cbar_topo = [];
    norm_data = false;
    test_parametric = false;
    FDR_correction = true;
    nperms = 20000;

    title_size  = 26;
    labels_size = 24;
    ticks_size  = 22;
    ax_size = 2;

    chgroups.g1 = ["AF7","AF3","F7","F5","F3","F1"];
    chgroups.g2 = ["AFZ","FZ","FPZ","FP1","FP2"];
    chgroups.g3 = ["AF8","AF4","F8","F6","F4","F2"];
    chgroups.g4 = ["FT7","T7","TP7","FC5","C5","CP5"];
    chgroups.g5 = ["FCZ","CZ","CPZ","FC1","C1","CP1","FC2","C2","CP2"];
    chgroups.g6 = ["FT8","T8","TP8","FC6","C6","CP6"];
    chgroups.g7 = ["P7","P5","PO7","PO3","P3"];
    chgroups.g8 = ["POZ","OZ","O1","O2"];
    chgroups.g9 = ["P8","P6","PO8","PO4","P4"];

    tchgroups.g1 = ["F5"];
    tchgroups.g2 = ["AFZ"];
    tchgroups.g3 = ["F6"];
    tchgroups.g4 = ["T7"];
    tchgroups.g5 = ["CZ"];
    tchgroups.g6 = ["T8"];
    tchgroups.g7 = ["P5"];
    tchgroups.g8 = ["POZ"];
    tchgroups.g9 = ["P4"];
    
    band_name = {'\delta','\theta','\alpha','\beta','\gamma'};
    colors = {'r','b','g','m','k','c','y'};
    cmap = 'turbo';
    
    %%  Load first example to calculate and fix quantities
    folder = [folder '/' dataset];
    group = [groups{1} '_' pipelines{1}];
    a = dir([folder group '/*.set']);
    out = size(a,1)-length(exclude_subj);        
    path_file = [a(1).folder '/' a(1).name];
    [~,EEG] = evalc("pop_loadset(path_file);");

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
    
    %% Import Data and Get PSD, ERP matrix per group

    if length(groups)>=1 && length(pipelines)==1
        for i=1:length(groups)
            group = [groups{i} '_' pipelines{1}];
            [Pxx,F, paf_mean, paf_std] = get_group_metric([folder group], filename, NFFT, WINDOW, Lf, Nch, exclude_subj, paf, norm_data, verbose);
            evalc(['Pxx_' groups{i} '=Pxx']);
            evalc(['paf_mean_' groups{i} '=paf_mean']);
            evalc(['paf_std_' groups{i} '=paf_std']);
        end

        gint = groups;
        pint = pipelines;
    elseif length(pipelines)>1 && length(groups)==1
        for i=1:length(pipelines)
            group = [groups{1} '_' pipelines{i}];
            [Pxx,F, paf_mean, paf_std] = get_group_metric([folder group], filename, NFFT, WINDOW, Lf, Nch, exclude_subj, paf, norm_data, verbose);
            
            evalc(['Pxx_' pipelines{i} '=Pxx']);
            evalc(['paf_mean_' pipelines{i} '=paf_mean']);
            evalc(['paf_std_' pipelines{i} '=paf_std']);
        end 
        gint = groups;
        pint = pipelines;
        groups = pipelines;
        pipelines = gint;
    end

    t = length(freq_vec);
    ind_f = zeros(1,t);
    for i=1:t
        [~,ind_f(i)] = min(abs(F-freq_vec(i)));
    end
    
    %% PSD
    fn = fieldnames(chgroups);

    % Find Channel corrispondance in differet Channel systems
    if isequal(channel_system,'GSN129') || isequal(channel_system,'GSN257')
        filenameconvfile = [git_path '__lib/template/template_channel_conversion/conv_' channel_system '_1010.mat'];
        if isfile(filenameconvfile)
            a = load(filenameconvfile);
            evalc(['a=a.conv' channel_system]);
        else
            error(['CONVERSION FILE NOT FOUND:' filenameconvfile]);
        end
    
        if ~isempty(a)
            for j=1:length(fn)
                for i=1:length(chgroups.(fn{j}))
                    d = find(a(:,1)==chgroups.(fn{j})(i));
                    if ~isempty(d)
                        chgroups.(fn{j})(i) = a(d,2);
                    else
                        chgroups.(fn{j})(i) = [];
                    end
                end
            end
        end
    end

    
    FigH1 = figure('Position', get(0, 'Screensize')); 
    tiledlayout(ceil(sqrt(length(fn))),ceil(sqrt(length(fn))), 'Padding', 'compact', 'TileSpacing', 'tight');

    % Generate PSD Plots
    for i=1:length(fn)
        
        [ch_index, ch_considered] = get_indexch(listB, chgroups.(fn{i}));
    
        minPSD=10^20;
        maxPSD=-10^20;
        
        nexttile;
        for j=1:length(groups)
            [ m, s, norm_factor] = get_metrics(eval(['Pxx_' groups{j}]), ch_index, [], [1 3]);
            [minPSD, maxPSD] = plot_channels_PSD(m, s, norm_factor, colors{j}, F, minPSD, maxPSD);
        end
    
        letter_y = maxPSD*1.2;
        xline(4,'--','Color','#808080'); xline(8,'--','Color','#808080'); 
        xline(13,'--','Color','#808080');xline(30,'--','Color','#808080');
        text(2,letter_y,'\delta','FontSize',ticks_size);
        text(6,letter_y,'\theta','FontSize',ticks_size);text(10,letter_y,'\alpha','FontSize',ticks_size);
        text(22,letter_y,'\beta','FontSize',ticks_size);text(40,letter_y,'\gamma','FontSize',ticks_size);
        
        ax = gca;
        ax.YAxis.Scale ="log";
        ax.LineWidth = ax_size;
        ax.FontSize = ticks_size;
        axis([F(1) F(end) minPSD*0.8 maxPSD*1.6]);
        title(['Mean PSD | chs: '  convertStringsToChars(strjoin(ch_considered))],'FontSize',title_size);
        xlabel('f [Hz]','FontSize',labels_size);
        ylabel('PSD [\muV^2/Hz]','FontSize',labels_size);
        grid on;
        lgd = legend(groups);
        lgd.Location ='southwest';
        lgd.FontSize = ticks_size;
    end
    % if isempty(filename)
    %     if length(gint)==1
    %         sgtitle([dataset ' - Group: ' pipelines{1} ' | Channels Comparison']);
    %     else
    %         sgtitle([dataset ' - Pipeline: ' pipelines{1} ' | Channels Comparison']);
    %     end
    % else
    %     sgtitle([filename ' | Channels Comparison'],'Interpreter','none');
    % end
    
    %% Boxplot
    if isempty(filename)
        FigH2 = figure('Position', get(0, 'Screensize'));
        tiledlayout(2,3, 'Padding', 'compact', 'TileSpacing', 'tight');
        
        positions = zeros(length(groups)*(length(groups)-1)/2,2);
        ep = 0.1;
        c=1;
        for j=1:length(groups)
            for k=j+1:length(groups)
                positions(c,:) = [j+ep k-ep];
                c = c+1;
            end
        end
        
        for i=1:length(ind_f)-1
            nexttile;
            g = [];
            x = [];
            
            for j=1:length(groups)
                [ m, ~, ~] = get_metrics(eval(['Pxx_' groups{j}]), [], [], [3]);
                [ar, ~] = band_content(m,eval(['paf_mean_' groups{j}]),paf,ind_f,F,i);
                evalc(['ar' num2str(j) '=ar;']);
                g = [g; j*ones(length(ar),1)];
                x = [x; ar];
            end
    
            if verbose
                bo = boxplot(x, g, 'Labels',groups); 
                hold on;
            else
                [~, bo] = evalc("boxplot(x, g, 'Labels', groups);");
                hold on;
            end
            set(bo,{'linew'},{2});
            ax = gca;
            ax.FontSize = 12;
            
            if ~isempty(ch_index) && length(ch_index)==1
                label_ch = ['- Channel ' EEG.chanlocs(ch_index).labels];
            else
                label_ch = '';
            end
            title(['Mean PSD ' label_ch ' | ' band_name{i} ' ' sprintf('%0.1f',F(ind_f(i))) '-' sprintf('%0.1f',F(ind_f(i+1))) 'Hz'],'FontSize',title_size);
            ylabel('PSD [\muV^2/Hz]','FontSize',labels_size);
        
            bandmax = max(x,[],'all');
            bandmin = min(x,[],'all');
            coeff = 1.5;
            yt = 0.8*bandmax;
            ylim([bandmin*0.8  bandmax*coeff]);
            yspace = linspace(0.2, coeff-1.1, length(groups)*(length(groups)-1)/2);
        
            c=1;
            for j=1:length(groups)
                for k=j+1:length(groups)
        
                    [H_FDR, P_FDR, ~, ~] = group_statistics(eval(['ar' num2str(j)]),eval(['ar' num2str(k)]), pth, test_parametric, FDR_correction, nperms);
                    
                    if H_FDR
                        if verbose
                            disp('----------');
                            disp([band_name{i} ' | ' groups{j} ' vs ' groups{k} ' p-val: ' num2str(min(P_FDR))]);
                        end
                        plot(positions(c,:), [1 1]*yt*(1+yspace(c)), '-k', mean(positions(c,:)), yt*(1.1+yspace(c)), '*k','LineWidth',1.5);
    
                        if min(P_FDR)<0.001
                            pstr = '<0.001';
                        else
                            pstr = ['=' num2str(min(P_FDR),'%.3f')];
                        end
                        text(mean(positions(c,:))*1.05,yt*(1.1+yspace(c))*1.12,['p' pstr],'FontSize',ticks_size);
                    end
                    c = c+1;
                end
            end
            ax = gca;
            ax.YAxis.Scale = "log";
            ax.LineWidth = ax_size;
            ax.FontSize = ticks_size;
            grid on;
        end
        
        if ~paf && ~isempty(save_img)
            saveas(FigH2,[save_img dataset '_' pipelines{1} '_boxplot.png']);
        end
 
        %% Boxplot PAF
        if paf
            nexttile;
            
            g = [];
            x = [];
            for j=1:length(groups)
            
                g = [g; j*ones(eval(['length(paf_mean_' groups{j} ')']), 1)];
                x = [x; eval(['paf_mean_' groups{j}])];
            end
            if verbose
                bo = boxplot(x, g, 'Labels',groups);
            else
                [~, bo] = evalc("boxplot(x,g, 'Labels',groups);");
            end
            set(bo,{'linew'},{2});
            hold on;
            
            bandmax = max(x,[],'all');
            bandmin = min(x,[],'all');
            yt = 0.8*bandmax;
            coeff = 1.5;
            ylim([bandmin*0.8  bandmax*coeff]);
            
            yspace = linspace(0.2, coeff-1.1, length(groups)*(length(groups)-1)/2);
            
            c=1;
            for j=1:length(groups)
                for k=j+1:length(groups)
            
                    [ H_FDR, P_FDR, ~, ~] = group_statistics(eval(['paf_mean_' groups{j}]), eval(['paf_mean_' groups{k}]), pth, test_parametric, FDR_correction, nperms);
    
                    if H_FDR
                        if verbose
                            disp('----- IAF -----')
                            disp([groups{j} ' vs ' groups{k} ' p-val: ' num2str(min(P_FDR))]);
                        end
                        plot(positions(c,:), [1 1]*yt*(1+yspace(c)), '-k', mean(positions(c,:)), yt*(1.1+yspace(c)), '*k','LineWidth',1.5);
                        if min(P_FDR)<0.001
                            pstr = '<0.001';
                        else
                            pstr = ['=' num2str(min(P_FDR),'%.3f')];
                        end
                        text(mean(positions(c,:))*1.05,yt*(1.1+yspace(c)),['p' pstr],'FontSize',ticks_size);
                    end
                    c = c+1;
                end
            end
            ax = gca;
            ax.FontSize = ticks_size;
            ax.LineWidth = ax_size;
            title('Individual Alpha Frequency','FontSize',title_size);
            ylabel('IAF [Hz]','FontSize',labels_size);
            grid on;
        end
    
        % if isempty(filename)
        %     if length(gint)==1
        %         sgtitle([dataset ' - Group: ' pipelines{1} ' | Band Comparison']);
        %     else
        %         sgtitle([dataset ' - Pipeline: ' pipelines{1} ' | Band Comparison']);
        %     end
        % else
        %     sgtitle([filename ' | Band Comparison'],'Interpreter','none');
        % end
        if paf && ~isempty(save_img)
            saveas(FigH2,[save_img dataset '_' pipelines{1} '_boxplot.png']);
        end
    end

    %% Topolots PSD
    FigH3 = figure('Position', get(0, 'Screensize'));
    cmap = colormap(cmap);

    if length(groups)>1 && length(pipelines)==1
        if length(groups)==2
            if isempty(filename)
                tiledlayout(length(groups)+1,length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
            else
                tiledlayout(length(groups),length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
            end
        else
            tiledlayout(length(groups),length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
        end
    elseif length(groups)==1 && length(pipelines)>1
        if length(pipelines)==2
            if isempty(filename)
                tiledlayout(length(pipelines)+1,length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
            else
                tiledlayout(length(pipelines),length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
            end
        else
            tiledlayout(length(pipelines),length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
        end
    elseif length(groups)==1 && length(pipelines)==1
        tiledlayout(1,length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
    end

    % Extract Max-Min for Topoplot-Colormap
    minPSD = (10^20)*ones(1,length(ind_f)-1);
    maxPSD = (-10^20)*ones(1,length(ind_f)-1); 

    for j=1:length(groups)
        for i=1:length(ind_f)-1
            
            [TEST, ~] = band_content(eval(['Pxx_' groups{j}]),eval(['paf_mean_' groups{j}]),paf,ind_f,F,i); 
            mA = mean(TEST,1);
            minPSD(i) = min([minPSD(i),min(mA)]);
            maxPSD(i) = max([maxPSD(i),max(mA)]);
        end
    end

    % Plot Topography
    for j=1:length(groups)
        for i=1:length(ind_f)-1
            [TEST_A, ~] = band_content(eval(['Pxx_' groups{j}]),eval(['paf_mean_' groups{j}]),paf,ind_f,F,i);
            mA = mean(TEST_A,1);
            plot_topography(ind_f, groups, mA, EEG.chanlocs, band_name, F, pipelines, j, minPSD(i), maxPSD(i), norm_cbar_topo, cmap, i, false, '', verbose);
        end
    end

    %% Permutation t-test
    if length(groups)==2 && isempty(filename)
        for i=1:length(ind_f)-1

            [TEST_A, ~] = band_content(eval(['Pxx_' groups{1}]),eval(['paf_mean_' groups{1}]),paf,ind_f,F,i);
            [TEST_B, ~] = band_content(eval(['Pxx_' groups{2}]),eval(['paf_mean_' groups{2}]),paf,ind_f,F,i);
            
            [ ~, ~, T_FDR, string_topoplot] = group_statistics(TEST_A, TEST_B, pth, test_parametric, FDR_correction, nperms);

            maxPSD = max([abs(min(T_FDR)),abs(max(T_FDR))]);
            % if maxPSD == 0
            %     maxPSD = 1;
            % end
            minPSD = -maxPSD;

            plot_topography(ind_f, groups, T_FDR, EEG.chanlocs, band_name, F, pipelines, j, minPSD, maxPSD, norm_cbar_topo, cmap, i, true, string_topoplot, verbose);

        end
    end

    % if isempty(filename)
    %     if length(gint)==1
    %         sgtitle([dataset ' - Group: ' pipelines{1} ' | Topography Comparison']);
    %     else
    %         sgtitle([dataset ' - Pipeline: ' pipelines{1} ' | Topography Comparison']);
    %     end
    % else
    %     sgtitle([filename ' | Topography Comparison'],'Interpreter','none');
    % end

    %% Temporal of some Channels
    if ~isempty(filename)

        fn = fieldnames(tchgroups);
        if isequal(channel_system,'GSN129') || isequal(channel_system,'GSN257')
            if ~isempty(a)
                for j=1:length(fn)
                    d = find(a(:,1)==tchgroups.(fn{j}));
                    if ~isempty(d)
                        tchgroups.(fn{j}) = a(d,2);
                    else
                        tchgroups.(fn{j}) = [];
                        error([convertStringsToChars(tchgroups.(fn{j})) ' IS MISSING INSIDE THE CONVERSION FILE.']);
                    end
                end
            end
        end

        % Load Correct Files
        if length(gint)==1 && length(pint)>1
            for i=1:length(pint)
                path = [folder gint{1} '_' pint{i} '/' filename '.set'];
                evalc(['EEG_' pint{i} '= pop_loadset(path)']);
            end
        elseif length(gint)>1 && length(pint)==1
            for i=1:length(gint)
                path = [folder gint{i} '_' pint{1} '/' filename '.set'];
                evalc(['EEG_' gint{i} '= pop_loadset(path)']);
            end
        else
            path = [folder gint{1} '_' pint{1} '/' filename '.set'];
            evalc(['EEG_' gint{1} '= pop_loadset(path)']);
        end

        FigH4 = figure('Position', get(0, 'Screensize'));
        tiledlayout(ceil(sqrt(length(fn))),ceil(sqrt(length(fn))), 'Padding', 'compact', 'TileSpacing', 'tight');

        for i=1:length(fn)
            nexttile;
    
            for j=1:length(groups)
                EEG = eval(['EEG_' groups{j} ]);
                [c, ch_considered] = get_indexch(listB, tchgroups.(fn{i}));
                if ~isempty(c)
                    if isequal('2ASR',groups{j})
                        try
                            EEG_1ASR = eval('EEG_1ASR');
                        catch
                            error('NEED 1ASR in order to visualize 2ASR');
                        end
                        if isfield(EEG.etc,'clean_sample_mask')
                            t = EEG_1ASR.xmin:1/EEG_1ASR.srate:EEG_1ASR.xmax;
                            plot(t(EEG.etc.clean_sample_mask), EEG_1ASR.data(c, EEG.etc.clean_sample_mask),colors{j},'LineWidth',ax_size); hold on;
                        else
                            t = EEG.xmin:1/EEG.srate:EEG.xmax;
                            plot(t, EEG.data(c,:),colors{j},'LineWidth',ax_size); hold on;
                        end
                    else
                        t = EEG.xmin:1/EEG.srate:EEG.xmax;
                        plot(t, EEG.data(c,:),colors{j},'LineWidth',ax_size); hold on;
                    end
                else
                    error([convertStringsToChars(tchgroups.(fn{i})) ' IS MISSING FROM CHANLOC']);
                end
    
            end
        
            title(['ch: ' convertStringsToChars(ch_considered)],'FontSize',title_size);
            xlabel('t[s]','FontSize',labels_size);
            ylabel('Channel [\muV]','FontSize',labels_size);
            ax = gca;
            ax.LineWidth = ax_size;
            ax.FontSize = ticks_size;
        end
        lgd = legend(groups);
        lgd.Location ='southwest';
        lgd.FontSize = ticks_size;

    %sgtitle([filename ' | Time Comparison'],'Interpreter','none');
    end

    if ~isempty(save_img)
        saveas(FigH1,[save_img dataset '_' pipelines{1} '_chansPSD.png']);
        saveas(FigH3,[save_img dataset '_' pipelines{1} '_topoplot.png']);
        if ~isempty(filename)
            saveas(FigH4,[save_img dataset '_' pipelines{1} '_timechan.png']);
        end
    end

end