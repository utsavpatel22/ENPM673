clear all; 
clc;
warning off;
Output = sprintf('../../Output/Part1');
%% Generate three 1D Gaussians from the the follwoing means and variances
mean1 = 0;  
mean2 = 6;
mean3 = 10;
variance1 = .5;
variance2 = 2;
variance3 = 4;

% Getting sample data 
Data1 = mvnrnd(mean1,variance1,1000);
Data2 = mvnrnd(mean2,variance2,1000);
Data3 = mvnrnd(mean3,variance3,1000);

%% Plotting the PDF
x = [-10:.01:20];
nor1 = normpdf(x,mean1,(variance1)^.5);
plot(x,nor1,'c','LineWidth',2)
nor2 = normpdf(x,mean2,(variance2)^.5);
hold on
plot(x,nor2,'m','LineWidth',2)
nor3 = normpdf(x,mean3,(variance3)^.5);
plot(x,nor3,'g','LineWidth',2)
title('Recovered mean and variance for 3 Gaussians')
ylim([0 1])
hgexport(gcf, fullfile(Output, 'Recovered mean and variance for 3 Gaussians.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%% recover the model parameters for 3 Gaussians
D = [Data1 ;Data2 ;Data3];

GMMMod = fitgmdist(D,3)
FoundMean = GMMMod.mu;
FoundVariance = [GMMMod.Sigma(1) GMMMod.Sigma(2) GMMMod.Sigma(3)];
GMM1 = normpdf(x,FoundMean(1),FoundVariance(1)^.5);
GMM2 = normpdf(x,FoundMean(2),FoundVariance(2)^.5);
GMM3 = normpdf(x,FoundMean(3),FoundVariance(3)^.5);
figure
plot(x,GMM1,'r','LineWidth',3)
hold on
plot(x,GMM2,'b','LineWidth',3)
plot(x,GMM3,'g','LineWidth',3)
title('Data samples from 3 1-D Gaussians')
ylim([0 1])
hgexport(gcf, fullfile(Output, 'EM1D3N.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%% recover the model parameters for 4 Gaussians 

FitfourGaus = fitgmdist(D,4);
Meanfitfour = FitfourGaus.mu;
Varfitfour = [FitfourGaus.Sigma(1) FitfourGaus.Sigma(2) FitfourGaus.Sigma(3) FitfourGaus.Sigma(4)];
GMMfit1 = normpdf(x,Meanfitfour(1),Varfitfour(1)^.5);
GMMfit2 = normpdf(x,Meanfitfour(2),Varfitfour(2)^.5);
GMMfit3 = normpdf(x,Meanfitfour(3),Varfitfour(3)^.5);
GMMfit4 = normpdf(x,Meanfitfour(4),Varfitfour(4)^.5);
figure
plot(x,GMMfit1,'r','LineWidth',3)
hold on
plot(x,GMMfit2,'b','LineWidth',3)
plot(x,GMMfit3,'g','LineWidth',3)
plot(x,GMMfit4,'y','LineWIdth',3)
title('Fitting 4 Gaussians to the data from 3')
ylim([0 1])
hgexport(gcf, fullfile(Output, 'EM1D4N.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');