%%
myDir = dir('*.png');


%% a test of functionaliy wtih the first file
i = 1;
filename = myDir(i).name;
name = filename(1:18);
%%
image = imread(filename);
figure,imshow(image,[0 4000])
%%
top = 405;
left = 707;
size = 511;

imageROI = image(top:top+size,left:left+size);
figure,imshow(imageROI,[0,4000])

%%
imageOUT = uint8(double(imageROI)/16);
figure,imshow(imageOUT)
imwrite(imageOUT,[name 'ROI.bmp'])

%% loop over the rest of files
for i = 2:length(myDir)
    filename = myDir(i).name;
    name = filename(1:18);
    image = imread(filename);
    imageROI = image(top:top+size,left:left+size);
    imageOUT = uint8(double(imageROI)/16);
    imwrite(imageOUT,[name 'ROI.bmp']);
end



