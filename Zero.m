
gsr0 = csvread('PHASIC0.csv');
MFCC0=[];
for i = 1:length(gsr0)
 gsrsegment=gsr0(i,:);   
 melCeps = getMFCC(gsrsegment,100);
 
 MFCC_mean=mean(transpose(melCeps));
 MFCC_std=std(transpose(melCeps));
 MFCC_median=median(transpose(melCeps));
 MFCC_kurtosis=kurtosis(transpose(melCeps));
 MFCC_skewness=skewness(transpose(melCeps));
 
 block=[MFCC_mean,MFCC_std,MFCC_median,MFCC_kurtosis,MFCC_skewness];
 MFCC0=[MFCC0,transpose(block)];
end


gsr = csvread('PHASIC.csv');

MFCC=[];
for i = 1:length(gsr)
 
 gsrsegment=gsr(i,:);   
 melCeps = getMFCC(gsrsegment,100);
 
 MFCC_mean=mean(transpose(melCeps));
 MFCC_std=std(transpose(melCeps));
 MFCC_median=median(transpose(melCeps));
 MFCC_kurtosis=kurtosis(transpose(melCeps));
 MFCC_skewness=skewness(transpose(melCeps));
 
 block=[MFCC_mean,MFCC_std,MFCC_median,MFCC_kurtosis,MFCC_skewness];
 MFCC=[MFCC,transpose(block)];
end

csvwrite('MFCC0.csv',transpose(MFCC0))
csvwrite('MFCC.csv',transpose(MFCC))