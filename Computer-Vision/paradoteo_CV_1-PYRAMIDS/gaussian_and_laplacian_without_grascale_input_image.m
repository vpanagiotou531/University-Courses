% Gaussian to Laplacian
apple = imread('apple.jpg');

% Levels
levels = 6;

% Initialize Gaussian and Laplacian pyramids
gaussian = cell(1, levels);
laplacian = cell(1, levels);

% Build the Laplacian pyramid
for i = 1:levels
    
    % Downsample the image using Gaussian filtering
    img_down = imfilter(apple, fspecial('gaussian', [5 5], 1), 'symmetric', 'conv');
    img_down = img_down(1:2:end, 1:2:end, :);
    
    % Upsample the downsampled image
    img_up = imresize(img_down, size(apple(:,:,1)), 'bicubic'); % Resize each channel
    
    % Compute the Laplacian image
    lap = double(apple) - double(img_up);
    
    % Store the Laplacian image in the pyramid
    laplacian{i} = lap;
    
    % Store the Gaussian image in the pyramid
    gaussian{i} = img_down;
    
    % Set the input image to the downsampled image for the next level
    apple = img_down;
end

% Display the Laplacian pyramid
for i = 1:levels
    figure;
    subplot(1,2,1);
    imshow(gaussian{i});
    title(['Gaussian Level ' num2str(i)]);
    subplot(1,2,2);
    imshow(uint8(laplacian{i}));
    title(['Laplacian Level ' num2str(i)]);
end
