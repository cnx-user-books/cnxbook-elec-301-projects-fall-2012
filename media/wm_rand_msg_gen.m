function msg = wm_rand_msg_gen(length)
% randomly generate a string (acsii 32 - 126) with length 'length'
% input     length = length of the desired message
% output    msg = randomly generated printable string with length 'length'

r = randi([32, 126], [1, length]);
msg = char(r);

end