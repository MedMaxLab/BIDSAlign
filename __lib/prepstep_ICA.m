
function [EEG] = prepstep_ICA(EEG, params_info, ica_case, verbose)
    % FUNCTION: prepstep_ICA
    %
    % Description: Applies Independent Component Analysis (ICA) 
    %              decomposition to EEG data.
    %
    % Syntax:
    %   [EEG] = prepstep_ICA(EEG, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - ica_case (logical): Indicates which step should be performed.
    %   - verbose (logical): Verbosity flag indicating whether 
    %                        to display information during processing.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [16/02/2024]

    if verbose
        verb = 'on';
    else
        verb = 'off';
    end

    if params_info.prep_steps.ICrejection && ica_case
       
        switch params_info.ica_type
            case 'fastica'
                if params_info.n_ica ~= 0
                    [EEG] = pop_runica(EEG, ...
                        'icatype', params_info.ica_type, ...
                        'g', params_info.non_linearity, ...
                        'lasteig', min(EEG.nbchan,params_info.n_ica), ...
                        'verbose',verb);
                else
                    [EEG] = pop_runica(EEG, ...
                        'icatype', params_info.ica_type, ...
                        'g', params_info.non_linearity, ...
                        'verbose',verb);
                end
                 EEG.history = [EEG.history newline ...
                     'ICA DECOMPOSITION: ' params_info.ica_type ...
                     ', ' num2str(params_info.n_ica)...
                     ' ICs, NON-LINEARITY: ' params_info.non_linearity];

            case 'runica'
                if params_info.n_ica ~= 0
                    [EEG] = pop_runica(EEG, ...
                        'icatype', params_info.ica_type, ...
                        'pca', min(EEG.nbchan,params_info.n_ica),...
                        'verbose',verb);
                else
                    [EEG] = pop_runica(EEG, ...
                        'icatype', params_info.ica_type, ...
                        'verbose', verb);
                end
                EEG.history = [EEG.history newline ...
                    'ICA DECOMPOSITION: ' params_info.ica_type];
            otherwise
                error('ICA TYPE NOT IMPLEMENTED');
        end

    elseif params_info.prep_steps.ICA && ~ica_case

        switch params_info.ica_type
            case 'fastica'
            [EEG] = pop_runica(EEG, ...
                'icatype', params_info.ica_type, ...
                'g', params_info.non_linearity, ...
                'verbose',verb);
            EEG.history = [EEG.history newline ...
                'FINAL ICA DECOMPOSITION: ' params_info.ica_type ...
                ', NON-LINEARITY: ' params_info.non_linearity];

            case 'runica'
            [EEG] = pop_runica(EEG, 'icatype', params_info.ica_type,'verbose',verb);
            EEG.history = [EEG.history newline ...
                'FINAL ICA DECOMPOSITION: ' params_info.ica_type];
        end
    end

end


