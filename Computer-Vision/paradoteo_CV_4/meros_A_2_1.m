% φορτωση της εικονας 
img = rgb2gray(imread('Lenna.png')); %μετατροπη απο εγχρωμη σε grayscale

% για να δουμε την αποδοση της συναρτησης RESULTS = ECC(IMAGE, TEMPLATE,
% LEVELS, NOI, TRANSFORM, DELTA_P_INIT) , θα εφαρμοσουμε εναν γεωμετρικο
% μετασχηματισμο στην αρχικη εικονα που βαζουμε ως εισοδο, για να δουμε με τι λαθος οι
% αλγοριθμοι θα βρουν τη γεωμετρικη παραμορφωση

%εφαρμοζουμε μεταχηματισμο affine που ειναι μια στρεβλωση, οριζουμε το
%μητρωο Α της στρεβλωσης (που sh_x ειναι η στρεβλωση κατα χ και sh_y ειναι
%η στρεβλωση κατα y), και χρησιμοποιηουμε τη συναρτηση affine2d η οποια
%παιρνει ενα δισδιαστατο μητρωο 3x3 τυπου affine (που σημαινει οτι τα 2
%πρωτα στοιχεια της 3ης γραμμης του μητρωου ειναι μηδενικα (αλλιως θα
%βγαλει λαθος)), και θελει και το μητρωο Α να το βαλουμε ως εισοδο την
%αναστροφη μορφη του Α'. 
 
%Η συναρτηση affine2d επιστρεφει ως εξοδο ενα αντικειμενο γεωμετρικου
%μετασχηματισμου 

% η συναρτηση imwarp παιρνει ως πρωτο ορισμα την εικονα εισοδου, ως 2ο
% ορισμα την εξοδο της affine2d. Το 3ο και 4ο ορισμα της ειναι στην
% επιλογη μας να διαλεξουμε τι θα βαλουμε

% πχ στο 3ο ορισμα η τιμη 'cubic' (που ειναι η καλυτερη ποιοτικα και η ακριβοτερη υπολογιστικα) δηλωνει αν η παρεμβολη μεταξυ δυο σημειων
% θα ειναι κυβικη (θα μπορουσε να ειναι γραμμικη ή κοντινοτερου-γειτονα)

%πχ στο 4ο ορισμα επιλεγουμε τη τιμη 'fillValues' με διπλα το '1' (προεπιλεγμενη τιμη ειναι το '0') επειδη θα
%εφαρμοστει στρεβλωση και κατα καποιο τροπο η εικονα δε θα ειναι πια
%τετραγωνη και επειδη η ματλαμπ αποθηεκυει τις εικονες ειτε ως τετραγωνα
%ειτε ως ορθογωνια θα πρεπει μετα τη στρεβλωση να αναθεσει τιμες στο μητρωο
% της εικονας (Το οποιο δεν ειναι τετραγωνικο μετα τη στρεβλωση, οπως η
% εικονα της λενας που ειναι τετραγωνικη εξ αρχης) ωστε να γινει
% τετραγωνικο οπως ηταν στην αρχη πριν κανουμε στρεβλωση


% σχετικα με τη fillvalues, αν η εικονα ηταν εγχρωμη τοτε θα μπορουσαμε να
% κανουμε την εξης αλλαγη ' 'fillValues' , (1 1 1) 'ωστε σε καθε καναλι να
% γινει γεμισμα με 1 σε καθε καναλι (αντι για (1 1 1) θα μπορουσαμε να
% βαλουμε και σκετο '1' που ισοδυναμει με γεμισμα με 1 σε καθε ενα απο τα 3
% καναλια της εγχρωμης εικονας




sh_x = 0.1;
sh_y = 0.1;

A = [ 1  sh_x 0;
    sh_y   1  0;
      0   0   1];

tform = affine2d(A');

img_= imwarp(img,tform,'cubic','FillValues',1);

tic;
[results,results_lk, MSE,rho,MSELK] = ecc_lk_alignment(img_,img,4,10,'affine',eye(2,3));

time=toc;


































