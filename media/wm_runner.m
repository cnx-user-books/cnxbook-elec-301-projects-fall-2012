function wm_runner
% simulate the cox watermarking process and extraction of a string message

% inputs
host_image = 'lena512color.tiff';
message = 'This is a test message that can be very long and long and long and long and then lets test some of the signs and see if it works or not !@#$%^&*()';  % watermarking string
compress = 200; % compression value, smaller the more compressed. range(1, min(dim(image))) (see wm_comp)

% watermark
code =  wm_encoder(message);
image_wm = wm_cox(host_image, code);
 figure(2), imshow(image_wm, [0, 255]);

% compression watermarked image
image_wm2 = wm_comp(image_wm, compress); 

% extract watermark and decode
code_wm = wm_cox_ext(image_wm2, host_image);
message_wm = wm_decoder(code_wm);


% display results
message_wm % the extracted watermark message
 figure(1), imshow(image_wm2, [0, 255]);
wm_msg_compare(message, message_wm) % ratio of the number of correct characters 

end