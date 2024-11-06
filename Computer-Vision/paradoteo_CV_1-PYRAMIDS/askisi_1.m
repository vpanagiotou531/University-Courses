clear all;
close all;
clc;


% Ο δικος μου κωδικας

apple_jpg = im2double(imread('apple.jpg')); % 

apple_jpg_resize = imresize(apple_jpg, [1024 1024]);

black_jpg = im2double(imread('black.jpg')); % 

black_jpg_resize = imresize(black_jpg, [1024 1024]);

orange_jpg = im2double(imread('orange.jpg')); % 

orange_jpg_resize = imresize(orange_jpg, [1024 1024]);


levels = 4; % 2

gauss_pyr_apple_jpg = gauss_pyramid(apple_jpg, levels);


lapl_pyr_apple_jpg = lapl_pyramid(gauss_pyr_apple_jpg);



out_merged = apple_jpg_resize + orange_jpg_resize;


% Read the JPG image
imageData = imread('apple.jpg');

% Display the image using imshow
figure;
imshow(imageData);

%{
% Optionally, add a title to the plot
title('Your Image');

figure
imshow(apple_jpg_resize);
title('Ye');
%}

%{
 figure
 imshow(out);
 title('out');
%}


% Example: Display the levels of the Gaussian pyramid
for i = 1 : levels+1
    figure;
    imshow(gauss_pyr_apple_jpg{i});
    title(['Level gaussian ', num2str(i-1)]);
end


% Example: Display the levels of the laplacian pyramid
for i = 1 : levels+1
    figure;
    imshow(lapl_pyr_apple_jpg{i});
    title(['Level laplacian ', num2str(i-1)]);
end


figure
imshow(out_merged)
title('out_merged by placing the two initial images together');





%{
 pyramid_B = lapl_pyr_apple_jpg + gauss_pyr_apple_jpg;
 figure;
 plot(pyramid_B);
 title("pyramid_B");
%}

% δικη μ προσθηκη κωδικα
mask_black_white = im2double(imread('mask.png'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ο κωδικας απο το βιντεο https://www.youtube.com/watch?v=N4EPJJx7xVo&list=PLvkMefp2ClcZUCbYbgI2sf3OWhodvKYtL&index=38



apple_jpg = im2double(imread('bench.jpg')); %apple.jpg ειχα βαλει ως αρχικο  % woman.png    %   orange.jpg   %dog1.jpg    dog2.jpg  

apple_jpg_resize = imresize(apple_jpg, [1024 1024]);


orange_jpg = im2double(imread('P200.jpg')); %orange.jpg ειχα βαλει ως αρχικο    %  apple.jpg  %  hand.png  % bench.jpg

orange_jpg_resize = imresize(orange_jpg, [1024 1024]);


% define mask by hand 

figure(1);
imagesc(apple_jpg_resize);
colormap(gray);
axis off;
h = imfreehand( gca ); setColor(h, 'red');
%h = drawfreehand( gca ); setColor(h, 'red');
mask2D = createMask(h);

mask = double(repmat(mask2D,1,1,3));


% direct blend

directBlend = mask2D.*apple_jpg_resize+(1-mask2D).*orange_jpg_resize;



% blending using laplacian 
depth = 2;


% create gaussian pyramids for the two targers and the mask

gauss_pyr_mask = gauss_pyramid(mask, depth);
gauss_pyr_apple_jpg_resize = gauss_pyramid(apple_jpg_resize, depth);
gauss_pyr_orange_jpg_resize = gauss_pyramid(orange_jpg_resize, depth);


% create laplacian pyramids for the two images we have (apple and orange)

lapl_pyr_apple_jpg_resize = lapl_pyramid(gauss_pyr_apple_jpg_resize);
lapl_pyr_orange_jpg_resize = lapl_pyramid(gauss_pyr_orange_jpg_resize);


% blend the two laplacian pyramids together

%blended_pyr = cell(1, length(lapl_pyr_orange_jpg_resize));
%blended_pyr = [];
blended_pyr = cell(size(lapl_pyr_orange_jpg_resize));
for i = 1 : length(lapl_pyr_orange_jpg_resize)
    AppleImgResize = lapl_pyr_apple_jpg_resize(i);
    OrangeImgResize = lapl_pyr_orange_jpg_resize(i);
    MaskPyr = gauss_pyr_mask(i);

    blended_pyr{i} = gauss_pyr_mask{i}.*lapl_pyr_apple_jpg_resize{i} + (1-gauss_pyr_mask{i}).*lapl_pyr_orange_jpg_resize{i};
end
%blended_pyr_numeric = cell2mat(blended_pyr);


% create final blended image

for i = length(blended_pyr): -1 : 2
    tmp = expand(blended_pyr{i});
    rows = size(blended_pyr{i-1},1);
    cols = size(blended_pyr{i-1},2);
    tmp = tmp(1:rows, 1:cols, :);
    blended_pyr{i-1} = blended_pyr{i-1} + tmp;
end

outpyr = blended_pyr{1};



% show all images individually

figure;
imshow(apple_jpg_resize);
title("apple initial image resized")

figure;
imshow(orange_jpg_resize)
title("orange initial image resized")


%figure;
%imshow(outpyr);
%title("blended image of the two initial images");

figure;
imshow(mask);
title('Mask used for blending');

%{
figure;
imshow(directBlend);
title('output by simply placing the two images together');
%}

figure;
imshow(outpyr);
title('output after Laplacian Blending');





%%%%%%%%%%%%%%%%%%%%%%%%%%5
% απο το script blend.m

% Create a pyramid of blending two images together
% Given the Laplacian pyramids of two images as well as the mask
% image, for each scale apply an alpha blending equation


%out2 = blend(apple_jpg_resize, orange_jpg_resize, mask);
