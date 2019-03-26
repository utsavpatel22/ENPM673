clear all
clc
filePath = '../../Images/TrainingSet/CroppedBuoys/G_';
OutputPath = sprintf('../../Output/Part0');

GreenSamples = [];
for i=1:23
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePath, CroppedFileName);

Image = imread(fullCroppedFileName);
%% Finding various color channels   
RChannel = Image(:, :, 1);
GChannel = Image(:, :, 2);
BChannel = Image(:, :, 3);
YChannel = (double(RChannel)+double(GChannel))/2;

[X Y] = size(GChannel);%Finding dimensions of the color channels
redPixels = [];
greenPixels = [];
bluePixels = [];
yellowPixels = [];
for p = 1:X
for q = 1:Y
greenPixels = [greenPixels GChannel(p,q)];
end
end
redPixels = redPixels';
greenPixels = greenPixels';
bluePixels = bluePixels';
yellowPixels = yellowPixels';

GreenSamples = [GreenSamples ; greenPixels];
end

%% Finding gaussian selected sample from values in the Green Channel


SampleData = []; 
[sz s] = size(GreenSamples);
for i = 1:100000
X = randi([1 sz]); %Getting random element numbers
chosen = GreenSamples(X); 
SampleData = [SampleData chosen]; 
end
SampleData = SampleData';

%finding mean and standard daviation of the randomly selected data
MeanG = mean(SampleData)
StdG = std(double(SampleData))
mu = MeanG;                                
sigma = StdG;                          

% Plotting the curve
x = (-5 * sigma:0.01:5 * sigma) + mu; 
y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));
plot(x, y,'g')
hold on;

%% For yellow Buoys

filePath = '../../Images/TrainingSet/CroppedBuoys/Y_';
YellowSamples = [];
for i=1:40
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePath, CroppedFileName);

Image = imread(fullCroppedFileName);
%% Finding various color channels  
RChannel = Image(:, :, 1);
GChannel = Image(:, :, 2);
BChannel = Image(:, :, 3);
YChannel = (double(RChannel)+double(GChannel))/2;

[X Y] = size(YChannel);
redPixels = [];
greenPixels = [];
bluePixels = [];
yellowPixels = [];
for i = 1:X
for j = 1:Y
yellowPixels = [yellowPixels YChannel(i,j)];
end
end
redPixels = redPixels';
greenPixels = greenPixels';
bluePixels = bluePixels';
yellowPixels = yellowPixels';
YellowSamples = [YellowSamples ; yellowPixels];
end
%% Finding gaussian from randomly selected sample from values in the Yellow Channel
SampleData = [];
[sz s] = size(YellowSamples);
for i = 1:100000
X = randi([1 sz]);
chosen = YellowSamples(X);
SampleData = [SampleData chosen];
end
SampleData = SampleData';
%finding mean and standard daviation of the randomly selected data
MeanY = mean(SampleData)
StdY = std(double(SampleData))
mu = MeanY;                                
sigma = StdY;                           

% Plotting the curve

x = (-5 * sigma:0.01:5 * sigma) + mu;  
y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));
plot(x, y,'y')
hold on;



filePath = '../../Images/TrainingSet/CroppedBuoys/R_';
RedSamples = [];
for i=1:40
    CroppedFileName = sprintf('%03d.jpg',i);
    fullCroppedFileName = strcat(filePath, CroppedFileName);

Image = imread(fullCroppedFileName);
%% Finding various color channels  
RChannel = Image(:, :, 1);
GChannel = Image(:, :, 2);
BChannel = Image(:, :, 3);

[X Y] = size(RChannel);
redPixels = [];
greenPixels = [];
bluePixels = [];
for i = 1:X
    for j = 1:Y
        redPixels = [redPixels RChannel(i,j)];
        greenPixels = [greenPixels GChannel(i,j)];
        bluePixels = [bluePixels BChannel(i,j)];
    end
end
redPixels = redPixels';
greenPixels = greenPixels';
bluePixels = bluePixels';

RedSamples = [RedSamples ; redPixels];
end

%% Finding gaussian from randomly selected sample from values in the Red Channel


SampleData = [];
[sz s] = size(RedSamples);
for i = 1:100000
X = randi([1 sz]);
chosen = RedSamples(X);
SampleData = [SampleData chosen];
end
SampleData = SampleData';

%finding mean and standard daviation of the randomly selected data


MeanR = mean(SampleData)
StdR = std(double(SampleData))
mu = MeanR;                               
sigma = StdR;                            

%Plotting the curve
x = (-5 * sigma:0.01:5 * sigma) + mu;  
y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));
plot(x, y,'r')
hold on;
hgexport(gcf, fullfile(OutputPath, 'gaussian1D.jpg'), hgexport('factorystyle'), 'Format', 'jpeg')

