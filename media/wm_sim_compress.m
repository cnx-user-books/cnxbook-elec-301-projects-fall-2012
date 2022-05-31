function ratio = wm_sim_compress(host_image, msg_length, compress)
% apply watermark message, randomly generated string, the a host image and
% then extract it to compare correct ratio.
% input     host_image = image used to carry the watermarking message
%           length = length of the random message
%           compress = compression value
% output    ratio =  ratio of number of correct characters 

% generate message
message = wm_rand_msg_gen(msg_length);

% watermark
code =  wm_encoder(message);
image_wm = wm_cox(host_image, code);
% figure(2), imshow(image_wm, [0, 255]);

% compression watermarked image
image_wm2 = wm_comp(image_wm, compress); 

% extract watermark and decode
code_wm = wm_cox_ext(image_wm2, host_image);
message_wm = wm_decoder(code_wm);

% display results
% message_wm % the extracted watermark message
ratio = wm_msg_compare(message, message_wm); % ratio of the number of correct characters 

end