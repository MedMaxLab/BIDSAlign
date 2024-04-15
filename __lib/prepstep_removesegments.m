
function [EEG] = prepstep_removesegments(EEG, params_info, verbose)
    % FUNCTION: prepstep_removesegments
    %
    % Description: Removes segments of EEG data from the beginning and/or end 
    %              if specified in the preprocessing parameters.
    %
    % Syntax:
    %   [EEG] = prepstep_removesegments(EEG, params_info, verbose)
    %
    % Input:
    %   - EEG (struct): EEG data structure.
    %   - params_info (struct): Struct containing preprocessing parameters, 
    %                           including segment removal durations.
    %   - verbose (logical): Verbosity flag indicating whether 
    %                        to display information during processing.
    %
    % Output:
    %   - EEG (struct): Processed EEG data structure.
    %
    % Author: [Andrea Zanola]
    % Date: [16/02/2024]

    if params_info.prep_steps.rmsegments

        if params_info.dt_i>0 && params_info.dt_f>0
            if EEG.xmax - params_info.dt_i - params_info.dt_f>0
                if verbose
                    [EEG] = pop_select(EEG, 'rmtime', ...
                        [0 params_info.dt_i-1/EEG.srate; EEG.xmax-params_info.dt_f+1/EEG.srate EEG.xmax]); %-1/EEG.srate in order to keep extremal point
                else
                    cmd2run = "pop_select(EEG, 'rmtime', " + ... 
                        "[0 params_info.dt_i-1/EEG.srate; EEG.xmax-params_info.dt_f+1/EEG.srate EEG.xmax]);";
                    [~,EEG] = evalc(cmd2run);
                end
                EEG.history = [EEG.history newline 'REMOVED FIRST ' ...
                    num2str(params_info.dt_i) 's AND LAST ' ...
                    num2str(params_info.dt_f) 's'];
            
            elseif EEG.xmax - params_info.dt_f>0
                if verbose
                    [EEG] = pop_select(EEG, ...
                        'rmtime', [EEG.xmax-params_info.dt_f+1/EEG.srate EEG.xmax]);
                else
                    cmd2run = "pop_select(EEG, " + ... 
                        "'rmtime', [EEG.xmax-params_info.dt_f+1/EEG.srate EEG.xmax]);";
                    [~,EEG] = evalc(cmd2run);
                end
                EEG.history = [EEG.history newline 'REMOVED LAST ' ...
                    num2str(params_info.dt_f) 's'];
            else
                if verbose
                    warning(['dt_f and dt_i NOT CUT,' ...
                        ' BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING']); 
                end
            end

        elseif params_info.dt_i==0 && params_info.dt_f>0
            if EEG.xmax - params_info.dt_f>0
                if verbose
                    [EEG] = pop_select(EEG, ...
                        'rmtime', [EEG.xmax-params_info.dt_f+1/EEG.srate EEG.xmax]);
                else
                    cmd2run = "pop_select(EEG, " + ...
                        "'rmtime', [EEG.xmax-params_info.dt_f+1/EEG.srate EEG.xmax]);";
                    [~, EEG] = evalc(cmd2run);
                end
                EEG.history = [EEG.history newline 'REMOVED LAST ' ...
                    num2str(params_info.dt_f) 's'];
            else
                if verbose
                    warning(['dt_f NOT CUT, ' ...
                        'BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING']);
                end
            end

        elseif params_info.dt_i>0 && params_info.dt_f==0
            if EEG.xmax - params_info.dt_i>0
                if verbose
                    [EEG] = pop_select(EEG, 'rmtime', [0 params_info.dt_i-1/EEG.srate]);
                else
                    [EEG] = evalc("pop_select(EEG, 'rmtime', [0 params_info.dt_i-1/EEG.srate]);");
                end
                EEG.history = [EEG.history newline 'REMOVED FIRST ' ...
                    num2str(params_info.dt_i) 's'];
            else
                if verbose
                    warning(['dt_i NOT CUT, ' ...
                        'BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING']);
                end
            end
        end
    end

end