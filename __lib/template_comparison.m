function template_comparison(filename, set_filepath, mat_filepath, git_path, save_img, channel_system, paf, verbose)
    % template_comparison: Compares EEG power spectral density (PSD) between a dataset and a template.
    %
    % Syntax:
    %   template_comparison(filename, set_filepath, mat_filepath, git_path, save_img, channel_system, paf, verbose)
    %
    % Input:
    %   - filename (string): Name of the EEG data file.
    %   - set_filepath (string): Path to the folder containing the EEG data set file.
    %   - mat_filepath (string): Path to the folder containing the EEG data mat file.
    %   - git_path (string): Path to the Git repository.
    %   - save_img (string): Optional. Path to save the generated images.
    %   - channel_system (string): Name of the channel system.
    %   - paf (logical): Flag indicating whether to compute Peak Alpha Frequency (PAF).
    %   - verbose (logical): Flag indicating whether to display progress messages.
    %
    % Output:
    %   None
    %
    % Author: [Andrea Zanola]
    % Date: [11/03/2024]

    %% Optional Inputs
    band_name = {'\delta','\theta','\alpha','\beta','\gamma'};
    colors = {'r','b','g','m','k','c','y'};
    cmap = 'turbo';
    norm = false;
    freq_vec = [0.1,4,8,13,30,44];
    template_file = 'chanloc_template_10_5.sfp';
    
    %%
    if verbose
        verb = 'on';
    else
        verb = 'off';
    end

    [~,EEG] = evalc("pop_loadset([set_filepath filename '.set']);");

    listB_set = strings(1,length(EEG.chanlocs));
    for t=1:length(EEG.chanlocs)
        listB_set(t) = string(EEG.chanlocs(t).labels);                             
    end

    load([mat_filepath filename '.mat']);

    listB_mat = strings(1,length(DATA_STRUCT.template));
    for t=1:length(DATA_STRUCT.template)
        listB_mat(t) = string(strtrim(DATA_STRUCT.template(t,:)));
    end

    % Find Channel corrispondance in differet Channel systems
    if isequal(channel_system,'GSN129') || isequal(channel_system,'GSN257')
        filenameconvfile = [git_path '__lib/template/template_channel_conversion/conv_' channel_system '_1010.mat'];
        if isfile(filenameconvfile)
            a = load(filenameconvfile);
            evalc(['a=a.conv' channel_system]);
        else
            error(['CONVERSION FILE NOT FOUND:' filenameconvfile]);
        end
        listB_mat = [];
        if ~isempty(a)
            for j=1:length(DATA_STRUCT.template)
                d = find(a(:,1)==strtrim(DATA_STRUCT.template(j,:)));
                if ~isempty(d)
                    listB_mat = [listB_mat a(d,2)];
                else
                    error('MISSING CHANNEL');
                end
            end
        end
    end

    [set_chanindex, ~] = get_indexch(listB_set,listB_mat); %here set channels index of Bmat channels that are present in set.
    [mat_chanindex, ~] = get_indexch(listB_mat,listB_set(set_chanindex)); %here Bmat channels index that are present in set.

    NFFT    = 2^(nextpow2(EEG.srate)+1); %next power for 0.5Hz 
    WINDOW  = hanning(NFFT);

    dataN = EEG.data;
    dataN_mat = DATA_STRUCT.data;
    if norm
        dataN = normalize(dataN,2,'zscore');
        dataN_mat = normalize(dataN_mat,2,'zscore');
    end

    [Pxx0,F] = pwelch(dataN',WINDOW,[],NFFT,EEG.srate);
    [Pxx1,F_mat] = pwelch(dataN_mat',WINDOW,[],NFFT,EEG.srate);

    [l1,l2] = size(Pxx0);
    Pxx_set = zeros(1,l1,l2);
    Pxx_set(1,:,:) = Pxx0;

    [l1_mat,l2_mat] = size(Pxx1);
    Pxx_mat = zeros(1,l1_mat,l2_mat);
    Pxx_mat(1,:,:) = Pxx1;

    t = length(freq_vec);
    ind_f = zeros(1,t);
    for i=1:t
        [~,ind_f(i)] = min(abs(F-freq_vec(i)));
    end

    if length(EEG.chanlocs) > 20
        electrode_mode = 'on';
    else
        electrode_mode = 'labels';
    end

    %% IAF Calculation
    if paf
        PA_range = [7,14];
        modality = 'cog';
        try
            if verbose
                [o,~,~] = restingIAF(dataN,length(EEG.chanlocs), 3, [1 45],...
                                        EEG.srate, [PA_range], 7, 5, 'nfft',NFFT, 'taper','hanning');
            else
                [~,o,~,~] = evalc("restingIAF(EEG.data,length(EEG.chanlocs), 3, [1 45], EEG.srate, PA_range, 7, 5, 'nfft',NFFT, 'taper','hanning');");
            end
            
            if isequel(modality,'paf')
                iaf = o.paf;
                iaf = o.pafStd;
            elseif isequel(modality,'cog')
                iaf = o.cog;
                iaf = o.cogStd;
            else
                error('OTHER METRIC');
            end
        catch
            iaf = nan;
            iaf = nan;
        end
    else
        iaf = [];
    end

    %% Show Topography Comparison
    FigH1 = figure('Position', get(0, 'Screensize'));
    cmap = colormap(cmap);
    tiledlayout(2,length(ind_f)-1, 'Padding', 'compact', 'TileSpacing', 'tight');
    for i=1:length(ind_f)-1
        nexttile;
        [ar, ind_f_iaf] = band_content(Pxx_set,iaf,paf,ind_f,F,i);

        topoplot(ar,EEG.chanlocs,'electrodes',electrode_mode,'maplimits','minmax',...
                    'colormap',cmap,'verbose',verb,'intrad',0.86,'plotrad',0.6);

        title([band_name{i} ' @' num2str(F(ind_f(i)),3) '-' num2str(F(ind_f(i+1)),3) 'Hz | ' channel_system],'FontSize',14);

        cbar = colorbar;
        cbar.Label.String = 'PSD [\muV^2/Hz]';
        cbar.FontSize = 10;
    end
    for i=1:length(ind_f)-1
        nexttile;
        [ar, ind_f_iaf] = band_content(Pxx_mat,iaf,paf,ind_f,F,i);

        topoplot(ar(mat_chanindex),EEG.chanlocs(set_chanindex),'electrodes',electrode_mode,'maplimits','minmax',...
                'colormap',cmap,'verbose',verb,'intrad',0.86,'plotrad',0.6);

        title([band_name{i} ' @' num2str(F(ind_f(i)),3) '-' num2str(F(ind_f(i+1)),3) 'Hz | Template'],'FontSize',14);

        cbar = colorbar;
        cbar.Label.String = 'PSD [\muV^2/Hz]';
        cbar.FontSize = 10;
    end
    sgtitle([filename ' | Template Comparison'],'Interpreter','none');

    %% Inspect Channel Location Comparison
    headrad = 0.5;
    plotrad = 0.82;
    intrad = 0.85;
    FigH2 = figure('Position', get(0, 'Screensize'));
    tiledlayout(2,2, 'Padding', 'compact', 'TileSpacing', 'tight');
    nexttile;
    topoplot([],EEG.chanlocs,'electrodes','labels','intrad',intrad,'plotrad',plotrad,'headrad',headrad);
    title([channel_system ' Channel Location'],'FontSize',14);
    nexttile;
    topoplot([],EEG.chanlocs(set_chanindex),'electrodes','labels','intrad',intrad,'plotrad',plotrad,'headrad',headrad);
    title('Template Channel Location','FontSize',14);
    nexttile;
    B = readlocs([git_path '__lib/template/template_channel_location/' template_file]);

    listB_mat = strings(1,length(DATA_STRUCT.template));
    for t=1:length(DATA_STRUCT.template)
        listB_mat(t) = string(strtrim(DATA_STRUCT.template(t,:)));
    end
    listB_temp = strings(1,length(B));
    for t=1:length(B)
        listB_temp(t) = upper(string(B(t).labels));
        B(t).labels = convertStringsToChars(listB_temp(t));
    end
    [temp_chanindex, ~] = get_indexch(listB_temp,listB_mat);

    topoplot([],B(temp_chanindex),'electrodes','labels','intrad',intrad,'plotrad',plotrad,'headrad',headrad);
    title('10/10 Template Channel Location','FontSize',14);

    nexttile;
    SUB = EEG.chanlocs(set_chanindex);
    for i=1:length(SUB)
        SUB(i).labels = strtrim(DATA_STRUCT.template(i,:));
    end
    topoplot([],SUB,'electrodes','labels','intrad',intrad,'plotrad',plotrad,'headrad',headrad);
    title('10/10 Equivalent Template Channel Location','FontSize',14);

    %% 3D channel location
    plotchans3d([[EEG.chanlocs.X]' [EEG.chanlocs.Y]' [EEG.chanlocs.Z]'],{ EEG.chanlocs.labels });
    title([channel_system ' Template Channel Location'],'FontSize',14);

    if ~isempty(save_img)
        saveas(FigH1,[filename '_topoplot_template.png']);
        saveas(FigH2,[filename '_chanlocs.png']);
    end

end

