clear all
clc

filePathCropped = '../../Images/TrainingSet/CroppedBuoys/R_';


Samples = [];
for i=1:40 
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePathCropped, CroppedFileName);
    Image = rgb2hsv(imread(fullCroppedFileName));
   
%% Getting channels
HChannel = Image(:, :, 1);
SChannel = Image(:, :, 2);
VChannel = Image(:, :, 3);

[X Y] = size(HChannel);
pixelH = [];
pixelS = [];
pixelV = [];

for i = 1:X
    for j = 1:Y
        pixelH = [pixelH HChannel(i,j)];
        pixelS = [pixelS SChannel(i,j)];
        pixelV = [pixelV VChannel(i,j)];
    end
end
pixelH = pixelH';
pixelS = pixelS';
pixelV = pixelV';
samppix = [pixelH pixelS pixelV];
Samples = [Samples ; samppix];
end


%% Histograms for each channels
[HY, x] = imhist(Samples(:,1));
stem(x, HY,'r');
title('Red Buoy: H Channel')
 hold on
[SY, x] = imhist(Samples(:,2));
figure
stem(x,SY,'g')
title('Red Buoy: S Channel')
 hold on
[VY, x] = imhist(Samples(:,3));%2 GUASSIANS FOR BLUE CHANNEL
figure
stem(x,VY,'b')
title('Red Buoy: V Channel')
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
   Image = rgb2hsv(imread(fullCroppedFileName));
   %Getting Channels
HChannel = Image(:, :, 1);
SChannel = Image(:, :, 2);
VChannel = Image(:, :, 3);


[X Y] = size(HChannel);%get dimensions of color channels
pixelH = [];
pixelS = [];
pixelV = [];
for i = 1:X
    for j = 1:Y
        pixelH = [pixelH HChannel(i,j)];
        pixelS = [pixelS SChannel(i,j)];
        pixelV = [pixelV VChannel(i,j)];
    end
end
pixelH = pixelH';%transpose to make 1 column
pixelS = pixelS';
pixelV = pixelV';
samppix = [pixelH pixelS pixelV];
Samples = [Samples ; samppix];
end

%Histograms for each channels
figure
[HY, x] = imhist(Samples(:,1));
stem(x, HY,'r');
title('Yellow Buoy: H Channel')
% hold On
[SY, x] = imhist(Samples(:,2));
figure
stem(x,SY,'g')
title('Yellow Buoy: S Channel')
% hold On
[VY, x] = imhist(Samples(:,3));
figure
stem(x,VY,'b')
title('Yellow Buoy: V Channel')


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
   Image = rgb2hsv(imread(fullCroppedFileName));
   
   %Getting Channels
HChannel = Image(:, :, 1);
SChannel = Image(:, :, 2);
VChannel = Image(:, :, 3);

%Get arrays of every Channel value
[X Y] = size(HChannel);%get dimensions of color channels
pixelH = [];
pixelS = [];
pixelV = [];
for i = 1:X
    for j = 1:Y
        pixelH = [pixelH HChannel(i,j)];%add value to color matrix
        pixelS = [pixelS SChannel(i,j)];
        pixelV = [pixelV VChannel(i,j)];
    end
end
pixelH = pixelH';%transpose to make 1 column
pixelS = pixelS';
pixelV = pixelV';
samppix = [pixelH pixelS pixelV];
Samples = [Samples ; samppix];
end

%Histograms for each channels
figure
[HY, x] = imhist(Samples(:,1));
stem(x, HY,'r');
title('Green Buoy: H Channel')

[SY, x] = imhist(Samples(:,2));
figure
stem(x,SY,'g')
title('Green Buoy: S Channel')

[VY, x] = imhist(Samples(:,3));
figure
stem(x,VY,'b')
title('Green Buoy: V Channel')

%Creating Gaussians
GmmG = fitgmdist(double(Samples),7  ,'Regularize',.0001)
GmmMeanG = GmmG.mu;
GmmVarG = GmmG.Sigma;

close all