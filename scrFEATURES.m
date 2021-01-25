function [num,total] = scrFEATURES(data)

p=findpeaks(data);
mag=0;
c=0;
for i=1:length(p)
    if (p(i)>0.25)
    c=c+1;
    mag=mag+p(i);
    end
end
num=c;
total=mag;
end
