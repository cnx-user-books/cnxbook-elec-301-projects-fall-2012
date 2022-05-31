[desired,fs] = wavread('Hanmale.wav');
[input,fs] = wavread('Wiessmale.wav');
t = 1/fs:1/fs:length(desired)/fs;

% x  = randn(1,512);       % Input to the filter
% b  = fir1(31,0.5);       % FIR system to be identified
% no  = 0.1*randn(1,512);  % Observation noise signal
% d  = filter(b,1,x)+no;   % Desired signal
mu = 0.0006;              % Step size
n  = 128;               % Block length

ha = adaptfilt.blmsfft(64,mu,1,n);

[mumax,mumaxmse] = maxstep(ha,desired)

[y,e] = filter(ha,input,desired);
out = [y(n:end); y(1:n-1)]; %account for shift caused by convolution
error = desired-y;


wavwrite(y,fs,32,'DeechoedMale')
subplot(411); plot(t,desired');
ylabel('Desired')
hold on
subplot(412);plot(t,input');
ylabel('Input')
subplot(413); plot(t,out')
ylabel('Output')
subplot(414); plot(t,error')
ylabel('Error')
title('System Identification of an FIR Filter');
xlabel('Time (s)');