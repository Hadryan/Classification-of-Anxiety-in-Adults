function [melCeps] = getMFCC(edaSegment,frequency)
%
%Function to calculate the Mel Frequency Cepstral Coefficients (MFCC) for a given eda signal segment.
% Input: edaSegment - EDA segment [coloumn vector]
% Input: frequency - Frequency of the segment in Hz [Scalar]
% Output: melCeps - Mel Frequency Cepstral Coefficients (MFCC)) [Matrix:13 x number of frames]

data=edaSegment;
fs=frequency;
%% (1) Frame Blocking..
N = 32;   % N point FFT
M = 8;   % Overlapping

NN = floor(N/2+1); %N/2
nbFrames = ceil((length(data)-N)/M);
Frames = zeros(nbFrames+1,N);
for i = 0:nbFrames-1
	temp = data(i*M+1:i*M+N);
    Frames(i+1,1:N) = temp; 
end

% Last Frame..
temp = zeros(1,N); 
lastLength = length(data)- nbFrames*M;
temp(1:lastLength) = data(nbFrames*M+1:(nbFrames*M +1 + lastLength-1));  
Frames(nbFrames+1, 1:N) = temp;

%% (2) Windowing..
frameSize = size(Frames)
nbFrames = frameSize(1);
nbSamples = frameSize(2);
 
% Hamming window.. 
w = hamming(nbSamples); 
Windows = zeros(nbFrames,nbSamples);
for i = 1:nbFrames
	temp = Frames(i,1:nbSamples); 
    Windows(i, 1:nbSamples) = w'.*temp; 
end
%% (3) Fourier Transform..
ffts = fft(Windows');

%% (4) Mel-frequency Wrapping..
% (a) Calculate Power spectrum..
PowSpecs = abs(ffts).^2;
PowSpecs = PowSpecs(1:NN-1,:);
% (b) Mel filter generation
nof_c = 15; % Number of channels..
df = fs/N;
Nmax = N/2;
fmax = fs/2;

% Convert to mel scale..
melmax = 2595*log10(1+fmax/700);
melinc = melmax/(nof_c+1);
melcenters = (1:nof_c).*melinc;

% Convert to frequency scale.. 
fcenters = 700*((10.^(melcenters./2595))-1);
centerf = round(fcenters./df);
startf = [1,centerf(1:nof_c-1)];
stopf = [centerf(2:nof_c),Nmax];

W = zeros(nof_c,Nmax);

% Making filter..
for i = 1:nof_c
	increment = 1.0/(centerf(i)-startf(i));
    for j = startf(i):centerf(i)
    	W(i,j) = (j-startf(i))*increment;
    end
   
    decrement = 1.0/(stopf(i)-centerf(i));
    for j = centerf(i):stopf(i)
    	W(i,j) = (j-centerf(i))*decrement;
    end 
end
    
% Normalising..
for i = 1:nof_c
	W(i,:) = W(i,:)/sum(W(i,:));
end
% melCeps = W;    
% (c) Apply mel filters to Power spectrum coeffs..
melPowSpecs = W*PowSpecs;
% (d) MFCC calculations..
melCeps = dct(log(melPowSpecs));
melCeps(1:2,:) = []; % exclude the first 2 components, since it carries little information