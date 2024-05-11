% Preberi izvirno sliko in dodaj šum
rgbImage = rgb2gray(imread('Lena512.bmp'));
noise_level = 0.70; % Prilagodi nivo šuma po potrebi
distorted_lena = imnoise(rgbImage, 'salt & pepper', noise_level);

imshow(distorted_lena);
title('Distorted Lena Image');

% Ustvari masko za sledenje popačenim pikslom
distortion_mask = abs(double(rgbImage) - double(distorted_lena)) > 0;
distortion_mask = 1 - distortion_mask;

% Velikost slike
image_size = size(rgbImage);
r = round(16 * 0.3);
max_iter = 100;
tol = 10e-6;
beta = 5 * 10e3;

new_matrix = ones(image_size);
new_matrix_1 = -1 * ones(image_size);
new_matrix_2 = -1 * ones(image_size);
new_matrix_3 = -1 * ones(image_size);
new_matrix_4 = -1 * ones(image_size);

indeks = 1;

% Preveri bloke 16x16 v moteni sliki in uporabi algoritem 1
for i = 1:8:image_size(1)-15
    for j = 1:8:image_size(2)-15
        block = distorted_lena(i:i+15, j:j+15);
        mask_block = distortion_mask(i:i+15, j:j+15);
        X = algorithm_1(block, mask_block, tol, r, max_iter, beta);

        % Zapiši rezultate v ustrezno novo matriko glede na originalno pozicijo
        switch indeks
            case 1
                new_matrix_1(i:i+15, j:j+15) = X;
                indeks = 2;
            case 2
                new_matrix_2(i:i+15, j:j+15) = X;
                indeks = 3;
            case 3
                new_matrix_3(i:i+15, j:j+15) = X;
                indeks = 4;
            otherwise
                new_matrix_4(i:i+15, j:j+15) = X;
                indeks = 1;
        end
    end
    disp(i)
end

for i = 1:image_size(1)
    for j = 1:image_size(2)
        deljenje = 0;
        vsota = 0;
        if new_matrix_1(i, j) ~= -1
            deljenje = deljenje + 1;
            vsota = vsota + new_matrix_1(i, j);
        end

        if new_matrix_2(i, j) ~= -1
            deljenje = deljenje + 1;
            vsota = vsota + new_matrix_2(i, j);
        end

        if new_matrix_3(i, j) ~= -1
            deljenje = deljenje + 1;
            vsota = vsota + new_matrix_3(i, j);
        end

        if new_matrix_4(i, j) ~= -1
            deljenje = deljenje + 1;
            vsota = vsota + new_matrix_4(i, j);
        end
        new_matrix(i,j) = vsota / deljenje;
    end
end


figure;
imshow(new_matrix, []);
title('Obdelana slika');
figure;
imshow(rgbImage);
title('Izvirna slika');
