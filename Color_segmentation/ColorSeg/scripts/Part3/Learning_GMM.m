clear all
clc

filePathCropped = '../../Images/TrainingSet/CroppedBuoys/R_';


Samples = [];
for i=1:40 
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePathCropped, CroppedFileName);
    Image = imread(fullCroppedFileName);
   
%% Getting channels
RChannel = Image(:, :, 1);
GChannel = Image(:, :, 2);
BChannel = Image(:, :, 3);

[X Y] = size(RChannel);
pixelR = [];
pixelG = [];
pixelB = [];

for i = 1:X
    for j = 1:Y
        pixelR = [pixelR RChannel(i,j)];
        pixelG = [pixelG GChannel(i,j)];
        pixelB = [pixelB BChannel(i,j)];
    end
end
pixelR = pixelR';
pixelG = pixelG';
pixelB = pixelB';
samppix = [pixelR pixelG pixelB];
Samples = [Samples ; samppix];
end


%% Histograms for each channels
[RedY, x] = imhist(Samples(:,1));
stem(x, RedY,'r');
title('Red Buoy: red Channel')
 hold on
[GreenY, x] = imhist(Samples(:,2));
figure
stem(x,GreenY,'g')
title('Red Buoy: green Channel')
 hold on
[BlueY, x] = imhist(Samples(:,3));%2 GUASSIANS FOR BLUE CHANNEL
figure
stem(x,BlueY,'b')
title('Red Buoy: blue Channel')
 hold on

%Creating Gaussians  
GmmR = fitgmdist(double(Samples),6,'Regularize',.0001)
GmmMeanR = GmmR.mu;
GmmVarR = GmmR.Sigma;

Check = [200 150 213; 105 116 200];
y = pdf(GmmR,Check);


%Yellow buoy GMM learning
filePathCropped = '../../Images/TrainingSet/CroppedBuoys/Y_';
Samples = [];
for i=1:40 %for every cropped yellow buoy
  CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePathCropped, CroppedFileName);
   Image = imread(fullCroppedFileName);
   %Getting Channels
RChannel = Image(:, :, 1);
GChannel = Image(:, :, 2);
BChannel = Image(:, :, 3);


[X Y] = size(RChannel);%get dimensions of color channels
pixelR = [];
pixelG = [];
pixelB = [];
for i = 1:X
    for j = 1:Y
        pixelR = [pixelR RChannel(i,j)];
        pixelG = [pixelG GChannel(i,j)];
        pixelB = [pixelB BChannel(i,j)];
    end
end
pixelR = pixelR';%transpose to make 1 column
pixelG = pixelG';
pixelB = pixelB';
samppix = [pixelR pixelG pixelB];
Samples = [Samples ; samppix];
end

%Histograms for each channels
figure
[RedY, x] = imhist(Samples(:,1));
stem(x, RedY,'r');
title('Yellow Buoy: red Channel')
% hold On
[GreenY, x] = imhist(Samples(:,2));
figure
stem(x,GreenY,'g')
title('Yellow Buoy: green Channel')
% hold On
[BlueY, x] = imhist(Samples(:,3));
figure
stem(x,BlueY,'b')
title('Yellow Buoy: blue Channel')


%Creating Gaussians 
GmmY = fitgmdist(double(Samples),4,'Regularize',.0001)%Samples has 3 columns, so it's 3 dimensionsal, 5 gaussians of 3 dimensions
GmmMeanY = GmmY.mu;
GmmVarY = GmmY.Sigma;


%GREEN BUOY

filePathCropped = '../../Images/TrainingSet/CroppedBuoys/G_';
Samples = [];
for i=1:23%for every cropped buoy
   CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePathCropped, CroppedFileName);
   Image = imread(fullCroppedFileName);
   
   %Getting Channels
RChannel = Image(:, :, 1);
GChannel = Image(:, :, 2);
BChannel = Image(:, :, 3);

%Get arrays of every Channel value
[X Y] = size(RChannel);%get dimensions of color channels
pixelR = [];
pixelG = [];
pixelB = [];
for i = 1:X
    for j = 1:Y
        pixelR = [pixelR RChannel(i,j)];%add value to color matrix
        pixelG = [pixelG GChannel(i,j)];
        pixelB = [pixelB BChannel(i,j)];
    end
end
pixelR = pixelR';%transpose to make 1 column
pixelG = pixelG';
pixelB = pixelB';
samppix = [pixelR pixelG pixelB];
Samples = [Samples ; samppix];
end

%Histograms for each channels
figure
[RedY, x] = imhist(Samples(:,1));
stem(x, RedY,'r');
title('Green Buoy: red Channel')

[GreenY, x] = imhist(Samples(:,2));
figure
stem(x,GreenY,'g')
title('Green Buoy: green Channel')

[BlueY, x] = imhist(Samples(:,3));
figure
stem(x,BlueY,'b')
title('Green Buoy: blue Channel')

%Creating Gaussians
GmmG = fitgmdist(double(Samples),7  ,'Regularize',.0001)
GmmMeanG = GmmG.mu;
GmmVarG = GmmG.Sigma;

close all