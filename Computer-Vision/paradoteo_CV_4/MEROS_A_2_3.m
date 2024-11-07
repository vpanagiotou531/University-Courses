%% read all videos
% high quality video
close all; clear all;
high1 = VideoReader("video1_high.avi");
high2 = VideoReader('video2_high.avi');
% low quality video
low1 = VideoReader("video1_low.avi");
low2 = VideoReader('video2_low.avi');

%% initialize useful matricse and vectors
nol = [2:3]; % number of levels
noi = [10:5:50]; % number of iterations
%execution time vectors
t_high1 = zeros(length(nol),length(noi));
t_high2 = zeros(length(nol),length(noi));
t_low1 = zeros(length(nol),length(noi));
t_low2 = zeros(length(nol),length(noi));
% PSNR for high1,high2,low1,low2
PSNRh_1 = zeros(length(nol),length(noi));
PSNRh_lk_1 = zeros(length(nol),length(noi));

PSNRh_2 = zeros(length(nol),length(noi));
PSNRh_lk_2 = zeros(length(nol),length(noi));

PSNRl_1 = zeros(length(nol),length(noi));
PSNRl_lk_1 = zeros(length(nol),length(noi));

PSNRl_2 = zeros(length(nol),length(noi));
PSNRl_lk_2 = zeros(length(nol),length(noi));
%
frame = 70;
%
%initialize templates
temp_h_1 = high1.read(1); % ή readframe 
temp_h_2 = high2.read(1);
temp_l_1 = low1.read(1);
temp_l_2 = low2.read(1);
% initialize images
img_h_1 = high1.read(frame); % ή readframe
img_h_2 = high1.read(frame);
img_l_1 = low1.read(frame);
img_l_2 = low2.read(frame);


%% run the main loop
% for every combination of noi and nol -> calculate PSNR and execution time
for i = 1:length(nol)
    for j = 1:length(noi)
        % High1 video
        tic;
        [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment(img_h_1,temp_h_1,i,j,'affine',eye(2,3));
        t_high1(i,j) = toc;
        PSNRh_1(i,j) = mean (20*log10(255./MSE));
        PSNRh_lk_1(i,j) = mean(20*log10(255./MSELK));
        %High2 video
        tic;
        [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment(img_h_2,temp_h_2,i,j,'affine',eye(2,3));
        t_high2(i,j) = toc;
        PSNRh_2(i,j) = mean(20*log10(255./MSE));
        PSNRh_lk_2(i,j) = mean(20*log10(255./MSELK));
        %Low1 video
        tic;
        [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment(img_l_1,temp_l_1,i,j,'affine',eye(2,3));
        t_low1(i,j) = toc;
        PSNRl_1(i,j) = mean(20*log10(255./MSE));
        PSNRl_lk_1(i,j) = mean(20*log10(255./MSELK));
        %Low2 video
        tic;
        [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment(img_l_2,temp_l_2,i,j,'affine',eye(2,3));
        t_low2(i,j) = toc;
        PSNRl_2(i,j) = mean(20*log10(255./MSE));
        PSNRl_lk_2(i,j) = mean(20*log10(255./MSELK));
    end
end

%% plot results
xvector = noi; % αντι για [1:length(noi)];
% high video ECC vs LK
figure('Name','PSNR for high video');
semilogy(xvector,PSNRh_1(1,:),xvector,PSNRh_2(1,:), ...
        xvector,PSNRh_lk_1(1,:),xvector,PSNRh_lk_2(1,:), ...
        xvector,PSNRh_1(2,:),xvector,PSNRh_2(2,:), ...
        xvector,PSNRh_lk_1(2,:),xvector,PSNRh_lk_2(2,:));
hold on;
ylabel('PSNR_(dB)');
xlabel('Number of Iterations');
title('PSNR for high video');
legend(sprintf('High\\_1\\_ECC\\_nol:%d',1), ...
       sprintf('High\\_2\\_ECC\\_nol:%d',1), ...
       sprintf('High\\_1\\_LK\\_nol:%d',1), ...
       sprintf('High\\_2\\_LK\\_nol:%d',1), ...
       sprintf('High\\_1\\_ECC\\_nol:%d',2), ...
       sprintf('High\\_2\\_ECC\\_nol:%d',2), ...
       sprintf('High\\_1\\_LK\\_nol:%d',2), ...
       sprintf('High\\_2\\_LK\\_nol:%d',2));
% Low video ECC vs LK
figure('Name','PSNR for low video');
semilogy(xvector,PSNRl_1(1,:),xvector,PSNRl_2(1,:), ...
    xvector,PSNRl_lk_1(1,:),xvector,PSNRl_lk_2(1,:), ...
    xvector,PSNRl_1(2,:),xvector,PSNRl_2(2,:), ...
    xvector,PSNRl_lk_1(2,:),xvector,PSNRl_lk_2(2,:));
hold on;
ylabel('PSNR_(dB)');
xlabel('Number of Iterations');
title('PSNR for low video');
legend(sprintf('Low\\_1\\_ECC\\_nol:%d',1), ...
       sprintf('Low\\_2\\_ECC\\_nol:%d',1), ...
       sprintf('Low\\_1\\_LK\\_nol:%d',1), ...
       sprintf('Low\\_2\\_LK\\_nol:%d',1), ...
       sprintf('Low\\_1\\_ECC\\_nol:%d',2), ...
       sprintf('Low\\_2\\_ECC\\_nol:%d',2), ...
       sprintf('Low\\_1\\_LK\\_nol:%d',2), ...
       sprintf('Low\\_2\\_LK\\_nol:%d',2));
% Execution time
figure('Name','Execution time for low video');
plot(xvector,t_high1(1,:),xvector,t_high2(1,:), ...
        xvector,t_low1(1,:),xvector,t_low2(1,:), ...
        xvector,t_high1(2,:),xvector,t_high2(2,:), ...
        xvector,t_low1(2,:),xvector,t_low2(2,:)); %plot αντι για semilogy διοτι η λογαριθμικη κλιμακα δε βοηθαει πολυ σε αυτη τη περιπτωση
hold on;
ylabel('Time(sec.)');
xlabel('Number of Iterations');
title('Time execution');
legend(sprintf('High\\_1\\_ECC\\_nol:%d',1), ...
       sprintf('High\\_2\\_ECC\\_nol:%d',1), ...
       sprintf('High\\_1\\_LK\\_nol:%d',1), ...
       sprintf('High\\_2\\_LK\\_nol:%d',1), ...
       sprintf('High\\_1\\_ECC\\_nol:%d',2), ...
       sprintf('High\\_2\\_ECC\\_nol:%d',2), ...
       sprintf('High\\_1\\_LK\\_nol:%d',2), ...
       sprintf('High\\_2\\_LK\\_nol:%d',2));



































