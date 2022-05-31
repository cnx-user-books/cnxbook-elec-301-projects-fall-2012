function code = wm_encoder(message)
% convert message (string) into a vector of acsii representation of doubles
% input     message = string message
% output    code = encoded message into a vector of doubles of the same
%                  length

y = double(message);
code = y./1000;

end