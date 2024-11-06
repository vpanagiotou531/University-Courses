% from youtube video https://www.youtube.com/watch?v=xouaRWlhN5Y

clear all
close all
clc

tic
% Specify the full path to the image file
file_path_apple = 'C:\Users\User\Documents\Θέματα Όρασης Υπολογιστών\ασκησεις μαθηματος\CV_1-PYRAMIDS\photos\apple.jpg';
file_path_orange = 'C:\Users\User\Documents\Θέματα Όρασης Υπολογιστών\ασκησεις μαθηματος\CV_1-PYRAMIDS\photos\orange.jpg';

% Read the image using imread
image_data_apple = imread(file_path_apple);
image_data_orange = imread(file_path_orange);

image_data_apple_resized = imresize(image_data_apple, [1024 1024],[1 2 2]);
image_data_orange_resized = imresize(image_data_orange, size(image_data_apple_resized));


% Display the images
figure
imshow(image_data_apple);

figure
imshow(image_data_orange);


A = im2double(image_data_apple_resized);
B = im2double(image_data_orange_resized);

C(:,:,1) = channelblend(A(:,:,1), B(:,:,1));
C(:,:,2) = channelblend(A(:,:,2), B(:,:,2));
C(:,:,3) = channelblend(A(:,:,3), B(:,:,3));

% οι δυο εικονες πρεπει να ειναι ισομεγεθεις για να μπορεσει να γινει το
% blending σωστα

toc



%%%%%%%%%%%%%%%%%%%%

function [Lc] = channelblend(A,B)
[La1 La2 La3 La4] = Pyramid_of_image(A);
[Lb1 Lb2 Lb3 Lb4] = Pyramid_of_image(B);
Lc1 = Blend(La1, Lb1);
Lc2 = Blend(La2,Lb2);
Lc3 = Blend(La3,Lb3);
Lc4 = Blend(La4,Lb4);

Lc2 = imresize(Lc2,2,'bilinear');
Lc3 = imresize(Lc3,4,'bilinear');
Lc4 = imresize(Lc4,8,'bilinear');

Lc = Lc1+Lc2+Lc3+Lc4;

end


%%%%%%%%%%%%%%%%

function [Ls1 Ls2 Ls3 Ls4] = Pyramid_of_image(A)

h = fspecial('gaussian', 3, 0.6);

% Pyramids L1 for image A
At = conv2(A,h,'same');
i = 2:2:size(At,1);
j = 2:2:size(At,2);
L1A = At;
L1A(i,:) = [];
L1A(:,j) = [];

L1At = conv2(L1A,h,'same');
i = 2:2:size(L1At,1);
j = 2:2:size(L1At,2);
L2A = L1At;
L2A(i,:) = [];
L2A(:,j) = [];

L2At = conv2(L2A,h,'same');
i = 2:2:size(L2At,1);
j = 2:2:size(L2At,2);
L3A = L2At;
L3A(i,:) = [];
L3A(:,j) = [];

Ls1 = A - imresize(L1A,2,'bilinear');
Ls2 = L1A - imresize(L2A,2,'bilinear');
Ls3 = L2A - imresize(L3A,2,'bilinear');
Ls4 = L3A;

end












