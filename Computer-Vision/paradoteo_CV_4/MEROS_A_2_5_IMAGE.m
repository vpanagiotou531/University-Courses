%% read all videos
% high quality video
clear all; tic; %close all;
high1 = VideoReader('video1_high.avi');
high2 = VideoReader('video2_high.avi');
% low quality video
low1 = VideoReader('video1_low.avi');
low2 = VideoReader('video2_low.avi');

%% initialize useful matrices and vectors
nol = 2; % number of levels
noi = 10; % number of iterations

% PSNR for high1, high2, low1, low2
PSNRh_1 = zeros(1,high1.NumberOfFrames-1);
PSNRh_lk_1 = zeros(1,high1.NumberOfFrames-1);

PSNRh_2 = zeros(1,high2.NumberOfFrames-1);
PSNRh_lk_2 = zeros(1,high2.NumberOfFrames-1);

PSNRl_1 = zeros(1,low1.NumberOfFrames-1);
PSNRl_lk_1 = zeros(1,low1.NumberOfFrames-1);

PSNRl_2 = zeros(1,low2.NumberOfFrames-1);
PSNRl_lk_2 = zeros(1,low2.NumberOfFrames-1);


%% run the main loop
% it is known that the input videos have the same number of frames
% so, we have one loop for all the videos
for i = 1:high1.NumberOfFrames-1
    % High1 video
    temp = double(high1.read(i));
    img = double(high1.read(i+1)) + randi([-3 3],256,256);
    [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                            img, temp, nol,noi,'affine',eye(2,3));
    %[~, ~, MSE, ~, MSELK] = ecc_lk_alignment( ...
    %                                         img, temp, nol,noi,'affine',eye(2,3));
    PSNRh_1(i) = mean(20*log10(255./MSE));
    PSNRh_lk_1(i) = mean(20*log10(255./MSELK));
    % High2 video
    temp = double(high2.read(i));
    img = double(high2.read(i+1)) + randi([-3 3],256,256);
    [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                             img, temp, nol,noi,'affine',eye(2,3));
    PSNRh_2(i) = mean(20*log10(255./MSE));
    PSNRh_lk_2(i) = mean(20*log10(255./MSELK));
    % Low1 video
    temp = double(low1.read(i));
    img = double(low1.read(i+1)) + randi([-3 3],64,64);
    [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                             img, temp, nol,noi,'affine',eye(2,3));
    PSNRl_1(i) = mean(20*log10(255./MSE));
    PSNRl_lk_1(i) = mean(20*log10(255./MSELK));
    % Low2 video
    temp = double(low2.read(i));
    img = double(low2.read(i+1)) + randi([-3 3],64,64);
    [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                             img, temp, nol,noi,'affine',eye(2,3));
    PSNRl_2(i) = mean(20*log10(255./MSE));
    PSNRl_lk_2(i) = mean(20*log10(255./MSELK));

end
m_PSNRh_1 = mean(PSNRh_1);
m_PSNRh_lk_1 = mean(PSNRh_lk_1);
m_PSNRh_2 = mean(PSNRh_2);
m_PSNRh_lk_2 = mean(PSNRh_lk_2);

m_PSNRl_1 = mean(PSNRh_1);
m_PSNRl_lk_1 = mean(PSNRl_lk_1);
m_PSNRl_2 = mean(PSNRl_2);
m_PSNRl__lk_2 = mean(PSNRl_lk_2);
q5_image = [m_PSNRh_1 m_PSNRh_lk_1 m_PSNRl_1 m_PSNRl_lk_1;
        m_PSNRh_2 m_PSNRh_lk_2 m_PSNRl_2 m_PSNRl_lk_2];
save('A_5_image.mat','q5_img');


%% semilogy results
xvector = [1:high1.NumberOfFrames-1];
% high video
figure('Name','PSNR for high video');
semilogy(xvector,PSNRh_1,'-+b'); hold on; semilogy(xvector, PSNRh_2,'-+r');
semilogy(xvector,PSNRh_lk_1,'-+k'); hold on; semilogy(xvector, PSNRh_lk_2,'-+g');
ylabel('PSNR_(dB)'); xlabel('Time');
title('PSNR for high video');
legend('High\_1\_ECC','High\_2\_ECC','High\_1\_LK','High\_2\_ECC');
% low video
figure('Name','PSNR for low video');
semilogy(xvector,PSNRl_1,'-+b'); hold on; semilogy(xvector,PSNRl_2,'-+r');
semilogy(xvector,PSNRl_lk_1,'-+k'); semilogy(xvector,PSNRl_lk_2,'-+g');
ylabel('PSNR_(dB)'); xlabel('Time');
title('PSNR for low video');
legend('Low\_1\_ECC','Low\_2\_ECC','Low\_1\_LK','Low\_2\_ECC');
% high and low video
figure('Name','PSNR for all videos');
semilogy(xvector,PSNRh_1,'-+',xvector,PSNRh_2,'-+',xvector,PSNRh_lk_1,'-+', ...
    xvector,PSNRh_lk_2,'-+',xvector,PSNRl_1,'-+',xvector,PSNRl_2,'-+', ...
    xvector,PSNRl_lk_1,'-+',xvector,PSNRl_lk_2,'-+');
ylabel('PSNR_(dB)'), xlabel('Time')
title('PSNR for all videos');
legend('High\_1\_ECC','High\_2\_ECC','High\_1\_LK','High\_2\_ECC', ...
    'Low\_1\_ECC','Low\_2\_ECC','Low\_1\_LK','Low\_2\_ECC');































