clear all
clc


Vid = VideoReader('../../Images/detectbuoy.avi');
video = VideoWriter('../../Output/Part0/Part0_output');
video.FrameRate = 15;
open(video);
imagepath = '../../Output/Part0/seg_img/';

for n = 1:180 
Frames = read(Vid,n);
[L W e] = size(Frames);

%Getting the color channels
RChannel = Frames(:, :, 1);
GChannel = Frames(:, :, 2);
BChannel = Frames(:, :, 3);
YChannel = (double(RChannel)+double(GChannel))/2;

% MEAN AND STND DEV
%Putting the values of mean and std got from runnig estimateparam.m script
MeanR = 241.1165;
StdR = 12.6983;

%for yellow buoy
MeanY = 231.6197;
StdY = 11.5833;

%for green buoy
MeanG = 218.1628;
StdG = 26.5445;


%Calculating the probability that a given pixel is a pixel on the red buoy
ProbRed = normpdf(double(RChannel),MeanR,StdR);
ProbmaxRed = max(ProbRed(:));%Finding the max probability

% Calculating the probability that a given pixel is a pixel on the yellow buoy
ProbYelllow = normpdf(double(YChannel),MeanY,StdY);
ProbmaxYellow = max(ProbYelllow(:));

%Calculating the probability that a given pixel is a pixel on the green buoy
GChannel = (double(GChannel)+double(BChannel))/2;
ProbGreen = normpdf(double(GChannel),MeanG,StdG);
ProbmaxGreen = max(ProbGreen(:));

%% Prbability matrix

irange = ProbmaxRed - 0;
Inyellow = ProbmaxYellow;
Ingreen = ProbmaxGreen;
orange =  255 - 0; 

%% mapped probability matrices for each color (max of 255, min of 0)
RedMappedmat = ProbRed * (orange/(irange));
YellowMappedmat = ProbYelllow * (orange/Inyellow);
GreenMappedmat = ProbGreen * (orange/Ingreen);


%% Getting red buoy
thresRed = 240; %thresold value for pixel to be detected as a pixel on a red buoy
RedBin = im2bw(Frames);
for i =1:480 
    for o = 1:640
        if (RedMappedmat(i,o) > thresRed && YellowMappedmat(i,o)<50)
            RedBin(i,o) = 1;
        else
            RedBin(i,o) = 0;
        end
    end
end
RedBin2 = bwareaopen(RedBin,6);
stl1 = strel('disk', 10);
RedBin3 = imdilate(RedBin2,stl1);

%% Getting yellow buoy
thresYellow = 240;
YellowBin = im2bw(Frames);
for i =1:480
    for o = 1:640
        if (YellowMappedmat(i,o) > thresYellow  && RedMappedmat(i,o)< 199 && RedMappedmat(i,o) > 150 && GreenMappedmat(i,o) < 90)
            YellowBin(i,o) = 1;
        else
            YellowBin(i,o) = 0;
        end
    end
end
YellowBin2 = bwareaopen(YellowBin,1);
YellowBin3 = imdilate(YellowBin2,stl1);

%% Getting green buoy
thresGreen = 250;
GreenBin   = im2bw(Frames);
for i =1:480
    for o = 1:640
        if (GreenMappedmat(i,o) > thresGreen && RedMappedmat(i,o)<50 && YellowMappedmat(i,o) > 100)
            GreenBin(i,o) = 1;
        else
            GreenBin(i,o) = 0;
        end
    end
end 
GreenBin2 = bwareaopen(GreenBin,4);
GreenBin3 = imdilate(GreenBin2,stl1);
imshow(GreenBin);


%Getting conutour
Redch = 0;
Yellowch = 0;
Greench =0;

%drawing line on the buoy
Blobred = regionprops(RedBin3,'Centroid');
if (length(Blobred) > 0)
% finding the center of the countour
redx = Blobred(1).Centroid(1);
redy = Blobred(1).Centroid(2);

minx = redx - 75;
maxx = redx + 75;
miny = redy - 75;
maxy = redy + 75;
RedCy = RedMappedmat;
for i = 1:L
    for j = 1:W
        if (j<minx || j>maxx || i<miny || i>maxy)
            RedCy(i,j) = 0;
        end
    end
end
Redch = 1;
end

%getting Yellow buoy countour
BlobYellow = regionprops(YellowBin3,'Centroid');
if (length(BlobYellow) > 0)
yellowx = BlobYellow(1).Centroid(1);
yellowy = BlobYellow(1).Centroid(2);

minx = yellowx - 75;
maxx = yellowx + 75;
miny = yellowy - 75;
maxy = yellowy + 75;
YellowCy = YellowMappedmat;
for i = 1:L
    for j = 1:W
        if (j<minx || j>maxx || i<miny || i>maxy)
            YellowCy(i,j) = 0;
        end
    end
end
Yellowch = 1;
end
%getting Green buoy countour

BlobGreen = regionprops(GreenBin2,'Centroid','Area');
if (length(BlobGreen) > 0)

for s = 1:length(BlobGreen)
greenx = BlobGreen(s).Centroid(1);
greeny = BlobGreen(s).Centroid(2);
if (Yellowch == 1 && (((yellowy-greeny)^2+(yellowx-greenx)^2)^.5 <70 || BlobGreen(s).Area > 100))%If we have info for y, and we see green data near yellow, or huuggeee green data
    greeny = yellowy;
    greenx = yellowx;
    break
end
end
end

imshow(Frames)
hold on

%% Plotting countours

%Plot red countour

if(Redch == 1)
RedCy = im2bw(RedCy);
B = bwboundaries(RedCy);
for  k =1:length(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 3)
end 
end

%ploting yellow countour
if(Yellowch == 1)
YellowCy = im2bw(YellowCy);
B = bwboundaries(YellowCy);
for  k =1:length(B)
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 3)
end 
end

%Plotting green countour
Gcen = regionprops(GreenBin3,'Centroid');
if (length(Gcen) > 0)
for i = 1:length(Gcen)
 if (abs(Gcen(i).Centroid(1)-yellowx)> 70 && abs(Gcen(i).Centroid(2)-yellowy) < 70)
greenx = Gcen(i).Centroid(1);
greeny = Gcen(i).Centroid(2);
scatter(greenx,greeny,500,'g','LineWidth',3)
end
end
end


title(n)
f = getframe(gca);
filename = sprintf('seg_%d.jpg', n);
fullfilename = strcat(imagepath, filename);
im = frame2im(f);
imwrite(im, fullfilename,'jpg');
writeVideo(video,im) 
cla
end
close(video);


