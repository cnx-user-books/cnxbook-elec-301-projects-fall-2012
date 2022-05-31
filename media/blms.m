%%%Andres Cedeno Dec. 14,2012%%%
%%%Appy BLMS Algorithm to an echoed .wav file%%%

[desired,fs] = wavread('No Echo Male.wav'); %read in non-echoed signal
[input,fs] = wavread('Echo Male.wav'); %read in echoed signal
t = 1/fs:1/fs:length(desired)/fs; %create time vector for plot


mu = 0.0006;              % Step size
n  = 128;               % Block length

hb = adaptfilt.blmsfft(64,mu,1,n); %create filter object




[mumax,mumaxmse] = maxstep(hb,desired) %see if filter is stable with choice of step size
[y,e] = filter(hb,input,desired); %filter the input signal with adaptive filter


out = [y(n:end); y(1:n-1)]; %account for shift caused by block convolution
error = desired-out; %error is desired minus output

% wavwrite(y,fs,32,'DeechoedMale')

%Plot each signal.
subplot(4,1,1); plot(input);
title('Input Signal with Echo');
ylabel('Signal Value'); grid on;
subplot(4,1,2); plot(desired);
title('Desired Output Signal');
ylabel('Signal Value'); grid on;
subplot(4,1,3); plot(out);
title('Filter Output Signal');
ylabel('Signal Value'); grid on;
subplot(4,1,4); plot(error);
title('Error');
ylabel('Signal Value'); grid on;

%calculate root mean square of error signal
rms = sqrt(mean(error.^2))

%Other filters for stem plot comparison
% hl = adaptfilt.lms(64,mu);
% hn = adaptfilt.nlms(64,mu);
% [mumax,mumaxmse] = maxstep(hl,desired)
% [mumax,mumaxmse] = maxstep(hn,desired)
% [y,e] = filter(hn,input,desired);
% [y,e] = filter(hl,input,desired);
% figure(2)
% stem(hl.coefficients,'g')
% hold on
% stem(hb.coefficients,'r')
% stem(hn.coefficients)