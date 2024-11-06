% 1Η ΠΕΡΙΠΤΩΣΗ: ΕΙΚΟΝΑ

% Load the image
fruit = imread('apple.jpg');

% αριθμός επιπέδων πυραμίδας
num_levels = 8;

% αρχικοποίηση Gaussian pyramid
pyramid = cell(1, num_levels);
pyramid{1} = fruit;

% ορισμός του Gaussian kernel
gaussian_kernel = fspecial('gaussian', [5, 5], 1);

% κατασκευή Gaussian pyramid
for lvl = 2:num_levels
    % συνέλιξη της εικόνας με το gaussian kernel
    smoothed_image = imfilter(pyramid{lvl-1}, gaussian_kernel, 'replicate');
    
    % υπο-δειγματοληψία της smoothed εικόνας με χρήση του kronecker γινομένου
    downsampled_image = smoothed_image(1:2:end, 1:2:end, :);
    
    % αποθηκευση της downsampled εικόνας
    pyramid{lvl} = downsampled_image;
end



% αναπαράσταση των πυραμίδων και της εικόνας σε κάθε πυραμίδα
for lvl = 1:num_levels
    figure(lvl)
    imshow(pyramid{lvl})
    title(['Level ', num2str(lvl)])
end


% ο απο πάνω βρόχος, αλλά σε ένα plot όλες οι εικόνες ολων των πυραμιδων
% διπλα-διπλα
figure;
for lvl = 1:num_levels
    subplot(2, 4, lvl);
    imshow(pyramid{lvl});
    title(['Level ', num2str(lvl)]);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%2Η ΠΕΡΙΠΤΩΣΗ: ΔΙΑΝΥΣΜΑ

% Ορισμος του 1-dimensional signal
signal = [1 2 3 4 5 6 7 8];

% αριθμός επιπέδων πυραμίδας
num_levels = 8;

% αρχικοποίηση Gaussian pyramid
pyramid = cell(1, num_levels);
pyramid{1} = signal;

% ορισμός του Gaussian kernel
gaussian_kernel = fspecial('gaussian', [1, 5], 1);

% κατασκευή Gaussian pyramid
for lvl = 2:num_levels
     % συνέλιξη του σηματος με το gaussian kernel
    smoothed_signal = conv(pyramid{lvl-1}, gaussian_kernel, 'same');
    
    % υπο-δειγματοληψία της smoothed εικόνας με χρήση του kronecker γινομένου
    downsampled_signal = smoothed_signal(1:2:end);
    
     % αποθηκευση της downsampled εικόνας
    pyramid{lvl} = downsampled_signal;
end

% σε ένα plot όλες οι εικόνες ολων των πυραμιδων διπλα-διπλα
figure;
for lvl = 1:num_levels
    subplot(1, num_levels, lvl);
    stem(pyramid{lvl});
    title(['Level ', num2str(lvl)]);
    xlabel('Sample Index');
    ylabel('Amplitude');
end

