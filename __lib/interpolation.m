
function [EEG,C,pad_interpol_channels] = interpolation(EEG, chan_name, template_tensor, listB, pad_file, pad_interpol_channels)


    [A,B] = size(template_tensor);
    [a,b] = ind2sub([A,B], find(template_tensor == chan_name));

    if length(a)==1
        pad_interpol_channels(a,b) = 1;
        if ((a-1)>0 && (a+1)<A) && ((b-1)>0 && (b+1)<B)  %check if internal point  %if channel needed to be interpolate is present more times in the template tensor -> padded channel
    
            EEG.data = cat(1,EEG.data,zeros(1,length(EEG.data)));
            EEG.nbchan = EEG.nbchan+1;
            EEG.chanlocs(end+1).labels = convertStringsToChars(chan_name);
    
            c = -ones(1,4);
            chan_4 = [template_tensor(a,b+1),template_tensor(a,b-1),template_tensor(a+1,b),template_tensor(a-1,b)];
    
            if pad_interpol_channels(a,b+1)~=1
                c(0) = find(listB == chan_4(0));
                %warning("CHANNEL USED FOR INTERPOLATION, PADDED OR INTERPOLATED ITSELF");
            end
            if pad_interpol_channels(a,b+1)~=1
                c(1) = find(listB == chan_4(1));
                %warning("CHANNEL USED FOR INTERPOLATION, PADDED OR INTERPOLATED ITSELF");
            end
            if pad_interpol_channels(a,b+1)~=1
                c(2) = find(listB == chan_4(2));
                %warning("CHANNEL USED FOR INTERPOLATION, PADDED OR INTERPOLATED ITSELF");
            end
            if pad_interpol_channels(a,b+1)~=1
                c(3) = find(listB == chan_4(3));
                %warning("CHANNEL USED FOR INTERPOLATION, PADDED OR INTERPOLATED ITSELF");
            end
            mask = (c~=-1);
    
            EEG.data(EEG.nbchan,:) = sum(EEG.data(c(mask),:))/(sum(mask)); %Average Mean (?)
    
            C = EEG.nbchan;
            warning("INTERPOLATEED CHANNEL HAS NO COORDINATES")
    
            if sum(mask)==0
                error("ERROR: MULTIPLE CENTRAL CHANNEL MISSING");
            end
    
        else 
            %check if border point try PAD (2 times)
            new_chan_name = pad_file(pad_file(:,1)==chan_name,2);
            C = find(listB == new_chan_name);
            if isempty(C)
                new_chan_name = pad_file(pad_file(:,1)==new_chan_name,2);
                C = find(listB == new_chan_name);
                error("ERROR: MULTIPLE CENTRAL CHANNEL MISSING");
            end
        end
    elseif length(a)>1
        for i=1:length(a)
            pad_interpol_channels(a(i),b(i)) = 1;
        end

        %check if border point try PAD (2 times)
        new_chan_name = pad_file(pad_file(:,1)==chan_name,2);
        C = find(listB == new_chan_name);
        if isempty(C)
            new_chan_name = pad_file(pad_file(:,1)==new_chan_name,2);
            C = find(listB == new_chan_name);
            error("ERROR: MULTIPLE CENTRAL CHANNEL MISSING");
        end
    end
end