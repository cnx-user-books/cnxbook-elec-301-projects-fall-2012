function W2 = wm_cox_ext(image_wm, image)
% extract Cox et al watermark
% input     image_wm = watermarked image
%           image = directory of the host image file (key)
% output    W2 = extracted watermark from the watermarked image

% default extraction length
w_size = 1000;

A = imread(image); %  import the 24-bit color image
A = rgb2gray(A); %  make the image BW
B = dct2(A); %  perform 2D discrete cosine transform on the original image
[r, c] = size(B); 

B1 = reshape(B, 1, r*c); %  make dct image into a vector
[B1, index] = sort(abs(B1), 'descend'); %  sort the dct vector from largest to smallest
% W = code;%  generate a Gaussian spread  spectrum noise to use as watermark signal
index_max=index(2:w_size+1); %  get indices of the largest w_size dct values except 1

%  finding associated row-column order for vector values
index_pair = zeros(w_size, 2);
for k=1:w_size
x = floor(index_max(k)/r)+1; %  associated culomn in the image 
y = mod(index_max(k),r); %  associated row in the image 
index_pair(k,1)=y;
index_pair(k,2)=x;
end

C = dct2(image_wm);

% extraction
W2 = zeros(1, w_size);
for k=1:w_size
W2(k) = (C(index_pair(k,1),index_pair(k,2))/B(index_pair(k,1),index_pair(k,2))-1)*10;%watermark extraction 
end

end