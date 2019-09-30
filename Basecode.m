clc
clear
close all
%the VideoReader create a object called video Object
videoObject = VideoReader('Video_1.mp4');  % The name of the video file being call is "Testfilerun.mov"
imageData = read(videoObject);
numFrames = get(videoObject, 'NumberOfFrames');
Rateframe= get(videoObject, 'FrameRate');
time=get(videoObject, 'Duration');

%extracting the mean values 
meanwindow = mean(mean(imageData(200:270,647:747,1,:))); %mean(mean(window1));
meanwindow = squeeze(meanwindow);
figure
plot((0:numFrames-1)/Rateframe,meanwindow);
%Filering of sample data
Fs = numFrames/time; %Sampling frequency (Hz) 
Fn = Fs/2; %% Nyquist Frequency (Hz)
Wp = [.5   1.3]/Fn;                                          % Passband Frequency (Normalised)
Ws = [.3   1.4]/Fn;                                      % Stopband Frequency (Normalised)
Rp =   1;                                                   % Passband Ripple (dB)
Rs = 50;                                                   % Stopband Ripple (dB)
[n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Filter Order
[z,p,k] = cheby2(n,Rs,Ws);                              % Filter Design
[sosbp,gbp] = zp2sos(z,p,k);                            % Convert To Second-Order-Section For Stability
figure(2)
freqz(sosbp, 2^16, Fs);                                  % Filter Bode Plot
s_filt = filtfilt(sosbp,gbp, meanwindow);                        % Filter Signal
figure(3)
plot((0:numFrames-1)/Rateframe, s_filt)