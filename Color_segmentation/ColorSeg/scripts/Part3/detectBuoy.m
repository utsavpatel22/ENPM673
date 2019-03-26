clc
vid = VideoReader('../../Images/detectbuoy.avi');
binaryimagepath = '../../Output/Part3/BinaryImages/';
colorimagepath = '../../Output/Part3/Frames/';


for n = 1:180
Frame = read(vid,n);


%Getting Channels
[L W nf] = size(Frame);
RChannel = Frame(:, :, 1);
GChannel = Frame(:, :, 2);
BChannel = Frame(:, :, 3);


%Size of a color Channel
[s1 s2] = size(RChannel);

%Generating Probability Map
Red1 = reshape(RChannel,L*W,1);
Green1 = reshape(GChannel,L*W,1);
Blue1 = reshape(BChannel,L*W,1);
Pixels = [Red1 Green1 Blue1];
Pixels = double(Pixels);

%Probability Maps
RedMap = pdf(GmmR,Pixels);%Create probability for every pixel. But every pixel is not aligned in matrix they are in a list.
RedMax = max(RedMap(:));

YellowMap = pdf(GmmY,Pixels);
YellowMax = max(YellowMap(:));

GreenMap = pdf(GmmG,Pixels);
GreenMax = max(GreenMap(:));

%Reshaping the Map
RedMap = reshape(RedMap,L,W);
YellowMap = reshape(YellowMap,L,W);
GreenMap = reshape(GreenMap,L,W);

%Changing the values of probablity map to 0-255
inprange = RedMax - 0;
inpYellow = YellowMax;
inpGreen = GreenMax;
outrange =  255 - 0; 

RRR = RedMap*(outrange/(inprange));
YYY = YellowMap*(outrange/(inpYellow));
GGG = GreenMap*(outrange/(inpGreen));

%THRESHOLDING
Yim = YYY;
%if prob under 255 then set pixel value to 0
YellowIndex = (YYY < 255);
Yim(YellowIndex) = 0;

%Red buoy thresholding
Rim = RRR;
indexR = (RRR < 230);
Rim(indexR) = 0;

% Green buoy thresholding
Gim = GGG;
indexG = (GGG < 1);
Gim(indexG) = 0;
Gim2 = bwareaopen(Gim,60);

str1 = strel('disk', 5);
str2 = strel('disk', 2);
str3 = strel('disk',1);
FinRed = imdilate(Rim,str1);
FinYellow = imdilate(Yim,str1);
FinGreen = imdilate(Gim2,str1);


%Getting the pixels after thresholding
FinRed = im2bw(FinRed);

RedRegion = regionprops(FinRed,'Centroid','Area');


if (length(RedRegion) > 0)
redx = RedRegion(1).Centroid(1);
redy = RedRegion(1).Centroid(2);
end

FinYellow = im2bw(FinYellow);

YellowRegion = regionprops(FinYellow,'Centroid');
if(length(YellowRegion) > 0)
yellowx = YellowRegion(1).Centroid(1);
yellowy = YellowRegion(1).Centroid(2);
end

FinGreen = im2bw(FinGreen);
GreenRegion = regionprops(FinGreen,'Centroid','Area');
if(length(GreenRegion) > 0)
for s = 1:length(GreenRegion)
greenx = GreenRegion(s).Centroid(1);
greeny = GreenRegion(s).Centroid(2);
if (length(YellowRegion)>0 && ((((yellowy-greeny)^2+(yellowx-greenx)^2)^.5 <70 || GreenRegion(s).Area > 5300)))
    length(YellowRegion);
    ((yellowy-greeny)^2+(yellowx-greenx)^2)^.5;
    greeny = yellowy;
    greenx = yellowx;
    
    break
end
end    

end

Redonly = RRR;
for i = 1:L
    for j = 1:W
        if (RRR(i,j)>.01)
            Redonly(i,j) = 255;
        end
    end
end

Redonly  = im2bw(Redonly);
filename = sprintf('binaryR_%d.jpg', n);
fullfilename = strcat(binaryimagepath, filename);
imwrite(Redonly, fullfilename,'jpg');

