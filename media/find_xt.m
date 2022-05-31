%%%%%%%%%%%%%%%%%%
% Used to reconstruct the original signal x(t) given an impulse
% response of a room h(t) and the echoed audio recording y(t). Does so
% by deconvolving y(t) by h(t). Also attempts to remove the frequency
% content of any room/equipment noise
%
% @param ht -- impulse response of the room (column vector)
% @param yt -- noisy echoed signal (column vector)
% @param nt -- the background noise introduced by recording 
%              equipment and room (column vector)
% @return xt -- the original signal, reconstructed (column vector)
%
% @author Andrew Martin
%%%%%%%%%%%%%%%%%%
function [ xt ] = find_xt(ht,yt,nt)

    %zero pad the shorter two signals to the length of the longest
    max_length = max(length(ht),max(length(yt),length(nt)));
    ht = [1 ; zeros(max_length - length(ht),1)];
    yt = [1 ; zeros(max_length - length(yt),1)];
    nt = [1 ; zeros(max_length - length(nt),1)];
    
    %fft to frequency domain
    Yf = fft(yt);
    Hf = fft(ht);
    Nf = fft(nt);
    
    %subtract noise freq content out and divide by impulse response
    %added epsilon to Hf to avoid divisions by 0
    Xf = (Yf-Nf)./(Hf+eps);
    
    %ifft to the time domain
    xt = ifft(Xf);

end

