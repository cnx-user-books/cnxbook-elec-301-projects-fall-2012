function [compress, ratio] = wm_comp_anal()
% analysis of cox watermarking algorithm under different level of
% compressions
% output    compress = vector of compression values
%           ratio = vector of correct ratio values of the same length as
%                   compress

% settings
host_image = 'lena512color.tiff';
msg_length = 1000;
increment = 5; % increment of compress vector, determines the number of data points

% get compress value length
A = imread(host_image); 
A = rgb2gray(A); 
dim = size(A); % get dimension of the image
comp_min = min(dim); % find the smallest dimension and use it as the minimum compression

compress = comp_min:-increment:1; % compress value vector goes from comp_min to 1, in decending order
ratio = zeros(1, length(compress));

% get correct ratio with corresponding compress value
for i=1:1:length(compress)
    ratio(i) = wm_sim_compress(host_image, msg_length, compress(i));
end

% generate a pretty graph
figure(1), h = stem(compress, ratio);
set(gca,'xdir','reverse');
set(h(1), 'MarkerFaceColor','red');
xlabel('Compression Values');
ylabel('Correct Ratio');
t = title('Relationship between Compression and Correct Ratio for Cox''s Watermarking');
set(t, 'FontSize', 16);
end