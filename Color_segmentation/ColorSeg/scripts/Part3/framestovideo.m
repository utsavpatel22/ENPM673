NewVid = VideoWriter('../../Output/Part3/Video/Part3_Output');
NewVid.FrameRate = 15;
open(NewVid);
colorimagepath = '../../Output/Part3/Frames/';

for i = 1:180
    filenamecolor = sprintf('out_%d.jpg', i);
    fullfilenamecolor = strcat(colorimagepath, filenamecolor);
    Image = imread(fullfilenamecolor);
    
    writeVideo(NewVid,Image);
end
close(NewVid);
