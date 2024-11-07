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

% και τωρα θα φτιαξουμε 8 διανυσματα για καθε συνδυασμο βιντεο και καθε
% συνδυασμο αλγοριθμου (ecc και lk), Και εκχωρουμε μηδενικα σε μητρωα 1
% γραμμης και 99 στηλων (πχ high1.NumberOfFrames-1 = 99 στηλες ,διοτι ξερουμε οτι ο αριθμος των πλαισιων NumberOfFrames ειναι ισος με 99)

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
% αφου ορισαμε τα διανυσματα PSNR, διατρεχουμε καθε ζευγαρι πλαισιων για καθε βιντεο
for i = 1:high1.NumberOfFrames-1
    % High1 video
    temp = double(high1.read(i)) + randi([-3 3],256,256); % προσθηκη ομοιομορφου θορυβου στη 2-αδικη αναπαρασταση στο τεμπλατε του i-οστου frame του τρεχοντος βιντεο
    % ο θορυβος εχει πανω οριο το -3 και κατω οριο το 3, και το μητρωο
    % προστιθεμενου θορυβου ειναι 256*256 και αυτο διοτι ξερουμε οτι η
    % εικονα ειναι διαστασης 256*256 και το κανουμε αυτο για να προσθεσουμε
    % σε καθε θεση μνημης του frame διαφορετικη ποσοτητα θορυβου (ο θορυβος
    % προερχεται απο την ιδια κατανομη αλλα ο τιμη του σε καθε frame/εικονοστοιχειο θα ειναι
    % διαφορετικη

    % εδω διαβαζουμε το image στο οποίο είναι στο i+1-οστο frame, αποθηκεύουμε και εδώ την tuple αναπαράστασή του έτσι ώστε να έχει νόημα σύγκριση γιατί αν αυτό ήτανε μη-προσημασμένο 
    % των 8 bit και προσπαθήσω να την ελέγξουμε και να την συγκρίνουμε με κάτι το οποίο ήτανε αριθμός κινητής υποδιαστολής ο οποίος έχει υποστεί και θόρυβο τοτε δεν θα είχαμε σωστή σύγκριση και τα αποτελέσματα θα ηταν λαθος 
    % εφόσον ορίσαμε και το image δίνουμε στον 
    img = double(high1.read(i+1)); % και εδω θελει double οπως και απο πανω
    
    %δίνουμε στη συναρτηση ευθυγράμμισης το image template, τον αριθμό των επιπεδων, των αριθμό των επαναληψεων/επίπεδο, τον τύπο του γεωμ μετασσχηματισμου τον οποίο ψάχνουμε να βρούμε, το dp_init (eye) είναι το μοναδίαιο 2 * 3 μητρωο 
    % και εφόσον η συναρτηση μας επιστρεφει πισωτο μέσο τετραγωνικό σφάλμα
    % τοτ ecc (MSE) και το μέσο τετραγωνικο σφάλμα για τον lk που είναι το
    % MSELK, υπολογίζουμε για κάθε τιμή του το μεσο τετραγων σφάλμα psnr
    [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                            img, temp, nol,noi,'affine',eye(2,3));
    %[~, ~, MSE, ~, MSELK] = ecc_lk_alignment( ...
    %                                         img, temp, nol,noi,'affine',eye(2,3));
    PSNRh_1(i) = mean(20*log10(255./MSE));
    PSNRh_lk_1(i) = mean(20*log10(255./MSELK));
    % High2 video
    temp = double(high2.read(i))+ randi([-3 3],256,256);
    img = double(high2.read(i+1)) ;
    [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                             img, temp, nol,noi,'affine',eye(2,3));
    PSNRh_2(i) = mean(20*log10(255./MSE));
    PSNRh_lk_2(i) = mean(20*log10(255./MSELK));
    % Low1 video
    temp = double(low1.read(i))+ randi([-3 3],64,64);
    img = double(low1.read(i+1)) ; % ειναι 64*64 διοτι ξερουμε οτι το frame των low video περιεχει εικονες 64*64, και η μεση τιμη θορυβου που δινουμε εχει μεση τιμη 0 γιατι μεση τιμη μιας κατανομης ειναι απο το α+β/2 = -3+3/2=0
    % και αρα περιμενουμε να μην εχουμε μεγαλες αλλαγες στα psnr και στις
    % ευθυγραμμισεις
    [results, results_lk, MSE, rho, MSELK] = ecc_lk_alignment( ...
                                             img, temp, nol,noi,'affine',eye(2,3));
    PSNRl_1(i) = mean(20*log10(255./MSE));
    PSNRl_lk_1(i) = mean(20*log10(255./MSELK));
    % Low2 video
    temp = double(low2.read(i))+ randi([-3 3],64,64);
    img = double(low2.read(i+1)) ;
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
q5_template = [m_PSNRh_1 m_PSNRh_lk_1 m_PSNRl_1 m_PSNRl_lk_1;
        m_PSNRh_2 m_PSNRh_lk_2 m_PSNRl_2 m_PSNRl_lk_2];
save('A_5_frame.mat','q5_frame');


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































