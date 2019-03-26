clear all
clc
filePath = 'E:\Sem 1\ENPM 673\project3\Final\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\G_';
Samples = [];
OutputPath = sprintf('../../Output/Part2');

for i=1:23
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePath, CroppedFileName);

   Frame = imread( fullCroppedFileName);
   
RChannel = Frame(:, :, 1);
GChannel = Frame(:, :, 2);
BChannel = Frame(:, :, 3);

[X Y] = size(GChannel);%dimensions of the color channels
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
pixelR = pixelR'; %transpose to make 1 column
pixelG = pixelG';
pixelB = pixelB';

Pix = [pixelR pixelG pixelB];
Samples = [Samples; Pix];
end


Data = []; %Array holding all randomly selected samples
[sz s] = size(Samples);
for i = 1:100000
X = randi([1 sz]);
ch = Samples(X,:);
Data = [Data ;ch];
end
Red = Data(:,1);
Green = Data(:,2);
Blue = Data(:,3);
Red = double(Red);
Green = double(Green);
Blue = double(Blue);
%Mean of Red,Green, Blue

meanRed = mean(Data(:,1));
meanGreen = mean(Data(:,2));
meanBlue = mean(Data(:,3));
mean = [meanRed meanGreen meanBlue]

%Standard dev of Red,Green,Blue

stdRed = std(double(Data(:,1)));
stdGreen = std(double(Data(:,2)));
stdBlue = std(double(Data(:,3)));


%Covariance Red green
Covarianceg = cov(Red,Green);
covarianceRG = Covarianceg(1,2);
covarianceGR = Covarianceg(2,1);
%Covariance red blue
Covarianceb = cov(Red,Blue);
covarianceRB = Covarianceb(1,2);
covarianceBR = Covarianceb(2,1);
%Covariance green blue
Covariancegb = cov(Green,Blue);
covarianceGB = Covariancegb(1,2);
covarianceBG = Covariancegb(2,1);

covariancemat = [stdRed^2  covarianceRG  covarianceRB;
         covarianceGR stdGreen^2   covarianceGB;
         covarianceBR covarianceBG  stdBlue^2;]
       
   



%Plot gaussian for green colored buoy
x = [0:5:300];
norm = normpdf(x,meanRed,stdRed);
figure
title('Histograms for Green coloured buoy')
plot(x,norm,'r','LineWidth',3)
hold on
norm1 = normpdf(x,meanGreen,stdGreen);
plot(x,norm1,'g','LineWidth',3)

norm2 = normpdf(x,meanBlue,stdBlue);
plot(x,norm2,'b','LineWidth',3)
hgexport(gcf, fullfile(OutputPath, 'EM_Green.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');

clearvars 
%% Plotting histograms for red coloured buoys
filePath = 'E:\Sem 1\ENPM 673\project3\Final\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\R_';
OutputPath = sprintf('../../Output/Part2');
Samples = [];

for i=1:40
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePath, CroppedFileName);

   Frame = imread( fullCroppedFileName);
   
RChannel = Frame(:, :, 1);
GChannel = Frame(:, :, 2);
BChannel = Frame(:, :, 3);

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

Pix = [pixelR pixelG pixelB];
Samples = [Samples; Pix];
end



Data = [];
[sz s] = size(Samples);
for i = 1:100000
X = randi([1 sz]);
ch = Samples(X,:);
Data = [Data ;ch];
end
Red = Data(:,1);
Green = Data(:,2);
Blue = Data(:,3);
Red = double(Red);
Green = double(Green);
Blue = double(Blue);
%Mean for Red,Green, Blue
meanRed = mean(Data(:,1));
meanGreen = mean(Data(:,2));
meanBlue = mean(Data(:,3));
mean = [meanRed meanGreen meanBlue]

