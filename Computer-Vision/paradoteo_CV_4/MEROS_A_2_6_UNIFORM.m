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
% ALPHA parameter for uniform distribution
a = [6 12 18];
N = 10e+2; % number of iterations

% it is just too time consuming to evaluate for all the frames
% in this machine, so instead calculate the PSNR for L frames
L = 2;

% PSNR for high1, high2, low1, low2
PSNRh_1 = zeros(length(a),L);
PSNRh_lk_1 = zeros(length(a),L);

PSNRh_2 = zeros(length(a),L);
PSNRh_lk_2 = zeros(length(a),L);

PSNRl_1 = zeros(length(a),L);
PSNRl_lk_1 = zeros(length(a),L);

PSNRl_2 = zeros(length(a),L);
PSNRl_lk_2 = zeros(length(a),L);

%% run the main loop
% it is known that the input videos have the same number of frames
% so, we have one loop for all the videos
% before the alignment apply gaussian(0, var_(i)) distortion to img
for j = 1:length(a)
    for i = 1:L %high1.NumberOfFrames-1
        %high1 video
        mesos = zeros (N,noi);
        mesos_lk = zeros(N,noi);
        disp(['High1: j = ' num2str(j)]);
        tic;
        for k = 1:N
            temp = high1.read(i);
            % apply gaussian distortion to img image
            img = high1.read(i+1);
            % η μη προσημασμενη  8 bit εκδοση της εισοδου -> το κανουμε για
            % να ειναι το img και η εισοδος σε ιδιο τυπο δεδομενων
            noise = -a(j)^(1/3)+((a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                            img, temp, nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRh_1(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRh_lk_1(j,i) = mean(20*log10(255./mean(mesos_lk,2)));
        %high2 video
        mesos = zeros(N,noi);
        mesos_lk = zeros(N,noi);
        disp(['high2: j =' num2str(j)]);
        for k = 1:N
            temp = high2.read(i);
            %apply uniform distortion to img image
            img = high2.read(i+1);
            noise = -a(j)^(1/3)+((a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                            img, temp, nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRh_2(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRh_lk_2(j,i) = mean(20*log10(255./mean(mesos_lk,2)));
        %low1 video
        mesos = zeros(N,noi);
        mesos_lk = zeros(N,noi);
        disp(['low1: j =' num2str(j)]);
        for k = 1:N
            temp = low1.read(i);
            %apply gaussian distortion to img image
            img = low1.read(i+1);
            noise = -a(j)^(1/3)+((a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                            img, temp, nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRl_1(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRl_lk_1(j,i) = mean(20*log10(255./mean(mesos_lk,2)));
        %low2 video
        mesos = zeros(N,noi);
        mesos_lk = zeros(N,noi);
        disp(['low2: j =' num2str(j)]);
        for k = 1:N
            temp = low2.read(i);
            %apply gaussian distortion to img image
            img = low2.read(i+1);
            noise = -a(j)^(1/3)+((a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                            img, temp, nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRl_2(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRl_lk_2(j,i) = mean(20*log10(255./mean(mesos_lk,2)));
    end
end
%get PSNR frames' mean
m_PSNRh_1 = mean(PSNRh_1(:,1:L),2);
m_PSNRh_lk_1 = mean(PSNRh_lk_1(:,1:L),2);
m_PSNRh_2 = mean(PSNRh_2(:,1:L),2);
m_PSNRh_lk_2 = mean(PSNRh_lk_2(:,1:L),2);
m_PSNRl_1 = mean(PSNRl_1(:,1:L),2);
m_PSNRl_lk_1 = mean(PSNRl_lk_1(:,1:L),2);
m_PSNRl_2 = mean(PSNRl_2(:,1:L),2);
m_PSNRl_lk_2 = mean(PSNRl_lk_2(:,1:L),2);
q6_gauss= [m_PSNRh_1 m_PSNRh_lk_1 m_PSNRl_1 m_PSNRl_lk_1;
    m_PSNRh_2 m_PSNRh_lk_2 m_PSNRl_2 m_PSNRl_lk_2 ];

save('A_6_uniform.mat','q6_uniform');