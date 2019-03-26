%% For Green Buoy
filePath = '../../Images/TrainingSet/CroppedBuoys/G_';
bins = (0:1:255)';
RedCount = zeros(256,1);
GreenCount = zeros(256,1);
BlueCount = zeros(256,1);
OutputPath = sprintf('../../Output/Part0');

for i = 1 :23
CroppedFileName = sprintf('%03d.jpg',i);
fullCroppedFileName = strcat(filePath, CroppedFileName);

im = imread(fullCroppedFileName);
% Getting the channels 
RChannel = im(:,:,1);
GChannel = im(:,:,2);
BChannel = im(:,:,3);
RChannel = medfilt2(RChannel,[1 1]);
GChannel = medfilt2(GChannel,[1 1]);
BChannel = medfilt2(BChannel,[1 1]);
[rc, ~] = imhist(RChannel(RChannel > 0));
[gc, ~] = imhist(GChannel(GChannel > 0));
[bc, ~] = imhist(BChannel(BChannel > 0));

for n = 1 : 256
RedCount(n) = RedCount(n) + rc(n);
GreenCount(n) = GreenCount(n) + gc(n);
BlueCount(n) = BlueCount(n) + bc(n);
end
end
RedCount = RedCount ./ n;
GreenCount = GreenCount ./ n;
BlueCount = BlueCount ./ n;
figure
%% Plotting histogram for green buoy
title('Histogram for Green colured buoy')
subplot(3,1,1)
area(bins, RedCount, 'FaceColor', 'r')
xlim([0 255]) % limit on x axis
hold on
subplot(3,1,2)
area(bins, GreenCount, 'FaceColor', 'g')
xlim([0 255])
subplot(3,1,3)
area(bins, BlueCount, 'FaceColor', 'b')
xlim([0 255])
hold off
pause(0.1)
hgexport(gcf, fullfile(OutputPath, 'G_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');
%% For Red buoy
filePath = '../../Images/TrainingSet/CroppedBuoys/R_';
bins = (0:1:255)';
RedCount = zeros(256,1);
GreenCount = zeros(256,1);
BlueCount = zeros(256,1);
OutputPath = sprintf('../../Output/Part0');
for i = 1 : 40
CroppedFileName = sprintf('%03d.jpg',i);
fullCroppedFileName = strcat(filePath, CroppedFileName);
im = imread(fullCroppedFileName);
RChannel = im(:,:,1);
GChannel = im(:,:,2);
BChannel = im(:,:,3);
RChannel = medfilt2(RChannel,[2 2]);
GChannel = medfilt2(GChannel,[2 2]);
BChannel = medfilt2(BChannel,[2 2]);
[rc, ~] = imhist(RChannel(RChannel > 0));
[gc, ~] = imhist(GChannel(GChannel > 0));
[bc, ~] = imhist(BChannel(BChannel > 0));
for n = 1 : 256
RedCount(n) = RedCount(n) + rc(n);
GreenCount(n) = GreenCount(n) + gc(n);
BlueCount(n) = BlueCount(n) + bc(n);
end
end
RedCount = RedCount ./ 16;
GreenCount = GreenCount ./ 16;
BlueCount = BlueCount ./ 16;
figure
%% Plotting histogram for Red buoy
title('Histogram for Red colured buoy')
subplot(3,1,1)
area(bins, RedCount, 'FaceColor', 'r')
xlim([0 255])
hold on
subplot(3,1,2)
area(bins, GreenCount, 'FaceColor', 'g')
xlim([0 255])
subplot(3,1,3)
area(bins, BlueCount, 'FaceColor', 'b')
xlim([0 255])
pause(0.1)
hgexport(gcf, fullfile(OutputPath, 'R_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');

%% For Yellow buoy
filePath = '../../Images/TrainingSet/CroppedBuoys/Y_';
bins = (0:1:255)';
RedCount = zeros(256,1);
GreenCount = zeros(256,1);
BlueCount = zeros(256,1);
OutputPath = sprintf('../../Output/Part0');
for i = 1 :40
CroppedFileName = sprintf('%03d.jpg',i);
fullCroppedFileName = strcat(filePath, CroppedFileName);
im = imread(fullCroppedFileName);
RChannel = im(:,:,1);
GChannel = im(:,:,2);
BChannel = im(:,:,3);
RChannel = medfilt2(RChannel,[2 2]);
GChannel = medfilt2(GChannel,[2 2]);
BChannel = medfilt2(BChannel,[2 2]);
[rc, ~] = imhist(RChannel(RChannel > 0));
[gc, ~] = imhist(GChannel(GChannel > 0));
[bc, ~] = imhist(BChannel(BChannel > 0));
for n = 1 : 256
RedCount(n) = RedCount(n) + rc(n);
GreenCount(n) = GreenCount(n) + gc(n);
BlueCount(n) = BlueCount(n) + bc(n);
end
end
RedCount = RedCount ./ 16;
GreenCount = GreenCount ./ 16;
BlueCount = BlueCount ./ 16;
figure
%% Plotting Histogram for Yellow buoy
title('Histogram for Yellow colured buoy')
subplot(3,1,1)
area(bins, RedCount, 'FaceColor', 'r')
xlim([0 255])
hold on
subplot(3,1,2)
area(bins, GreenCount, 'FaceColor', 'g')
xlim([0 255])
subplot(3,1,3)
area(bins, BlueCount, 'FaceColor', 'b')
xlim([0 255])
pause(0.1)
hgexport(gcf, fullfile(OutputPath, 'Y_hist.jpg'), hgexport('factorystyle'), 'Format', 'jpeg');