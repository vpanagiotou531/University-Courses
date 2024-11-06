function [Ls1, Ls2. Ls3. Ls4] = Pyramid_of_image(A)

h = fspecial('gaussian', 3, 0.6);

% Pyramids L1 for image A
At = conv2(A,h,'same');
i = 2:2:size(At,1);
j = 2:2:size(At,2);
L1A = At;
L1a(i,:) = {};
L1A(:,j) = {};

L1At = conv2(L1A,h,'same');
i = 2:2:size(L1At,1);
j = 2:2:size(L1At,2);
L2A = L1At;
L2A(i,:) = {};
L2A(:,j) = {};

Ls1 = A - imresize(L1A,2,'bilinear');
Ls2 = L1A - imresize(L2A,2,'bilinear');
Ls3 = L2A - imresize(L3A,2,'bilinear');
Ls4 = L3A;





















