
function [EEG] = prepstep_removesegments(EEG, params_info, verbose)

    if params_info.prep_steps.rmsegments

        if params_info.dt_i>0 && params_info.dt_f>0
            if EEG.xmax - params_info.dt_i - params_info.dt_f>0
                if verbose
                    [EEG] = pop_select(EEG, 'rmtime', [0 params_info.dt_i; EEG.xmax-params_info.dt_f EEG.xmax]);
                else
                     [~,EEG] = evalc("pop_select(EEG, 'rmtime', [0 params_info.dt_i; EEG.xmax-params_info.dt_f EEG.xmax]);");
                end
                EEG.history = [EEG.history newline 'REMOVED FIRST ' num2str(params_info.dt_i) 's AND LAST ' num2str(params_info.dt_f) 's'];
            
            elseif EEG.xmax - params_info.dt_f>0
                if verbose
                    [EEG] = pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);
                else
                    [~,EEG] = evalc("pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);");
                end
                EEG.history = [EEG.history newline 'REMOVED LAST ' num2str(params_info.dt_f) 's'];
            else
                if verbose
                    warning('dt_f and dt_i NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING'); 
                end
            end

        elseif params_info.dt_i==0 && params_info.dt_f>0
            if EEG.xmax - params_info.dt_f>0
                if verbose
                    [EEG] = pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);
                else
                    [~, EEG] = evalc("pop_select(EEG, 'rmtime', [EEG.xmax-params_info.dt_f EEG.xmax]);");
                end
                EEG.history = [EEG.history newline 'REMOVED LAST ' num2str(params_info.dt_f) 's'];
            else
                if verbose
                    warning('dt_f NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING');
                end
            end

        elseif params_info.dt_i>0 && params_info.dt_f==0
            if EEG.xmax - params_info.dt_i>0
                if verbose
                    [EEG] = pop_select(EEG, 'rmtime', [0 params_info.dt_i]);
                else
                    [EEG] = evalc("pop_select(EEG, 'rmtime', [0 params_info.dt_i]);");
                end
                EEG.history = [EEG.history newline 'REMOVED FIRST ' num2str(params_info.dt_i) 's'];
            else
                if verbose
                    warning('dt_i NOT CUT, BEACUSE TOO BIG RESPECT THE LENGHT OF THE EEG RECORDING');
                end
            end
        end
    end

end