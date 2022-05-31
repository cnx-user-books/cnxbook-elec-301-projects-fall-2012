clear all;
filter_size = 3000;
step_size = 0.007;
input_file = 'Weissimp.wav';
iterations = 32768;
Fs = 44100;

% Function to perform the NLMS algorithm on an input file.
% Inputs: Filter order, input wav file, number of iterations.
% Outputs: Input signal, error estimation signal (echo cancelled), desired signal (echoed signal), adaptive filter output, real impulse response
% Estimation of impulse response, mean square error, attenuation (dB), average attenuation, step size.

% Read in the input file
input_signal = wavread(input_file);
%Generate acoustic impulse response and convolve to get echoed signal
impulse=zeros(filter_size,1);
for (i=1:5)
    impulse(((i-1)*filter_size/5)+1)=1/i;
end
desired_signal = wavread('Hanimp.wav');

% initialise variables03
filter_current = zeros(filter_size,1);
input_vector = zeros(filter_size, 1);

% perform the NLMS algorithm for set number of iterations
for i=1:iterations
    % get input sample
    input_vector(1)=input_signal(i);
    filter_output(i)=dot(filter_current, input_vector);
    error = desired_signal(i)-filter_output(i);
    % calculate step size
    step_size = 1/(dot(input_vector, input_vector));
    % update filter tap weight vector
    filter_current = filter_current + step_size*error*input_vector;
    % shift input vector
for j=filter_size:-1:2
    input_vector(j)=input_vector(j-1);
end
    error_signal(i)=error;
    cost(i)=error*error;
    ss(i)=step_size;
end

% Find moving average of error squared.
% for i=1:iterations-100
% mse(i)=mean(cost(i:i+100));
% end

%find moving average of db attenuation (averaged to smooth output).
% for i=1:iterations-2500
% db(i) = -20*log10(mean(abs(desired_signal(i:i+2500)))'./mean(abs(error_signal(i:i+2500))));
% end

% find total average db attenuation
% db_avg=mean(db);

subplot(3,1,1); plot(input_signal);
title('Input Signal with Echo');
ylabel('Signal Value'); grid on;
subplot(3,1,2); plot(desired_signal);
title('Desired Output Signal');
ylabel('Signal Value'); grid on;
subplot(3,1,3); plot(filter_output);
title('Filter Output Signal');
ylabel('Signal Value'); grid on;

figure

subplot(2,1,1); plot(impulse);
title('Impulse Response');
ylabel('Signal Value'); grid on;
subplot(2,1,2); plot(error_signal);
title('Error');
ylabel('Signal Value'); grid on;



% soundsc(input_signal,Fs);
% disp('Playing Input Signal...');
% soundsc(desired_signal,Fs);
% disp('Playing Desired Signal...');
% soundsc(filter_output,Fs);
% disp('Playing Output Signal...');
 