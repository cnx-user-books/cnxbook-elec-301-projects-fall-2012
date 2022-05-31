function ratio = wm_msg_compare(msg, msg_wm)
% compare the original and watermarked messages ignoring the excess
% characters in the watermark message.
% input     msg = original message
%           msg_wm = watermarked message
% output    ratio = ratio between the number of correct characters over
%                   total

% convert both messages into ascii representations of the same length
x1 = double(msg);
x2 = double(msg_wm);
l1 = length(x1);
l2 = length(x2);
if l1 <= l2
    x2 = x2(1:l1);
else
    x2(l1) = 0;
end
% compare the two ascii vectors
comp = (x1 == x2);
correct = sum(comp);
wrong = l1 - correct;
ratio = correct/l1;

end