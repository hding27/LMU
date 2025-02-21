%%

cd('O:\ATLAS_Performance\20171025_Propagation_ 30mm_crystal with burn from turning holder')

name = ('80m_PP123_no_titan_rf123_dm_no_loop.png'); % name of the image to be cropped
imageIn = imread(name);

BKG = imread('bg.png'); % the name of background picture, if any
image = double(imageIn - BKG);
%%
figure(1), imshow(image,[0,1000]);

kern = [1,1,1;1,0,1;1,1,1]/8;
imageFil = conv2(image,kern,'same');
figure(2), imagesc(imageFil)
%%
com = centerOfMass(imageFil)
com1 = centerOfMass(image)
%%
top = 257; % left edge of ROI
left = 410; % top edge of ROI
L = 1024; % edge length of ROI

imageROI = image(top:top+L, left:left+L);
figure,imagesc(imageROI)
title(name,'Interpreter', 'none')
colorbar()
