% Load the input image
woman = imread('woman.png');
hand = imread('hand.png');

% Display woman image in a separate plot window
figure;
imshow(woman);
title('Original Woman Image');

woman = rgb2gray(woman);
hand = rgb2gray(hand);
xmin = min(80,80);
ymin = min(80,80);
width = 50;
height = 40;
roi = [xmin ymin width height];

woman = imresize(woman,[189,200]);

% Display resized woman image in a separate plot window
figure;
imshow(woman);
title('Resized Woman Image');

% Crop the image to the selected ROI
eyeCropped = imcrop(woman, roi);

% Display cropped woman image in a separate plot window
figure;
imshow(eyeCropped);
title('Cropped Woman Image');

[canvrows,canvcols] = size(hand);

canvas = zeros(canvrows,canvcols);
canvas(:,:)=255;
opacity = 1;

canvas(80:120, 80:130) = 0;

% Display canvas image in a separate plot window
figure;
imshow(canvas);
title('Canvas Image');

lims = stretchlim(canvas);
low = lims(1);
high = lims(2);

canvas = imadjust(canvas, [low, high], [0, opacity]);

% Display adjusted canvas image in a separate plot window
figure;
imshow(canvas);
title('Adjusted Canvas Image');

woman = im2double(woman);
hand = im2double(hand);

fusedImg1 = bsxfun(@times, woman, 1-canvas);
fusedImg2 = bsxfun(@times, hand, canvas);

% Display fused images separately in different plot windows
figure;
imshow(fusedImg1);
title('Fused Image 1');

figure;
imshow(fusedImg2);
title('Fused Image 2');

fused = bsxfun(@times, woman, 1-canvas) + bsxfun(@times, hand, canvas);

% Display final fused image in a separate plot window
figure;
imshow(fused);
title('Final Fused Image');
