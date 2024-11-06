% απο το mathworks tutorial -- https://blogs.mathworks.com/steve/2019/05/20/multiresolution-pyramids-part-4-image-blending/

%apple_url = 'https://blogs.mathworks.com/steve/files/apple.jpg';
%A = im2double(imread(apple_url));
A = im2double(imread('dog2.jpg')); % apple.jpg woman.png igem.jpg  dog1.jpg
A = imresize(A, [1024, 1024]);

figure;
%subplot(1,2,1)
imshow(A)
title('Image 1');




%orange_url = 'https://blogs.mathworks.com/steve/files/orange.jpg';
%B = im2double(imread(orange_url));
B = im2double(imread('bench.jpg')); % orange.jpg hand.png  bench.jpg
B = imresize(B, [1024, 1024]);

figure;
%subplot(1,2,2)
imshow(B)
title('Image 2');




mask_A = zeros(1024,1024);
mask_A(:,1:512) = 1;

clf
imshow(mask_A)
xticks([])
yticks([])
axis on





C = (A .* mask_A) + (B .* (1 - mask_A));
clf
imshow(C)
title('Image 3');

xticks([])
yticks([])






mrp_A = multiresolutionPyramid(A);
mrp_B = multiresolutionPyramid(B);
mrp_mask_A = multiresolutionPyramid(mask_A);

lap_A = laplacianPyramid(mrp_A);
lap_B = laplacianPyramid(mrp_B);






for k = 1:length(lap_A)
    lap_blend{k} = (lap_A{k} .* mrp_mask_A{k}) + ...
        (lap_B{k} .* (1 - mrp_mask_A{k}));
end





C_blended = reconstructFromLaplacianPyramid(lap_blend);
figure;
imshow(C_blended)
title('Image 4');





x = linspace(-1,1,1024);
y = x';
mask2_A = hypot(x,y) <= 0.5;

mrp_mask2_A = multiresolutionPyramid(mask2_A);

for k = 1:length(lap_A)
    lap_blend2{k} = (lap_A{k} .* mrp_mask2_A{k}) + ...
        (lap_B{k} .* (1 - mrp_mask2_A{k}));
end

C2_blended = reconstructFromLaplacianPyramid(lap_blend2);
figure;
imshow(C2_blended)
title('Image 5');








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function mrp = multiresolutionPyramid(A,num_levels)
%multiresolutionPyramid(A,numlevels)
%   mrp = multiresolutionPyramid(A,numlevels) returns a multiresolution
%   pyramd from the input image, A. The output, mrp, is a 1-by-numlevels
%   cell array. The first element of mrp, mrp{1}, is the input image.
%
%   If numlevels is not specified, then it is automatically computed to
%   keep the smallest level in the pyramid at least 32-by-32.

%   Steve Eddins
%   Copyright The MathWorks, Inc. 2019

A = im2double(A);

M = size(A,1);
N = size(A,2);

if nargin < 2
    lower_limit = 32;
    num_levels = min(floor(log2([M N]) - log2(lower_limit))) + 1;
else
    num_levels = min(num_levels, min(floor(log2([M N]))) + 2);
end

mrp = cell(1,num_levels);

smallest_size = [M N] / 2^(num_levels - 1);
smallest_size = ceil(smallest_size);
padded_size = smallest_size * 2^(num_levels - 1);

Ap = padarray(A,padded_size - [M N],'replicate','post');

mrp{1} = Ap;
for k = 2:num_levels
    mrp{k} = imresize(mrp{k-1},0.5,'lanczos3');
end

mrp{1} = A;
end

function lapp = laplacianPyramid(mrp)

% Steve Eddins
% MathWorks

lapp = cell(size(mrp));
num_levels = numel(mrp);
lapp{num_levels} = mrp{num_levels};
for k = 1:(num_levels - 1)
   A = mrp{k};
   B = imresize(mrp{k+1},2,'lanczos3');
   [M,N,~] = size(A);
   lapp{k} = A - B(1:M,1:N,:);
end
lapp{end} = mrp{end};

end

function out = reconstructFromLaplacianPyramid(lapp)

% Steve Eddins
% MathWorks

num_levels = numel(lapp);
out = lapp{end};
for k = (num_levels - 1) : -1 : 1
   out = imresize(out,2,'lanczos3');
   g = lapp{k};
   [M,N,~] = size(g);
   out = out(1:M,1:N,:) + g;
end
end