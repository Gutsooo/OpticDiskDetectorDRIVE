clc;
clear;
close all;

image1 = im2double(imread('E:\lessons\semester 6\Computer Vision\HWs\temp\HomeWorks\HomeWorks\Hw06\DRIVE\Test\images\01_test.tif'));
mask1 = im2double(imread('E:\lessons\semester 6\Computer Vision\HWs\temp\HomeWorks\HomeWorks\Hw06\DRIVE\Test\mask\01_test_mask.gif'));


image2 = im2double(imread('E:\lessons\semester 6\Computer Vision\HWs\temp\HomeWorks\HomeWorks\Hw06\DRIVE\Training\images\25_training.tif'));
mask2 = im2double(imread('E:\lessons\semester 6\Computer Vision\HWs\temp\HomeWorks\HomeWorks\Hw06\DRIVE\Training\mask\25_training_mask.gif'));

% Images green channel (Preprocessing)
green_image1 = image1(:, :, 2);
green_image2 = image2(:, :, 2);

% Gaussian filter on images (Preprocessing)
filtered_image1 = imfilter(green_image1, fspecial('gaussian', [7 7], 1));
filtered_image2 = imfilter(green_image2, fspecial('gaussian', [7 7], 1));

% Find edges in image (Preprocessing)
bw_image1 = edge(filtered_image1, 'Sobel');
bw_image2 = edge(filtered_image2, 'Sobel');

% Calculating hough matrix
matrix1 = hough_circle_transform(bw_image1, 40, 50);
matrix2 = hough_circle_transform(bw_image2, 40, 50);

% Calculate coordinates of center and radius of biggest circle
[value1, index1] = max(matrix1(:));
[value2, index2] = max(matrix2(:));

[a1, b1, r1] = ind2sub(size(matrix1), index1);
r1 = r1 + 39;
[a2, b2, r2] = ind2sub(size(matrix2), index2);
r2 = r2 + 39;

% Draw circle on images(Specify circle)
for i = 1:size(image1, 1)
    for j = 1:size(image1, 1)
        if round(sqrt((i - a1) ^ 2 + (j - b1) ^ 2)) == r1
            image1(i, j, :) = 1;
        end
    end
end
image1(a1 - 1, b1 - 1, :) = 1;
image1(a1 + 1, b1 - 1, :) = 1;
image1(a1 - 1, b1 + 1, :) = 1;
image1(a1 + 1, b1 + 1, :) = 1;
image1(a1, b1, :) = 1;

for i = 1:size(image2, 1)
    for j = 1:size(image2, 1)
        if round(sqrt((i - a2) ^ 2 + (j - b2) ^ 2)) == r2
            image2(i, j, :) = 1;
        end
    end
end
image2(a2 - 1, b2 - 1, :) = 1;
image2(a2 + 1, b2 - 1, :) = 1;
image2(a2 - 1, b2 + 1, :) = 1;
image2(a2 + 1, b2 + 1, :) = 1;
image2(a2, b2, :) = 1;

% Show image
figure, imshow(image1)
% title(['Coordinates of center of the circle = (' num2str(a1) ', ' num2str(b1) ') and circle radius = ' num2str(r1) ' !!'])
figure, imshow(image2)
% title(['Coordinates of center of the circle = (' num2str(a2) ', ' num2str(b2) ') and circle radius = ' num2str(r2) ' !!'])

% Hough circle transform function
function accumulator_matrix = hough_circle_transform(image, r_min, r_max)

% Accumulator matrix
accumulator_matrix = zeros(size(image, 1), size(image, 2), r_max - r_min);

for x = 1:size(image, 1)
    for y = 1:size(image, 2)
        % Existence of a point
        if image(x, y) == 1
            for r = r_min:r_max - 1
                % Create circle equation in hough space
                for theta = 0:360
                    a = round(x - r * cos(theta * pi / 180));
                    b = round(y - r * sin(theta * pi / 180));
                    if a >= 1 && a <= size(image, 1) && b >= 1 && b <= size(image, 2)
                        % Voting
                        accumulator_matrix(a, b, r - r_min + 1) = accumulator_matrix(a, b, r - r_min + 1) + 1;
                    end
                end
            end
        end
    end
end

end