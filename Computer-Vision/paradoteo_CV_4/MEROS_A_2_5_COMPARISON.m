% load .mat files and assigning the means to 2x2 matrices
% these matrices contain in the first row statistics about the high1, low1
% videos, and in the 2nd row statistics about the high2, low2 videos

clear all; close all;
load('A_4.mat')
load('A_5_template.mat')
load('A_5_img.mat')
load('A_5_both.mat')
vectory = [q4; q5_template; q5_img; q5_both];
vectorx = [1:4];
% plot
figure('Name','comparison for question 5 and 4');
subplot(1,2,1);
semilogy(vectorx, vectory(1:2:end,1),'-+',vectorx,vectory(1:2:end,2,'-+', ...
    vectorx,vectory(1:2:end,3),'-+',vectorx,vectory(1:2:end,4),'-+')); 
title('comparison for question 5 and 4 - high1 and low1');
xlabel(''); ylabel('PSNR_(dB)');
legend('PSNR_high\1','PSNR_high\_KL\_1','PSNR_low\_1','PSNR_low\_LK\_1')
subplot(1,2,2);
semilogy(vectorx, vectory(1:2:end,1),'-+',vectorx,vectory(1:2:end,2,'-+', ...
    vectorx,vectory(1:2:end,3),'-+',vectorx,vectory(1:2:end,4),'-+')); 
title('comparison for question 5 and 4 - high2 and low2');
xlabel(''); ylabel('PSNR_(dB)');
legend('PSNR_high\_2','PSNR_high\_KL\_2','PSNR_low\_2','PSNR_low\_LK\_2')

















