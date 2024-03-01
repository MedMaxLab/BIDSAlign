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

    if params_info.prep_steps.ICrejection 
        if isequal(params_info.ic_rej_type,'iclabel')
            try
                if verbose
                    [EEG] = iclabel(EEG);
                    [EEG] = pop_icflag(EEG,params_info.iclabel_thresholds);
                    ics = 1:length(EEG.reject.gcompreject);
                    rejected_comps = ics(EEG.reject.gcompreject);
                    if length(rejected_comps) == length(ics)
                        warning('ALL COMPONENTS HAVE BEEN REJECTED. IC rejection skipped.')
                    else
                        [EEG] = pop_subcomp(EEG, rejected_comps);
                    end
                    
                else
                    [~, EEG] = evalc("iclabel(EEG);"); %#ok
                    [~, EEG] = evalc("pop_icflag(EEG,params_info.iclabel_thresholds);");
                    ics = 1:length(EEG.reject.gcompreject);
                    rejected_comps = ics(EEG.reject.gcompreject); %#ok
                    if length(rejected_comps) == length(ics)
                        [~] = evalc("warning('ALL COMPONENTS HAVE BEEN REJECTED. IC rejection skipped.');");
                    else
                        [~, EEG] = evalc("pop_subcomp(EEG, rejected_comps);"); 
                    end
    
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
            catch
                if verbose
                    warning('IClabel rejection failed. Preprocessing step skipped.');
                else
                    [~] = evalc("warning('IClabel rejection failed. Preprocessing step skipped.');");
                end 
            end

        elseif isequal(params_info.ic_rej_type,'mara')
            try
                if verbose
                    [rejected_comps, info] = MARA(EEG); %#ok
                    ics = 1:length(info.posterior_artefactprob);
                    rejected_comps = ics( info.posterior_artefactprob > ...
                        params_info.mara_threshold);
                    if length(rejected_comps) == length(ics)
                        warning('ALL COMPONENTS HAVE BEEN REJECTED. IC rejection skipped.')
                    else
                        [EEG] = pop_subcomp(EEG, rejected_comps);
                    end
                else
                    [~, rejected_comps, info] = evalc("MARA(EEG);"); %#ok
                    ics = 1:length(info.posterior_artefactprob);
                    rejected_comps = ics( info.posterior_artefactprob > ...
                        params_info.mara_threshold); %#ok
                    if length(rejected_comps) == length(ics)
                        [~] = evalc("warning('ALL COMPONENTS HAVE BEEN REJECTED. IC rejection skipped.');");
                    else
                        [~, EEG] = evalc("pop_subcomp(EEG, rejected_comps);");
                    end
                end
                EEG.history = [EEG.history newline 'MARA REJECTION.'];
            catch
                if verbose
                    warning('MARA rejection failed. Preprocessing step skipped.');
                else
                    [~] = evalc("warning('MARA rejection failed. Preprocessing step skipped.');");
                end 
            end
        else
            warning([ 'CHECK params_info.ic_rej_type: ' ...
                'METHOD NOT ALREADY IMPLEMENTED, MISPELLED or EMPTY']);
        end
    end

end
