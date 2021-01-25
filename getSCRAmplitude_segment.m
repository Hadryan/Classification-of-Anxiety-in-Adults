function [n, value,loc] = getSCRAmplitude_segment(edaSegment)
if(min(edaSegment) < -1)
    n = -1;
    value = -1;
    loc=-1;
    return
end
peak_amplitude = [];
peak_location = [];
valley_location = [];
valley_amplitude = [];
peak_count = 0;
valley_count = 0;
frequency = 10;
i = 2;
while (i < (numel(edaSegment)-1)) 
    peak_value = 0;
    valley_value = 0; 
    %fprintf('i: %d\n', i);
    if ((edaSegment(i)) < (edaSegment(i-1)) && (edaSegment(i)) < (edaSegment(i+1)))         % check if it is a valley
        valley_value = edaSegment(i);   
        valley_index = i;
        % we have a valley, so we can check if there is a peak after the valley
            for j = valley_index + ceil(frequency/2): numel(edaSegment)-1
                if((edaSegment(j)) > (edaSegment(j-1)) && (edaSegment(j)) > (edaSegment(j+1))) % if the sample is a peak (i.e. it is higher than the previous and then the following sample)
                    if (edaSegment(j) > peak_value)        % if it is the highest peak after the valley
                        peak_value = edaSegment(j);
                        peak_index = j;
                    end
                end
            end
    end
    
    if((peak_value - valley_value) > 0.05)    % 0.1 microS is the threshold we use to classify it as a SCR
        % Refine the valley value to consider the lowest valley
      
        start = valley_index;
        for k = start: peak_index
            if(edaSegment(k) < valley_value)
                valley_value = edaSegment(k);
                valley_index = k;
            end               
        end
        relative_peak_value = peak_value - valley_value;
        peak_count = peak_count +1;
        peak_amplitude = [peak_amplitude, relative_peak_value];
        valley_amplitude = [valley_amplitude, valley_value];
        peak_location = [peak_location, peak_index];
        valley_count  = valley_count +1;
        valley_location = [valley_location, valley_index];
        i = peak_index + 1; % Check for the next valley after the peak to avoid detetction of same peaks more than once        
    end
i = i + 1;
end
n = peak_count;
if(n > 0)
    value = mean(peak_amplitude);
    loc=mean(valley_location);
else
    value = 0;
    loc=0;
end
