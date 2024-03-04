
function [H_FDR, P_FDR, T_FDR, string_topoplot] = group_statistics(TEST_A, TEST_B, pth, test_parametric, FDR_correction, nperms)
    % FUNCTION: group_statistics
    %
    % Description: Perform statistical analysis (t-test) on groups A and B and optionally apply false discovery rate (FDR) correction.
    %
    % Syntax:
    %   [H_FDR, P_FDR, T_FDR, string_topoplot] = group_statistics(TEST_A, TEST_B, pth, test_parametric, FDR_correction, nperms)
    %
    % Input:
    %   - TEST_A (matrix): Data matrix for group A (channels x subjects).
    %   - TEST_B (matrix): Data matrix for group B (channels x subjects).
    %   - pth (scalar): Threshold for statistical significance.
    %   - test_parametric (logical): Flag to indicate whether to use parametric test (true) or non-parametric test (false).
    %   - FDR_correction (logical): Flag to indicate whether to apply false discovery rate (FDR) correction (true) or not (false).
    %   - nperms (scalar): Number of permutations for non-parametric test (optional, required only if test_parametric is false).
    %
    % Output:
    %   - H_FDR (vector): Binary vector indicating significant channels after FDR correction.
    %   - P_FDR (matrix or array): Matrix or array of p-values after FDR correction.
    %   - T_FDR (matrix or array): Matrix of t-statistics after FDR correction.
    %   - string_topoplot (char): String indicating whether FDR was applied ('') or not ('no ').
    %
    % Author: [Andrea Zanola]
    % Date: [29/02/2024]
    %
    % See also: ttest2, bramila_ttest2_np

    [numberOfSubjectsA,channelNumbers] = size(TEST_A);
    [numberOfSubjectsB,~] = size(TEST_B);

    if test_parametric
        [h,p,~,stats] = ttest2(TEST_A,TEST_B,'Alpha',pth,'Tail','both','Dim',1);
        if FDR_correction
            H_FDR = zeros(channelNumbers,1);
            P_FDR = mafdr(p,'BHFDR','true');
            H_FDR(P_FDR<pth) = 1;
            T_FDR = H_FDR.*stats.tstat';
            string_topoplot = '';
        else
            H_FDR = h;
            P_FDR = p;
            T_FDR = stats.tstat;
            string_topoplot = 'no ';
        end
    else 
        group_code = [ones(1,numberOfSubjectsA) 2*ones(1,numberOfSubjectsB)];
        statsAvsB = bramila_ttest2_np([TEST_A' TEST_B'],group_code,nperms);

        H_FDR = zeros(channelNumbers,1);
        if FDR_correction

            P_FDR(:,1) = mafdr(statsAvsB.pvals(:,1),'BHFDR','true');
            P_FDR(:,2) = mafdr(statsAvsB.pvals(:,2),'BHFDR','true');
            H_FDR(P_FDR(:,1)<pth) = 1;
            H_FDR(P_FDR(:,2)<pth) = 1;
            T_FDR = H_FDR.*statsAvsB.tvals;
            string_topoplot = '';
        else
            H_FDR(statsAvsB.pvals(:,1)<pth) = 1;
            H_FDR(statsAvsB.pvals(:,2)<pth) = 1;
            P_FDR = statsAvsB.pvals;
            T_FDR = statsAvsB.tvals;
            string_topoplot = 'no ';
        end
    end

end