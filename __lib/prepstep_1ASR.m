function [EEG] = prepstep_1ASR(EEG, params_info, verbose)
% Description: Applies Artifact Subspace Reconstruction (ASR) for EEG artifact correction.
%
% Syntax:
%   [EEG] = prepstep_1ASR(EEG, params_info, verbose)
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
        if verbose
            fprintf(' \t\t\t\t\t\t\t\t --- SOFT ASR APPLIED ---\n');
        end
        [EEG,~,~] = clean_artifacts(EEG, 'ChannelCriterion', params_info.channelC, ...
                                         'LineNoiseCriterion', params_info.lineC, ...
                                         'BurstCriterion', 'off', ...                  %default
                                         'WindowCriterion', 'off', ...                 %default
                                         'Highpass','off', ...
                                         'FlatlineCriterion', params_info.flatlineC,...
                                         'NumSamples', 50,...                          %default
                                         'ChannelCriterionMaxBadTime', 0.2,...         %default 
                                         'BurstCriterionRefMaxBadChns', 0.075 ,...     %default
                                         'BurstCriterionRefTolerances', [-inf 5.5],... %default
                                         'Distance', 'euclidian',...                   %default
                                         'WindowCriterionTolerances','off',...         %default
                                         'BurstRejection','off',...                    %default
                                         'NoLocsChannelCriterion', 0.45,...            %default
                                         'NoLocsChannelCriterionExcluded', 0.1,...     %default
                                         'MaxMem', 4096, ...                           %default
                                         'availableRAM_GB', NaN);                      %default);

        EEG.history = [EEG.history newline '1° ASR CHANNELS CORRECTION: FlatLineCriterion ' num2str(params_info.flatlineC) ...
                       ', ChannelCriterion ' num2str(params_info.channelC) ', LineNoiseCriterion ' num2str(params_info.lineC)];
    end


end