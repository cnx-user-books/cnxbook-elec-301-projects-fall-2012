function image_comp = wm_comp(image, value)
% Image compression using singular value decomposition
% input     image = grayscale image matrix
%           value = number of singular values to approximate the actual
%                   image

image = im2double(image);
[U S V] = svd(image); % svd returns the singular values of W in descending order 
j = value;
% compress the image by reserving the i biggest singular values and ignoring
% all the other values
image_comp = U(:,1:j) * S(1:j,1:j) * V(:,1:j)';

end