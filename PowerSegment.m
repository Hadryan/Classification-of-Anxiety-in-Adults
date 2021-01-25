
gsr0 = csvread('PHASIC0.csv');
AUC0=[];


for i = 1:length(gsr0)
 gsrsegment=gsr0(i,:);   
 t=trapz(gsrsegment);
 AUC0=[AUC0,t];
 
end


gsr = csvread('PHASIC.csv');
AUC=[];
for i = 1:length(gsr)
 gsrsegment=gsr(i,:);   
 t=trapz(gsrsegment);
 AUC=[AUC,t];
end

csvwrite('EDA_AUC0.csv',(AUC0))
csvwrite('EDA_AUC.csv',(AUC))