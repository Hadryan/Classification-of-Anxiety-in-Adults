function [yn,yd,r,t,tm,APA,NMSE] = Normalize_denoise(GSRData,fs)
    
    y=GSRData;
    yn=zscore(y);
    
    yd=yn;
    yn=yn(1:length(yd));
    avg=mean(yn);
    APA=10*log(var(yn(:))./var(yd(:)));
    NMSE=10*log((yn(:)-yd(:)).^2./(yn(:)-avg).^2);

    
    
    tm = (1:length(yn))'/fs;
    [r, p, t, l, d, e, obj] = cvxEDA(yd, 1/fs);
    
end
