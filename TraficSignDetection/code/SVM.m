% SVM 
    
    %% CLASSIFIER
   
training_folder = fullfile('E:\Sem 1\ENPM 673\project4\upatel22_proj4\P4_Submission\TSR\Training\');
trainingSet = imageSet(training_folder,   'recursive');


trainingFeatures = [];
trainingLabels   = [];

for i = 1:numel(trainingSet)
    
   numImages = trainingSet(i).Count;
   hog = [];
   
   for j = 1:numImages
       img = read(trainingSet(i), j);
       i
       j
       %Resize Image to 64x64
       img = im2single(imresize(img,[64 64]));
       %Get HOG Features
       hog_cl = vl_hog(img, 4);
       [hog_1, hog_2] = size(hog_cl);
       dim = hog_1*hog_2;
       hog_cl_trans = permute(hog_cl, [2 1 3]);
       hog_cl=reshape(hog_cl_trans,[1 dim]); 
       hog(j,:) = hog_cl;
   end
   labels = repmat(trainingSet(i).Description, numImages, 1);
   
   trainingFeatures = [trainingFeatures; hog];
   trainingLabels = [trainingLabels; labels];
end

%SVM
classifier = fitcecoc(trainingFeatures, trainingLabels);

filename = 'SVM.mat';
save(filename)