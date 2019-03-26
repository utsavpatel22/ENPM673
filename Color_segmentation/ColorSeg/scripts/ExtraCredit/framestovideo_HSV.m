NewVid = VideoWriter('../../Output/ExtraCredit/Video/ExtraCredit_Output');
NewVid.FrameRate = 15;
open(NewVid);
colorimagepath = '../../Output/ExtraCredit/Frames/';

for i = 1:180
    filenamecolor = sprintf('out_%d.jpg', i);
    fullfilenamecolor = strcat(colorimagepath, filenamecolor);
    Image = imread(fullfilenamecolor);
    
    writeVideo(NewVid,Image);
end
close(NewVid);
