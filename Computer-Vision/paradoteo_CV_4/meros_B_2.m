clear all; close all;
load('img.mat');
img = uint8(img); % convert to uint8 for rigth display results
frames = 2; % number of frames
% struct containing all the frames
video(frames) = struct('cdata',[],'colormap',[]);
% insert frames to img1
video(1) = im2frame(img,gray(256));
video(2) = im2frame(img,gray(256));













