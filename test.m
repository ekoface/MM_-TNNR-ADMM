%bla bla 
rgbImage = rgb2gray(imread('Lena512.bmp'));
imshow(rgbImage);
noise_level = 0.1; % Adjust the noise level as needed
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
M =...
    [0 1 0.5 3;
    0.5 2 3 0.5;
    1 0.5 1 1;
    2 1 5 0.5];
known = ...
    [1 1 0 1;
    0 1 1 0;
    1 0 1 1 ;
    1 1 1 0];
max_iter  =20;
tol = 10e-6;
image_size = size(rgbImage);
r = image_size(1);
beta = 1/(5*10e-3);
X = algorithm_1(rgbImage, distortion_mask, tol, r, max_iter,beta);
disp(X);

X_normalized = mat2gray(X) * 255;

% Convert X to uint8 data type for image display
X_uint8 = uint8(X_normalized);

% Display the image
figure;
imshow(X_uint8);
title('Processed Image');