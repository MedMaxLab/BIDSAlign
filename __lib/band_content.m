
function [ar, ind_f_iaf] = band_content(m,paf_v,paf,ind_f,F,i)
    % FUNCTION: band_content
    %
    % Description: Calculate the Mean value of the PSD within the specified frequency interval.
    %
    % Syntax:
    %   [ar] = band_content(m, paf_v, paf, ind_f, F, i)
    %
    % Input:
    %   - m (numeric array): Mean PSD values.
    %   - paf_v (numeric array): Vector of peak alpha frequency (PAF) for each subject.
    %   - paf (logical): Flag indicating whether to consider PAF.
    %   - ind_f (numeric array): Indices of frequency bands.
    %   - F (numeric array): Frequency vector.
    %   - i (numeric): Index of the frequency band to consider.
    %
    % Output:
    %   - ar (numeric array): Mean value of the PSD within the specified frequency interval.
    %   - ind_f_iaf (numeric array): Array with band indeces, custom or IAF
    %   corrected.
    %
    % Author: [Andrea Zanola]
    % Date: [26/02/2024]
    %
    s = size(m);

    if length(s)==3
        [numberSubjects,~, numberChannels] = size(m);
        ar = zeros(numberSubjects, numberChannels);
    elseif length(s)==2
        [numberSubjects,~] = size(m);
        ar = zeros(numberSubjects,1);
    end

    if paf
        ind_f_iaf = zeros(numberSubjects,length(ind_f));
        for k=1:numberSubjects
            if isnan(paf_v(k))
                if ~isempty(m) && length(s)==2
                    mr = m(k,ind_f(i):ind_f(i+1))';
                    dF = F(ind_f(i):ind_f(i+1));
                    ar(k) = trapz(dF,mr)/(dF(end)-dF(1));
                elseif ~isempty(m) && length(s)==3
                    mr = squeeze(m(k,ind_f(i):ind_f(i+1),:));
                    dF = F(ind_f(i):ind_f(i+1));
                    ar(k,:) = (trapz(dF,mr)/(dF(end)-dF(1)))';    
                end
                ind_f_iaf(k,:) = ind_f;
            else

                %Frequency Range based on IAF
                [~,ind_04IAF] = min(abs(F-0.4*paf_v(k)));
                [~,ind_06IAF] = min(abs(F-0.6*paf_v(k)));
                [~,ind_12IAF] = min(abs(F-1.2*paf_v(k)));

                ind_f_individual(1) = ind_f(1);
                ind_f_individual(2) = ind_04IAF;
                ind_f_individual(3) = ind_06IAF;
                ind_f_individual(4) = ind_12IAF;
                ind_f_individual(5) = ind_f(5);    
                ind_f_individual(6) = ind_f(6); 

                ind_f_iaf(k,:) = ind_f_individual; 

                if ~isempty(m) && length(s)==2
                    mr = m(k,ind_f_individual(i):ind_f_individual(i+1))';
                    dF = F(ind_f_individual(i):ind_f_individual(i+1));
                    ar(k) = trapz(dF,mr)/(dF(end)-dF(1));
                elseif ~isempty(m) && length(s)==3
                    mr = squeeze(m(k,ind_f_individual(i):ind_f_individual(i+1),:));
                    dF = F(ind_f_individual(i):ind_f_individual(i+1));
                    ar(k,:) = (trapz(dF,mr)/(dF(end)-dF(1)))';
                end
            end
        end

    else
        ind_f_iaf = repmat(ind_f,numberSubjects,1);
        if ~isempty(m)  && length(s)==2
            mr = m(:,ind_f(i):ind_f(i+1))';
            dF = F(ind_f(i):ind_f(i+1));
            ar = trapz(dF,mr)/(dF(end)-dF(1)); 
            ar = ar';
        elseif ~isempty(m)  && length(s)==3
            for k=1:numberSubjects
                mr = squeeze(m(k,ind_f(i):ind_f(i+1),:));
                dF = F(ind_f(i):ind_f(i+1));
                ar(k,:) = (trapz(dF,mr)/(dF(end)-dF(1))); 
            end
        end
        %ar = ar';
    end
end