%Standard dev for Red,Green,Blue
stdRed = std(double(Data(:,1)));
stdGreen = std(double(Data(:,2)));
stdBlue = std(double(Data(:,3)));

 
%Covariance Red green
Covarianceg = cov(Red,Green);
covarianceRG = Covarianceg(1,2);
covarianceGR = Covarianceg(2,1);
%Covariance red blue
Covarianceb = cov(Red,Blue);
covarianceRB = Covarianceb(1,2);
covarianceBR = Covarianceb(2,1);
%Covariance green blue
Covariancegb = cov(Green,Blue);
covarianceGB = Covariancegb(1,2);
covarianceBG = Covariancegb(2,1);

covariancemat = [stdRed^2  covarianceRG  covarianceRB;
         covarianceGR stdGreen^2   covarianceGB;
         covarianceBR covarianceBG  stdBlue^2;]
       
   





%Plotting Gaussians for Red colored buoy
x = [0:5:300];
norm = normpdf(x,meanRed,stdRed);
figure
title('Histograms for red colored buoy')

plot(x,norm,'r','LineWidth',3)
hold on
norm1 = normpdf(x,meanGreen,stdGreen);
plot(x,norm1,'g','LineWidth',3)

norm2 = normpdf(x,meanBlue,stdBlue);
plot(x,norm2,'b','LineWidth',3)
hgexport(gcf, fullfile(OutputPath, 'EM_Red.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%% Plotting histograms for Yellow coloured buoys
clearvars 
filePath = 'E:\Sem 1\ENPM 673\project3\Final\P3_Submission\ColorSeg\Images\TrainingSet\CroppedBuoys\Y_';
OutputPath = sprintf('../../Output/Part2');
Samples = [];

for i=1:40
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePath, CroppedFileName);

   Frame = imread( fullCroppedFileName);
   
RChannel = Frame(:, :, 1);
GChannel = Frame(:, :, 2);
BChannel = Frame(:, :, 3);

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

Pix = [pixelR pixelG pixelB];
Samples = [Samples; Pix];
end



Data = [];%Array holding all randomly selected samples
[sz s] = size(Samples);
for i = 1:100000
X = randi([1 sz]);
ch = Samples(X,:);
Data = [Data ;ch];
end
Red = Data(:,1);
Green = Data(:,2);
Blue = Data(:,3);
Red = double(Red);
Green = double(Green);
Blue = double(Blue);
%Mean for Red,Green, Blue
meanRed = mean(Data(:,1));
meanGreen = mean(Data(:,2));
meanBlue = mean(Data(:,3));
mean = [meanRed meanGreen meanBlue]

%Standard deviation for Red,Green,Blue
stdRed = std(double(Data(:,1)));
stdGreen = std(double(Data(:,2)));
stdBlue = std(double(Data(:,3)));


%Covariance for Red green
Covarianceg = cov(Red,Green);
covarianceRG = Covarianceg(1,2);
covarianceGR = Covarianceg(2,1);
%Covariance for red blue
Covarianceb = cov(Red,Blue);
covarianceRB = Covarianceb(1,2);
covarianceBR = Covarianceb(2,1);
%Covariance for green blue
Covariancegb = cov(Green,Blue);
covarianceGB = Covariancegb(1,2);
covarianceBG = Covariancegb(2,1);

covariancemat = [stdRed^2  covarianceRG  covarianceRB;
         covarianceGR stdGreen^2   covarianceGB;
         covarianceBR covarianceBG  stdBlue^2;]
       
   

%Plotting Gaussians for Yellow colored buoy
x = [0:5:300];
norm = normpdf(x,meanRed,stdRed);
figure
title('Histograms for Yellow colored buoy')

plot(x,norm,'r','LineWidth',3)
hold on
norm1 = normpdf(x,meanGreen,stdGreen);
plot(x,norm1,'g','LineWidth',3)

norm2 = normpdf(x,meanBlue,stdBlue);
plot(x,norm2,'b','LineWidth',3)
hgexport(gcf, fullfile(OutputPath, 'EM_Yellow.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');


