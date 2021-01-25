
function GSR_Filt_f(userid, duration)


time=datestr(now,'HH-MM-SS.FFF');
addpath('./quaternion/')                                                   % directory containing quaternion functions
addpath('./Resources/')  
comPort='3';
shimmer = ShimmerHandleClass(comPort);
SensorMacros = SetEnabledSensorsMacrosClass;
fs = 128;  
captureDuration=duration/1000;
firsttime = true;
file=strcat(userid,'_GSR',time,'.csv');
NO_SAMPLES_IN_PLOT = 500;                                                 % Number of samples that will be displayed in the plot at any one time
DELAY_PERIOD = 0.2;                                                        % A delay period of time in seconds between data read operations
numSamples = 0;
fm = 50;                                                                   % mains frequency [Hz]
fchp = 5;                                                                  % corner frequency highpassfilter [Hz]; Shimmer recommends 5Hz to remove DC-offset and movement artifacts
nPoles = 4;                                                                % number of poles (HPF, LPF)
pbRipple = 0.5;                                                            % pass band ripple (%)
   
    HPF = true;                                                                % enable (true) or disable (false) highpass filter
    LPF = true;                                                                % enable (true) or disable (false) lowpass filter
    BSF = true;                                                                % enable (true) or disable (false) bandstop filter
   
    % highpass filters for ExG channels
    if (HPF)
        hpfexg1ch1 = FilterClass(FilterClass.HPF,fs,fchp,nPoles,pbRipple);
        hpfexg1ch2 = FilterClass(FilterClass.HPF,fs,fchp,nPoles,pbRipple);
    end
    if (LPF)
        % lowpass filters for ExG channels
        lpfexg1ch1 = FilterClass(FilterClass.LPF,fs,fs/2-1,nPoles,pbRipple);
        lpfexg1ch2 = FilterClass(FilterClass.LPF,fs,fs/2-1,nPoles,pbRipple);
    end
    if (BSF)
        % bandstop filters for ExG channels;
        % cornerfrequencies at +1Hz and -1Hz from mains frequency
        bsfexg1ch1 = FilterClass(FilterClass.LPF,fs,[fm-1,fm+1],nPoles,pbRipple);
        bsfexg1ch2 = FilterClass(FilterClass.LPF,fs,[fm-1,fm+1],nPoles,pbRipple);
    end
             % lowpass filters for PPG channel
shimmer.connect

shimmer.setsamplingrate(fs);% set the shimmer sampling rate
shimmer.setinternalboard('GSR');
shimmer.disableallsensors;                                             % disable all sensors
shimmer.getrealtimeclock;
shimmer.setenabledsensors(SensorMacros.INTA13,1);                               % enable PPG Channel
shimmer.setenabledsensors(SensorMacros.GSR,1);
shimmer.setenabledsensors(SensorMacros.ACCEL,1);
shimmer.setenabledsensors(SensorMacros.GYRO,1);
shimmer.setinternalexppower(1);

if (shimmer.start)                                                     % TRUE if the shimmer starts streaming
        %s = serialport("COM5",9600,"Timeout",1);
        %write(s,1:5,"uint8")
        ppgplotData = [];
        GSRplotData = [];
        XAccplotData=[];
        YAccplotData=[];
        ZAccplotData=[];
        timeStamp = [];
        XGyroplotData=[];
        YGyroplotData=[];
        ZGyroplotData=[];
