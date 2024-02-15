function [EEG] = prepstep_ICA(EEG, params_info, verbose)

    if verbose
        verb = 'on';
    else
        verb = 'off';
    end

    if params_info.prep_steps.ICA && params_info.prep_steps.ICrejection
       
        switch params_info.ica_type
            case 'fastica'
                if params_info.n_ica ~= 0
                    [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity, ...
                                            'lasteig', min(EEG.nbchan,params_info.n_ica),'verbose',verb);
                else
                    [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type, 'g', params_info.non_linearity,'verbose',verb);
                end
                 EEG.history = [EEG.history newline 'ICA DECOMPOSITION: ' params_info.ica_type ', ' num2str(params_info.n_ica)...
                                                    ' ICs, NON-LINEARITY: ' params_info.non_linearity];
            case 'runica'
                if params_info.n_ica ~= 0
                    [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type, 'pca', min(EEG.nbchan,params_info.n_ica),...
                                            'verbose',verb);
                else
                    [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type, 'verbose', verb);
                end
                EEG.history = [EEG.history newline 'ICA DECOMPOSITION: ' params_info.ica_type];
            otherwise
                error('ICA TYPE NOT IMPLEMENTED');
        end

    end

end