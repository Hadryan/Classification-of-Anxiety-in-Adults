gsr = csvread('PHASIC0.csv');

Nmean = mean(gsr,2);
S=transpose(std(transpose(gsr)));
fd=transpose(mean(diff(transpose(gsr))));
sd = transpose(mean(diff(transpose(gsr),2)));
skew=transpose(skewness(transpose(gsr)));

box=[Nmean ,S , fd , sd , skew];


csvwrite('EDA_Stat0.csv',box);

gsr = csvread('PHASIC.csv');

Nmean = mean(gsr,2);
S=transpose(std(transpose(gsr)));
fd=transpose(mean(diff(transpose(gsr))));
sd = transpose(mean(diff(transpose(gsr),2)));
skew=transpose(skewness(transpose(gsr)));

box=[Nmean ,S , fd , sd , skew];


csvwrite('EDA_Stat.csv',box);






% NM=[];
% Val=[];
% Loc=[];
% for i = 1:length(gsr)
%  gsrsegment=gsr(i,:);   
%  [n,v,l]=getSCRAmplitude_segment(gsrsegment);
%  NM=[NM,n];
%  Val=[Val,v];
%  Loc=[Loc,l];
% end
% 
% SCR=[NM,Val,Loc];
% 
% %csvwrite('SCR0.csv',SCR)
% %csvwrite('MFCC.csv',transpose(MFCC0))
% 
% %Number of Maxima
% %Mean value of Maxima magnitude
% %Mean value of maxima Time 