%        
%         h.figure1=figure('Name','GSR/PPG');
%         set(h.figure1,'Position',[100,500,800,400]);
%         
        filteredplotData = [];
        storeData = [];
        elapsedTime = 0;                                                   % reset to 0    
        tic;                                                               % start timer
       
        while (elapsedTime < captureDuration)            
                     
            pause(DELAY_PERIOD);                                           % pause for this period of time on each iteration to allow data to arrive in the buffer
           
            [newData,signalNameArray,~,~] = shimmer.getdata('c');   % Read the latest data from shimmer data buffer, signalFormatArray defines the format of the data and signalUnitArray the unit
                       
            if (firsttime==true && isempty(newData)~=1)
                tab = char(9);
                cal = 'CAL';
                signalNamesString=[char('Time Stamp'), char(9), char('PPG'), char(9), char('GSR'), char(9)]; % create a single string, signalNamesString
                signalFormatsString =[cal, tab, cal, tab, cal, tab, cal, tab];
                signalUnitsString = ['milliseconds',tab,'mV',tab,'mV',tab,'BPM'];
               
                % write headers to file
                headerLines = {signalNamesString; signalFormatsString; signalUnitsString};
               
                fileName=strcat(userid,time,'.dat');
               
                fid = fopen(fileName, 'wt');
                for l = 1:numel(headerLines)
                    fprintf(fid, '%s\n',headerLines{l});
                end
                fclose(fid);
            end
             if ~isempty(newData)                                                            % TRUE if new data has arrived
                                 
                % get signal indices
                chIndex(1) = find(ismember(signalNameArray, 'Time Stamp'));
                chIndex(2) = find(ismember(signalNameArray, 'Low Noise Accelerometer X'));
                chIndex(3) = find(ismember(signalNameArray, 'Low Noise Accelerometer Y'));
                chIndex(4) = find(ismember(signalNameArray, 'Low Noise Accelerometer Z'));
                chIndex(5) = find(ismember(signalNameArray, 'Internal ADC A13'));
                chIndex(6) = find(ismember(signalNameArray, 'GSR'));
                chIndex(7) = find(ismember(signalNameArray, 'Gyroscope X'));
                chIndex(8) = find(ismember(signalNameArray, 'Gyroscope Y'));
                chIndex(9) = find(ismember(signalNameArray, 'Gyroscope Z'));
               
                timeStampNew = newData(:,chIndex(1));
                XAccData= newData(:,chIndex(2));
                YAccData= newData(:,chIndex(3));
                ZAccData= newData(:,chIndex(4));
                PPGData = newData(:,chIndex(5));
                GSRData= newData(:,chIndex(6));
                XGyroData= newData(:,chIndex(7));
                YGyroData= newData(:,chIndex(8));
                ZGyroData= newData(:,chIndex(9));
               
               
                PPGDataFiltered = PPGData;
                GSRDataFiltered = GSRData;
                if HPF % filter newData with highpassfilter to remove DC-offset
                        GSRDataFiltered = hpfexg1ch1.filterData(GSRDataFiltered);
                        PPGDataFiltered = hpfexg1ch2.filterData(PPGDataFiltered);
                    end
                   
                    if BSF % filter highpassfiltered data with bandstopfilter to suppress mains interference
                        GSRDataFiltered = bsfexg1ch1.filterData(GSRDataFiltered);
                        PPGDataFiltered = bsfexg1ch2.filterData(PPGDataFiltered);
                    end
                   
                    if LPF % filter bandstopfiltered data with lowpassfilter to avoid aliasing
                        GSRDataFiltered = lpfexg1ch1.filterData(GSRDataFiltered);
                        PPGDataFiltered = lpfexg1ch2.filterData(PPGDataFiltered);
                    end
               
                XAccplotData=[XAccplotData;XAccData];
                YAccplotData=[YAccplotData;YAccData];
                ZAccplotData=[ZAccplotData;ZAccData];
                ppgplotData = [ppgplotData; PPGDataFiltered];                                             % update the plotDataBuffer with the new PPG data
                GSRplotData = [GSRplotData; GSRDataFiltered];
                XGyroplotData=[XGyroplotData; ZGyroData];
                YGyroplotData=[YGyroplotData; ZGyroData];
                ZGyroplotData=[ZGyroplotData; ZGyroData];
               
               
                numPlotSamples = size(ppgplotData,1);                          
                numSamples = numSamples + size(newData,1);
                newstoreData = [timeStampNew XAccData YAccData ZAccData PPGData GSRData XGyroData YGyroData ZGyroData];
                storeData = [storeData; newstoreData];
                                 
                dlmwrite(fileName, storeData, '-append', 'delimiter', '\t','precision',16);    
                if numSamples > NO_SAMPLES_IN_PLOT
                     
                        ppgplotData = ppgplotData(numPlotSamples-NO_SAMPLES_IN_PLOT+1:end,:);
                        filteredplotData = filteredplotData(numPlotSamples-NO_SAMPLES_IN_PLOT+1:end,:);
                       
                end
                 sampleNumber = max(numSamples-NO_SAMPLES_IN_PLOT+1,1):numSamples;
               
                 
% %                                  plotting the data
%                                  set(0,'CurrentFigure',h.figure1);
%                                  subplot(1,2,1)
%                                  plot(sampleNumber, ppgplotData(:,1));                         % plot the PPG data
%                                  legend('PPG (mV)');
%                                  xlim([sampleNumber(1) sampleNumber(end)]);
%                                  ylim('auto');
%                  
%                  
%                                  subplot(1,2,2)
%                                  plot(sampleNumber, GSRplotData(:,1));                         % plot the PPG data
%                                  legend('GSR');
%                                  xlim([sampleNumber(1) sampleNumber(end)]);
%                                  ylim('auto');
%                  
             end
            elapsedTime = elapsedTime + toc;                               % stop timer and add to elapsed time
            tic;                                                           % start timer          
           
        end  
         elapsedTime = elapsedTime + toc;                                   % stop timer
        fprintf('The percentage of received packets: %d \n',shimmer.getpercentageofpacketsreceived(timeStamp)); % Detect loss packets
        shimmer.stop;                                                      % stop data streaming                                                    
       
end
add1='C:\Users\vishy\Desktop';
cd(add1)
add=strcat(add1,'\',userid);
cd(add)
    csvwrite(file,storeData)
cd('C:\Users\vishy\Documents\MATLAB')

shimmer.disconnect;

end
