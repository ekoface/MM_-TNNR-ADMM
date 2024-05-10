%bla bla 
rgbImage = rgb2gray(imread('Lena512.bmp'));

noise_level = 0.70; % Adjust the noise level as needed
distorted_lena = imnoise(rgbImage, 'salt & pepper', noise_level);

% Display the distorted Lena image

imshow(distorted_lena);

title('Distorted Lena Image');

% Create a mask to track distorted pixels
distortion_mask = abs(double(rgbImage) - double(distorted_lena)) > 0;
distortion_mask = 1 - distortion_mask;
% Display the distortion mask
figure;
imshow(distortion_mask);
title('Distortion Mask');

max_iter  =100;
tol = 10e-6;
image_size = size(rgbImage);
r = round(image_size(1) *0.3);
beta = (5*10e-3);
X = algorithm_1(distorted_lena, distortion_mask, tol, r, max_iter,beta);
disp(X);

X_normalized = mat2gray(X) * 255;

% Convert X to uint8 data type for image display
X_uint8 = uint8(X_normalized);

% Display the image
figure;
imshow(X_uint8);
title('Processed Image');
figure;
imshow(rgbImage);
title('org Image');
