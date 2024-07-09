function [EEG] = prepstep_wICA(EEG, params_info, verbose)
    % FUNCTION: prepstep_wICA
    %
    % Description: Applies Wavelet enhanced Independent Component Analysis (ICA) 
    %              for the suppression of independent component artifact.
    %              ICLabel or MARA must be run to flag noisy components to correct.
    %              Note that original Independent Components decomposition will be
    %              removed. It is suggested to run a new IC decomposition with the
    %              cleaned data.
    %
    % Syntax:
    %   [EEG] = prepstep_wICA(EEG, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - verbose (logical): Setting the verbosity level.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Federico Del Pup]
    % Date: [08/07/2024]
    
    
    % note that priority is given to the rejection, since it's a more
    % poular step. If for some reasons checks are bypassed and both
    % rejection and wICA are set to true, only rejection will be done
    if params_info.prep_steps.wICA && ~(params_info.prep_steps.ICrejection)
        
        % =============================================
        %   Do IC flag with IC Label or MARA for wICA
        % =============================================
        if isequal(params_info.ic_rej_type,'iclabel')
            flagger_type = 'ICLabel';
            if verbose
                [EEG] = iclabel(EEG);
                [EEG] = pop_icflag(EEG,params_info.iclabel_thresholds);
            else
                [~, EEG] = evalc("iclabel(EEG);"); %#ok
                [~, EEG] = evalc("pop_icflag(EEG,params_info.iclabel_thresholds);");
            end
            ics = 1:length(EEG.reject.gcompreject);
            rejected_comps = ics(EEG.reject.gcompreject);
            
            EEG.history = [EEG.history newline 'Run ICLabel for wICA.' ...
                newline '    Thresholds applied: '];

            labels_art = {'Brain', 'Muscle', 'Eye', 'Heart', ...
                'Line Noise', 'Channel Noise', 'Other'};
            for i=1:length(labels_art)
                EEG.history = [EEG.history newline '        ' labels_art{i} ': [' ...
                    num2str(params_info.iclabel_thresholds(i,1)) ' - ' ...
                    num2str(params_info.iclabel_thresholds(i,2)) ']; '];
            end 

        elseif isequal(params_info.ic_rej_type,'mara')
            flagger_type = 'MARA';
            if verbose
                [~, info] = MARA(EEG);
            else
                [~, ~, info] = evalc("MARA(EEG);");
            end
            ics = 1:length(info.posterior_artefactprob);
            rejected_comps = ics( info.posterior_artefactprob > ...
                params_info.mara_threshold);
            EEG.history = [EEG.history newline 'Run MARA for wICA.'];
        else
            error([ 'CHECK params_info.ic_rej_type: ' ...
                'METHOD NOT ALREADY IMPLEMENTED, MISPELLED or EMPTY']);
        end
        
        % ===========================
        %   Run wICA on flagged ICs
        % ===========================
        L = params_info.wavelet_level;
        wavetype = params_info.wavelet_type;

        how_much_pad = 2^L - mod(size(EEG.icaact,2), 2^L);
        if how_much_pad ~= 2^L
            icaact_pad = [EEG.icaact, zeros(size(EEG.icaact, 1), how_much_pad)];
        else
            icaact_pad = EEG.icaact;
        end
        
        wIC = zeros(size(icaact_pad));

        for i=rejected_comps
            sw_sig = swt(icaact_pad(i,:), L, wavetype);
            [thresh, sorh, ~] = ddencmp('den', 'wv', icaact_pad(i,:));
            sw_sig_th = wthresh(sw_sig, sorh, thresh);
            wIC(i,:) = iswt(sw_sig_th, wavetype);
        end
        
        EEG.data = EEG.icawinv*(EEG.icaact - wIC(:, 1:size(EEG.icaact, 2)));

        if verbose
            disp('wICA run successfully. Removing original ICA decomposition')
        end
        EEG.icaact    = [];
        EEG.icawinv   = [];
        EEG.icasphere = [];
        EEG.icaweight = [];

        EEG.history = [ ...
            EEG.history newline ...
            'wICA run on the following components flagged by ' flagger_type ...
            ':' newline '    [' num2str(rejected_comps) ']' ...
        ];
    end
end