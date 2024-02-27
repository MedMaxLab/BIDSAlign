function [EEG] = prepstep_ICArejection(EEG, params_info, verbose)
    % FUNCTION: prepstep_ICArejection
    %
    % Description: Applies Independent Component Analysis (ICA) rejection 
    %              based on specified method and thresholds.
    %
    % Syntax:
    %   [EEG] = prepstep_ICArejection(EEG, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - verbose (logical): Verbosity flag indicating whether to display 
    %                        information during processing.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [16/02/2024]

    if params_info.prep_steps.ICrejection && ~isempty(params_info.ic_rej_type)
        if isequal(params_info.ic_rej_type,'iclabel')
            if verbose
                [EEG] = iclabel(EEG);
                [EEG] = pop_icflag(EEG,params_info.iclabel_thresholds);
                ics = 1:length(EEG.reject.gcompreject);
                rejected_comps = ics(EEG.reject.gcompreject);
                [EEG] = pop_subcomp(EEG, rejected_comps);
                
            else
                [~, EEG] = evalc("iclabel(EEG);"); %#ok
                [~, EEG] = evalc("pop_icflag(EEG,params_info.iclabel_thresholds);");
                ics = 1:length(EEG.reject.gcompreject);
                rejected_comps = ics(EEG.reject.gcompreject); %#ok
                [~, EEG] = evalc("pop_subcomp(EEG, rejected_comps);"); 
                %pop_subcomp put EEG.reject = []

            end
            EEG.history = [EEG.history newline 'ICLabel REJECTION.' ...
                newline 'Thresholds applied: '];

            labels_art = {'Brain', 'Muscle', 'Eye', 'Heart', ...
                'Line Noise', 'Channel Noise', 'Other'};
            for i=1:length(labels_art)
                EEG.history = [EEG.history labels_art{i} ': ' ...
                    num2str(params_info.iclabel_thresholds(i,1)) ' - ' ...
                    num2str(params_info.iclabel_thresholds(i,2)) '; '];
            end 

        elseif isequal(params_info.ic_rej_type,'mara')
            if verbose
                [rejected_comps, info] = MARA(EEG); %#ok
                ics = 1:length(info.posterior_artefactprob);
                rejected_comps = ics( info.posterior_artefactprob > ...
                    params_info.mara_threshold);
                [EEG] = pop_subcomp(EEG, rejected_comps);
            else
                [~, rejected_comps, info] = evalc("MARA(EEG);"); %#ok
                ics = 1:length(info.posterior_artefactprob);
                rejected_comps = ics( info.posterior_artefactprob > ...
                    params_info.mara_threshold); %#ok
                [~, EEG] = evalc("pop_subcomp(EEG, rejected_comps);");
            end
            EEG.history = [EEG.history newline 'MARA REJECTION.'];
        else
            warning([ 'CHECK params_info.ic_rej_type: ' ...
                'METHOD NOT ALREADY IMPLEMENTED OR MISPELLED']);
        end
    else
           warning([ 'CHECK params_info.ic_rej_type: ' ...
                'METHOD DECLARED IS EMPTY.']); 
    end

end