redbound = 70;
if (length(RedRegion) >0)
for aa = 1:L
    for bb = 1:W
        if (aa < redy-redbound|| aa > redy+redbound || bb < redx-redbound || bb > redx+redbound)
            Redonly(aa,bb) = 0;
        end
    end
end
end

Redonly = imfill(Redonly,'holes');
imshow(Redonly)
%For Yellow buoy
Yellowonly = YYY;
for i = 1:L
    for j = 1:W
        if (YYY(i,j)>.01)
            Yellowonly(i,j) = 255;
        end
    end
end

if (length(YellowRegion) > 0)
for aa = 1:L
    for bb = 1:W
        if (aa < yellowy-40 || aa > yellowy+40 || bb < yellowx-40 || bb > yellowx+40)%If anywhere in image besides close to the pixel from buoy
            Yellowonly(aa,bb) = 0;
        end
    end
end
end
Yellowonly = im2bw(Yellowonly);
filename = sprintf('binaryY_%d.jpg', n);
fullfilename = strcat(binaryimagepath, filename);
imwrite(Yellowonly, fullfilename,'jpg');

Yellowonly = imfill(Yellowonly,'holes');

imshow(Yellowonly)

Greenonly = GGG;

for i = 1:L
    for j = 1:W
        if (GGG(i,j)>1)
            Greenonly(i,j) = 255;
        else
            Greenonly(i,j) = 0;
        end
    end
end
if (length(GreenRegion) > 0)
for aa = 1:L
    for bb = 1:W
        if (aa < greeny-15 || aa > greeny+15 || bb < greenx-15 || bb > greenx+15)%If anywhere in image besides close to the pixel from buoy
            Greenonly(aa,bb) = 0;
        end
    end
end
end
Greenonly = im2bw(Greenonly);
filename = sprintf('binaryG_%d.jpg', n);
fullfilename = strcat(binaryimagepath, filename);
imwrite(Greenonly, fullfilename,'jpg');


Greenonly = imfill(Greenonly,'holes');
Greenonly = bwareaopen(Greenonly,10);
Greenonly = imdilate(Greenonly,str3);

imshow(Greenonly)

for i = 1:L
    for j = 1:W
        if(i < redy-40)
            FinGreen(i,j) = 0;
        end
    end
end

imshow(Frame)
hold on

%Draw Countours for colored buoys
Bound = bwboundaries(Redonly);
for  k =1:length(Bound)
boundaries = Bound{k};
if (((yellowy-redy)^2+(yellowx-redx)^2)^.5 > 70 && abs(yellowx-redx)>70)
plot(boundaries(:,2), boundaries(:,1), 'r', 'LineWidth', 3)
end 
end

Bound = bwboundaries(Yellowonly);
for  k =1:length(Bound)
boundaries = Bound{k};
plot(boundaries(:,2), boundaries(:,1), 'y', 'LineWidth', 3)
end 

Bound = bwboundaries(FinGreen);
Greencir = regionprops(FinGreen,'Centroid','Area');
if (length(Greencir) > 0)
Greengreat = 0;
for i = 1:length(Greencir)
    if(abs(Greencir(i).Centroid(1) - yellowx) > 70&&abs(Greencir(i).Centroid(2)-yellowy < 20)...
            && abs(Greencir(i).Centroid(1)-redx > 40) )
        if (Greencir(i).Area > Greengreat)
        Greengreat = Greencir(i).Area;
        Greenini = i;
        Greencx = Greencir(i).Centroid(1);
        Greency = Greencir(i).Centroid(2);
        end
        scatter(Greencir(Greenini).Centroid(1),Greencir(Greenini).Centroid(2),400,'g','LineWidth',3)
    end
end
end

title(n)
f = getframe(gca);
im = frame2im(f);
filenamecolor = sprintf('out_%d.jpg', n);
fullfilenamecolor = strcat(colorimagepath, filenamecolor);
imwrite(im, fullfilenamecolor,'jpg');

set(gcf,'visible','off')
cla
end
