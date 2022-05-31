function message = wm_decoder(code)
% takes code words and convert it back to message
% input     code = encoded message by wm_encoder
% output    message = retrieved message

y = code.*1000;
z = round(y);
z(z==0) = []; % remove excess 'blanks' at the end of the message
message = char(z); % convert acsii doubles back to a string

end