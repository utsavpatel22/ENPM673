clearvars
clc
% Read the video and number of frames are counted 
video = VideoReader('C:\Users\eruts\OneDrive\Desktop\utsav\upatel22_project1\P2_Submission\LaneDetection\Input\project_video.mp4');

compiledvideo = VideoWriter('project','MPEG-4');
compiledvideo.FrameRate = 25;
open(compiledvideo);

% for loop is used to read each frame of the video

for i = 1:650;  % 1-650 frames are sufficiant for 25sec video and left and right turns are included in it.
    im = read(video,i);
    
    %% denoising the frames
    imfil = medfilt3(im);
    
    %% Converting the denoised frames to grayscale frames
    
    img = rgb2gray(imfil);
    
    %% converting grayscale frames to binary frames
    
    imbw = im2bw(img,.48);
    
    %% detecting edges through canny method
    
    imbwe = edge(imbw,'Canny');
    
    %% Masking the unwanted portion of the frames, so the lines can be easily detected 
    x = [215 555 715 1280];
    y = [720 455 455 720];
    
    trapedge = y(2)+ 15 ; %trapedge defines the y coordinate of the end point of the line
    
    temp = poly2mask(x,y, 720, 1280);
    
    masked = immultiply(temp,imbwe);
    
    %% Performing Hough transform on the frames
    [H,T,R] = hough(masked,'RhoResolution',0.5,'ThetaResolution',0.5);
    p = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    lines = houghlines(masked,T,R,p,'FillGap',5,'MinLength',15);
    imshow(masked)
    hold on;
    for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];

    end
   slope_thresh = 0.3;
    j = 1;
    for k = 1:length(lines)
        ini = lines(k).point1;
        fin = lines(k).point2;
        if fin(1) - ini(1) == 0
           slope = 999; 
        else
           slope = (fin(2) - ini(2))/(fin(1) - ini(1));
        end
        if abs(slope) > slope_thresh
            slopes(j) = slope;
            slopelines(j) = lines(k);
            j = j + 1;
        end
    end
    
    %% Lines are divided into left lanes and right lanes according to their slopes and position with respect to the centerline
    img_size = size(img);
    center = img_size(2)/2;
    q = 1; j = 1; rflag = 0; lflag = 0;
    for k = 1:length(slopelines)
        ini = slopelines(k).point1;
        fin = slopelines(k).point2;
        if slopes(k) > 0 && fin(1) > center && ini(1) > center
            right_lane(q) = slopelines(k);
            rflag = 1;
            q = q + 1;
        elseif slopes(k) < 0 && fin(1) < center && ini(1) < center
            left_lane(j) = slopelines(k);
            lflag = 1;
            j = j + 1;
        else
            rflag = 0;
            lflag = 0;
        end
    end
    
    %% Extrapolating the lines 
     if (rflag == 0 || lflag == 0)
        continue
     end
     w = 1;
    if rflag == 1
        for k = 1:length(right_lane)
            ini = right_lane(k).point1;
            fin = right_lane(k).point2;

            rx(w) = ini(1);
            ry(w) = ini(2);
            w = w + 1;

            rx(w) = fin(1);
            ry(w) = fin(2);
            w = w + 1;
        end
        constant_right = 0; slope_right = 0;
        if length(rx) > 0
            
            pol = polyfit(rx, ry, 1);
            slope_right = pol(1);
            constant_right = pol(2);
        else
            slope_right = 1;
            constant_right = 1;
        end
    end
    

    y = 1; constant_left = 0; slope_left=0;
    if lflag == 1
        for k = 1:length(left_lane)
            ini = left_lane(k).point1;
            fin = left_lane(k).point2;

            lx(y) = ini(1);
            ly(y) = ini(2);
            y = y + 1;

            lx(y) = fin(1);
            ly(y) = fin(2);
            y = y + 1;
        end
        if length(lx) > 0
            pol = polyfit(lx, ly, 1);
            slope_left = pol(1);
            constant_left = pol(2);
        else
            slope_left = 1;
            constant_left = 1;
        end
    end
    iniy = img_size(1);
    finy = trapedge;
    % y = m*x + b from the initial points end poins are found with the help of slope(m)
    % and constant(b) of the line.
    rinix = (iniy - constant_right) / slope_right;
    rfinx = (finy - constant_right) / slope_right;
    
    linix = (iniy - constant_left) / slope_left;
    lfinx = (finy - constant_left) / slope_left;
    
    %% Mark the trapazoid with a transperent color
     p1 = [linix, iniy];
    p2 = [lfinx, finy];
    p3 = [rfinx, finy];
    p4 = [rinix, iniy];
    ptx = [p1(1) p2(1) p3(1) p4(1)];
    pty = [p1(2) p2(2) p3(2) p4(2)];
    BW = poly2mask(ptx, pty, 720, 1280);
    clr = [0 255 255];    % Color for the detected area        
    a = 0.3;                   
    z = false(size(BW));
    mask = cat(3,BW,z,z); imfil(mask) = a*clr(1) + (1-a)*imfil(mask);
    mask = cat(3,z,BW,z); imfil(mask) = a*clr(2) + (1-a)*imfil(mask);
    mask = cat(3,z,z,BW); imfil(mask) = a*clr(3) + (1-a)*imfil(mask);
    imshow(imfil)
    hold on
    
    %% Now ploting the lines on the image
    imshow(imfil)
    hold on
    plot([linix, lfinx],[iniy, finy],'LineWidth',4,'Color','red');
    plot([rinix, rfinx],[iniy, finy],'LineWidth',4,'Color','red');

    % According to the slope of the left line, left or right turn is
    % decided. The left line is the most stable line so its slope is used
    % in the program
if  slope_left >-.67
    textstring = 'Right';
    t = text(550,600,textstring,'Color','red','FontSize',35);

elseif slope_left < -.87
    textstring = 'Left';
    t = text(550,600,textstring,'Color','red','FontSize',35);
    
end 


    
   frame = getframe(gca);
    writeVideo(compiledvideo,frame);
    
    pause(.0010);
end

close(compiledvideo);