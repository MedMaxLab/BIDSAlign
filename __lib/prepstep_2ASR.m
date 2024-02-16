function [EEG] = prepstep_2ASR(EEG, params_info, verbose)
    % FUNCTION: prepstep_2ASR
    %
    % Description: Applies Artifact Subspace Reconstruction (ASR) for EEG artifact correction with window removal.
    %
    % Syntax:
    %   [EEG] = prepstep_2ASR(EEG, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters.
    %   - verbose (logical): Verbosity flag indicating whether to display information during processing.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [16/02/2024]

    if params_info.prep_steps.ASR
        if max(abs(EEG.data),[],'all') > params_info.th_reject 
            if verbose
                fprintf(' \t\t\t\t\t\t\t\t --- REMOVE BURST ASR APPLIED ---\n');
            end
            [EEG,~,~] = clean_artifacts(EEG, 'ChannelCriterion', 'off', ...
                                             'LineNoiseCriterion', 'off', ...
                                             'BurstCriterion', params_info.burstC, ...     %default
                                             'WindowCriterion', params_info.windowC, ...   %default
                                             'Highpass','off', ...
                                             'FlatlineCriterion', 'off',...
                                             'NumSamples', 50,...                          %default
                                             'ChannelCriterionMaxBadTime', 0.2,...         %default 
                                             'BurstCriterionRefMaxBadChns', 0.075 ,...     %default
                                             'BurstCriterionRefTolerances', [-inf 5.5],... %default
                                             'Distance', 'euclidian',...                   %default
                                             'WindowCriterionTolerances','off',...         %default
                                             'BurstRejection',params_info.burstR,...       %changed from off -> on
                                             'NoLocsChannelCriterion', 0.45,...            %default
                                             'NoLocsChannelCriterionExcluded', 0.1,...     %default
                                             'MaxMem', 4096, ...                           %default
                                             'availableRAM_GB', NaN);                      %default

            EEG.history = [EEG.history newline '2° ASR WINDOWS REMOVAL: BurstCriterion ' num2str(params_info.burstC) ...
                           ', WindowCriterion ' num2str(params_info.windowC), ', BurstRejection', num2str(params_info.burstR)];

        end
    end

end