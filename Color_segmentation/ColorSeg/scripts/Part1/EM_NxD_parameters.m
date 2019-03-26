clear all; 
clc;


% Number of gaussians and dimensions 
N = 3;
D = 1; 
% Data array
Data = []; 
%% Getting random data

Meanarray = zeros(N,D);
Variancearray = zeros(N,D);
for i = 1:N
for j = 1:D
MeanRand = randi(20);
Meanarray(i,j) = MeanRand; 
Varrand = randi(10);
Variancearray(i,j) = Varrand; 
end
end 

Data = [];
Data2 = [];
for p = 1:length(Meanarray)
for q = 1:D
sample = mvnrnd(Meanarray(p,q),Variancearray(p,q),100); 
Data = [Data sample]; 
end
Data2 = [Data2 ; Data];
Data = [];  
end 

Gmm = fitgmdist(Data2,N); % Fit gaussians to the data
Meanarray; 
FoundMean = Gmm.mu 
FoundCov = Gmm.Sigma 