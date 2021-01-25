


function GSRDataFiltered = denoiseEDA(GSRData,fs)
    % Get wavelet detail coefficients
    level = log(fs)/log(2)+2;                                                 
    l=length(GSRData);
    a=l-mod(l,2^level);
    GSRdata=GSRData(1:a);
    wDEC = swt(GSRdata,level,'haar');
    % Apply low pass filtering by removing low level wavelet detail coefficients
    for j=1:level-2
        wDEC(j,:) = 0;
    end
      
    % Remove artifcats by applying selective thresholding on higher level wavelet detail coefficients
    for i=level-1:level
        x = wDEC(i,:)';                                                         % get ith level detail coefficeints
        [T_low, T_high] = getThresholds(x);                                     % get the thresholding paramemters
        for j = 1:numel(x)
            if T_low < x(j) && x(j) < T_high
                wDEC(i,j) = x(j);
            else
                wDEC(i,j) = 0;
            end
        end
    end
               
    % Recover the denoised signal by applying inverse SWT
    GSRDataFiltered = iswt(wDEC,'haar');
end

function [T_low, T_high] = getThresholds(x)
delta = 0.25;
scale = mean(abs(x));
T_low = scale*log(delta);
T_high = -T_low;
end