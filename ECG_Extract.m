cd('Spider')
D = dir;

RAW=[];
CLIP=[];
LABEL=[];
    
for k = 3:length(D) 
    currD = D(k).name; % Get the current subdirectory name
    s1=currD;
    cd(currD) % change the directory (then cd('..') to get back)
    raw=[];
    clip=[];
    label=[];

      cd('ECG')
      for i=1:16
         str=strcat('CLIP-',int2str(i),'_ECG.csv')
         
         ECG=readtable(str);
         ECG=ECG(1:size(ECG),2);
         ECG=table2array(ECG);
         for j = 0:(length(ECG)/1000)-1
         X= ECG(j*1000+1: j*1000+1000);
             
        raw=vertcat(raw,transpose(X));
        label= vertcat(label,i);
        clip=vertcat(clip,currD);

         end
      end
         cd ..
      cd ..
      RAW=vertcat(RAW,raw);
      LABEL=vertcat(LABEL,label);
      CLIP=vertcat(CLIP,clip);
      
end

cd ..
csvwrite('ECG_Combined0.csv',RAW)
csvwrite('ECG_USER0.csv',CLIP)
csvwrite('ECG_CLIP0.csv',LABEL)
