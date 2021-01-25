function [yn,yd,r,t,tm,APA,NMSE] = Denoise_normalize(GSRData,fs)
    
    y=GSRData;
    yd=denoiseEDA(y,fs);
    
    y=y(1:length(yd));
    avg=mean(y);
    APA=10*log(var(y(:))./var(yd(:)));
    NMSE=10*log((y(:)-yd(:)).^2./(y(:)-avg).^2);

    
    yn=zscore(yd);
    tm = (1:length(yn))'/fs;
    [r, p, t, l, d, e, obj] = cvxEDA(yn, 1/fs);
    
end
