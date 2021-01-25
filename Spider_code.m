cd('Spider')
D = dir;

RAW=[];
PHASIC=[];
TONIC=[];
LABEL=[];
CLIP=[];
    
for k = 3:length(D) 
    currD = D(k).name; % Get the current subdirectory name
    s1=currD;
    cd(currD) % change the directory (then cd('..') to get back)
    raw=[];
    Phasic=[];
    tonic=[];
    label=[];
    clip=[];

      cd('GSR')
      for i=1:16
         str=strcat('CLIP-',int2str(i),'_GSR.csv')
         gsr=readtable(str);
         gsr=gsr(1:size(gsr),2);
         gsr=table2array(gsr);
         for j = 0:(length(gsr)/6000)-1
         X= gsr(j*6000+1: j*6000+6000);
             [yn,yd,r,t,tm] = Normalize_denoise(X,1/10);
         
        gsrseg1=yn;
        gsrseg2=r;
        gsrseg3=t;
        raw=vertcat(raw,transpose(gsrseg1));
        Phasic=vertcat(Phasic,transpose(gsrseg2));
        tonic=vertcat(tonic,transpose(gsrseg3));
        label= vertcat(label,i);
        clip=vertcat(clip,currD);
        
%              gsrseg1=t(j*20+1:j*20+20);
%              gsrseg2=t(j*20+21:j*20+40);
%              gsrseg=vertcat(gsrseg1,gsrseg2);
%              [me1,med1,s1,area,total_pow,num,total] = Features(gsrseg);
%              mean1=vertcat(mean1,me1);
%              median1=vertcat(median1,med1);
%              std1=vertcat(std1,s1);
%              area1=vertcat(area1,area);
%              ene1=vertcat(ene1,total_pow);
%              
%              scr_num=vertcat(scr_num,num);
%              scr_mag=vertcat(scr_mag,total);
         
         end
      end
      
      cd ..
      cd ..
      RAW=vertcat(RAW,raw);
      PHASIC=vertcat(PHASIC,Phasic);
      TONIC=vertcat(TONIC,tonic);
      LABEL=vertcat(LABEL,label);
      CLIP=vertcat(CLIP,clip);

end

% phasic_features=[mean1 median1 std1 area1 ene1 scr_num  scr_mag];
% csvwrite('phasic_features.csv',phasic_features)
cd ..
csvwrite('RAW.csv',RAW)
csvwrite('PHASIC.csv',PHASIC)
csvwrite('TONIC.csv',TONIC)
csvwrite('GSR_USER.csv',CLIP)
csvwrite('GSR_CLIP.csv',LABEL)
