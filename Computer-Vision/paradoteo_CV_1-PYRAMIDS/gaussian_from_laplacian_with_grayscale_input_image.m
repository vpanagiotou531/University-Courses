
% Read the input image
input_image = imread('apple.jpg');

% Convert the input image to grayscale (if it's a color image)
if size(input_image, 3) == 3
    input_image = rgb2gray(input_image);
end

% Generate the Gaussian pyramid
num_levels = 6; % Choose the number of pyramid levels
gaussian_pyramid = cell(1, num_levels);
gaussian_pyramid{1} = input_image;
for i = 2:num_levels
    gaussian_pyramid{i} = imresize(gaussian_pyramid{i-1}, 0.5);
end

% Generate the Laplacian pyramid from the Gaussian pyramid
laplacian_pyramid = gaussian_to_laplacian(gaussian_pyramid);

% Generate the Gaussian pyramid from the Laplacian pyramid
reconstructed_gaussian_pyramid = laplacian_to_gaussian(laplacian_pyramid);

% Display original and reconstructed images
figure;
subplot(2,2,1);
imshow(input_image);
title('Original Image');

% Display the highest level of the Gaussian pyramid
subplot(2,2,2);
imshow(gaussian_pyramid{num_levels});
title('Highest Level of Gaussian Pyramid');

% Display the highest level of the Laplacian pyramid
subplot(2,2,3);
imshow(laplacian_pyramid{num_levels});
title('Highest Level of Laplacian Pyramid');

% Display the reconstructed image from Laplacian pyramid
subplot(2,2,4);
imshow(reconstructed_gaussian_pyramid{1});
title('Reconstructed Image from Laplacian Pyramid');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function laplacian_pyramid = gaussian_to_laplacian(gaussian_pyramid)
    levels = numel(gaussian_pyramid);
    laplacian_pyramid = cell(1, levels);
    
    % First level of Laplacian pyramid is same as the highest level of Gaussian pyramid
    laplacian_pyramid{levels} = gaussian_pyramid{levels};
    
    % Generate other levels by subtracting upsampled Gaussian images from Gaussian pyramid
    for i = levels-1:-1:1
        expanded_image = imresize(gaussian_pyramid{i+1}, size(gaussian_pyramid{i}));
        laplacian_pyramid{i} = gaussian_pyramid{i} - expanded_image;
    end
end




function gaussian_pyramid = laplacian_to_gaussian(laplacian_pyramid)
    levels = numel(laplacian_pyramid);
    gaussian_pyramid = cell(1, levels);
    
    % Highest level of Gaussian pyramid is same as the highest level of Laplacian pyramid
    gaussian_pyramid{levels} = laplacian_pyramid{levels};
    
    % Generate other levels by adding Laplacian images to upsampled images
    for i = levels-1:-1:1
        expanded_image = imresize(gaussian_pyramid{i+1}, size(laplacian_pyramid{i}));
        gaussian_pyramid{i} = laplacian_pyramid{i} + expanded_image;
    end
end
