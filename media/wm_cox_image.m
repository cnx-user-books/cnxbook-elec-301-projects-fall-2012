function D = wm_cox_image(image, message)
% apply Cox et al spectral watermarking on a BW image
% input     image = directory of the host image file
%           message = the message image
% output    D = watermarked image
M = imread(message);
M = rgb2gray(M);
N = dct2(M);
[p, q] = size(N);
W = reshape(N, 1, p*q);
w_size = p*q;

A = imread(image); %  import the 24-bit color image
% A = imread('lena512.bmp'); %  import 8-bit BW image
A = rgb2gray(A); %  make the image BW
B = dct2(A); %  perform 2D discrete cosine transform on the original image
[r, c] = size(B); 

% imshow(log(abs(B)),[]), colormap(jet(64)), colorbar; %  dct plot

B1 = reshape(B, 1, r*c); %  make dct image into a vector
[B1, index] = sort(abs(B1), 'descend'); %  sort the dct vector from largest to smallest
index_max=index(2:w_size+1); %  get indices of the largest w_size dct values except 1

%  finding associated row-column order for vector values
index_pair = zeros(w_size, 2);
for k=1:w_size
x = floor(index_max(k)/r)+1; %  associated culomn in the image 
y = mod(index_max(k),r); %  associated row in the image 
index_pair(k,1)=y;
index_pair(k,2)=x;
end

% insertion
C = B; %  create a matrix for watermarked image
for k=1:w_size
%  insert the WM signal into the DCT values
C(index_pair(k,1),index_pair(k,2))=C(index_pair(k,1),index_pair(k,2))+.0005*C(index_pair(k,1),index_pair(k,2)).*W(k); 
end
D=idct2(C);  %  inverse DCT to produce the watermarked image

 figure(1), imshow(A, [0, 255]);
 figure(2), imshow(D, [0, 255]);

end