% 1Η ΠΕΡΙΠΤΩΣΗ: ΕΙΚΟΝΑ

% Load the image
fruit = imread('apple.jpg');

% Number of pyramid levels
num_levels = 8;

% Initialize Gaussian pyramid
gaussian_pyramid = cell(1, num_levels);
gaussian_pyramid{1} = fruit;

% Define the Gaussian kernel
gaussian_kernel = fspecial('gaussian', [5, 5], 1);

% Construct Gaussian pyramid
for lvl = 2:num_levels
    % Convolve the image with the Gaussian kernel
    smoothed_image = imfilter(gaussian_pyramid{lvl-1}, gaussian_kernel, 'replicate');
    
    % Downsample the smoothed image using the Kronecker product
    downsampled_image = smoothed_image(1:2:end, 1:2:end, :);
    
    % Save the downsampled image
    gaussian_pyramid{lvl} = downsampled_image;
end

% Initialize Laplacian pyramid
laplacian_pyramid = cell(1, num_levels);
laplacian_pyramid{num_levels} = gaussian_pyramid{num_levels};

% Construct Laplacian pyramid
for lvl = num_levels-1:-1:1
    % Upsample the next level of the Gaussian pyramid
    upsampled_image = imresize(gaussian_pyramid{lvl+1}, size(gaussian_pyramid{lvl}(:,:,1)), 'nearest');
    
    % Compute the difference between the upsampled image and the original image
    laplacian_pyramid{lvl} = gaussian_pyramid{lvl} - upsampled_image;
end

% Represent the pyramids and the original image in each level
for lvl = 1:num_levels
    figure;
    subplot(1, 3, 1);
    imshow(gaussian_pyramid{lvl});
    title(['Gaussian Level ', num2str(lvl)]);
    
    subplot(1, 3, 2);
    imshow(laplacian_pyramid{lvl});
    title(['Laplacian Level ', num2str(lvl)]);
    
    if lvl == num_levels
        subplot(1, 3, 3);
        imshow(gaussian_pyramid{lvl});
        title('Original Image');
    end
end


%2Η ΠΕΡΙΠΤΩΣΗ: ΔΙΑΝΥΣΜΑ

% Define the 1-dimensional signal
signal = [1 2 3 4 5 6 7 8];

% Number of pyramid levels
num_levels = 8;

% Initialize Gaussian pyramid
gaussian_pyramid = cell(1, num_levels);
gaussian_pyramid{1} = signal;

% Define the Gaussian kernel
gaussian_kernel = fspecial('gaussian', [1, 5], 1);

% Construct Gaussian pyramid
for lvl = 2:num_levels
    % Convolve the signal with the Gaussian kernel
    smoothed_signal = conv(gaussian_pyramid{lvl-1}, gaussian_kernel, 'same');
    
    % Downsample the smoothed signal
    downsampled_signal = smoothed_signal(1:2:end);
    
    % Save the downsampled signal
    gaussian_pyramid{lvl} = downsampled_signal;
end

% Initialize Laplacian pyramid
laplacian_pyramid = cell(1, num_levels);
laplacian_pyramid{num_levels} = gaussian_pyramid{num_levels};

% Construct Laplacian pyramid
for lvl = num_levels-1:-1:1
    % Upsample the next level of the Gaussian pyramid
    upsampled_signal = interp1(1:length(gaussian_pyramid{lvl+1}), gaussian_pyramid{lvl+1}, linspace(1, length(gaussian_pyramid{lvl+1}), length(gaussian_pyramid{lvl})), 'linear');
    
    % Compute the difference between the upsampled signal and the original signal
    laplacian_pyramid{lvl} = gaussian_pyramid{lvl} - upsampled_signal;
end

% Plot all images of all levels of the pyramid side by side
figure;
for lvl = 1:num_levels
    subplot(2, num_levels, lvl);
    stem(gaussian_pyramid{lvl});
    title(['Gaussian Level ', num2str(lvl)]);
    xlabel('Sample Index');
    ylabel('Amplitude');
    
    subplot(2, num_levels, lvl + num_levels);
    stem(laplacian_pyramid{lvl});
    title(['Laplacian Level ', num2str(lvl)]);
    xlabel('Sample Index');
    ylabel('Amplitude');
end
