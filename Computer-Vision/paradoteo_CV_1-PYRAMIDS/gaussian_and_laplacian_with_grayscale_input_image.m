% Gaussian to Laplacian
apple = imread('apple.jpg');

% αν εκτελεσω size(apple), θα βγαλει οτι ειναι ενα image array μεγεθους
% [301 420 3], δλδ η μεταβλητη apple ειναι μια χρωματιστη εικονα (οχι
% ασπρομαυρη) με 3 καναλια

% Levels
levels = 6;
apple_gray = rgb2gray(apple); % 

% Initialize Gaussian and Laplacian pyramids
gaussian = cell(1, levels);
laplacian = cell(1, levels);

% Build the Laplacian pyramid
for i = 1:levels
    
    % Downsample the image using Gaussian filtering
    img_down = imfilter(apple_gray, fspecial('gaussian', [5 5], 1), 'symmetric', 'conv');
    img_down = img_down(1:2:end, 1:2:end);
    
    % Upsample the downsampled image
    img_up = imresize(img_down, size(apple_gray), 'bicubic');
    
    % Compute the Laplacian image
    lap = double(apple_gray) - double(img_up);
    
    % Store the Laplacian image in the pyramid
    laplacian{i} = lap;
    
    % Store the Gaussian image in the pyramid
    gaussian{i} = img_down;
    
    % Set the input image to the downsampled image for the next level
    apple_gray = img_down;
end

% Display the Laplacian pyramid
for i = 1:levels
    figure;
    subplot(1,2,1);
    imshow(gaussian{i});
    title(['Gaussian Level ' num2str(i)]);
    subplot(1,2,2);
    imshow(laplacian{i});
    title(['Laplacian Level ' num2str(i)]);
end
