function [mean1,median1,std1,area,total_pow,num,total] = Features(data)

        mean1=mean(data);
        median1=median(data);
        std1=std(data);
        area=trapz(data);
        F = fft(data);
        pow = F.*conj(F);
        total_pow = sum(pow);
        [num,total] = scrFEATURES(data);


end