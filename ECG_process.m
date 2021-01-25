ecg=readtable('CLIP-1_ECG.csv');
ecg=ecg(1:size(ecg),2);
ecg=table2array(ecg);