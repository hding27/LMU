%
%
%
%
path = 'O:\Electrons\20160922';
cd(path);

%%
dirR = dir('.\Probe\*_007_*.png');
dirT = dir('.\Interferogram\*_007_*.png');
imageR = imread('.\Probe\20160922_007_1145_Probe.png');
imageT = imread('.\Interferogram\20160922_007_1145_Interferogram.png');
figure,imshow(imageR)
figure,imshow(imageT)
I_R = fliplr(double(imageR));
I_T = double(imageT);

%%
roiL = 281;
roiT = 482;
roiR = 1774;
roiB = 1729;
%%
offsetX = -125;
offsetY = -75;
Ratio = I_R(roiT+offsetY:roiB+offsetY,roiL+offsetX:roiR+offsetX)./I_T(roiT:roiB,roiL:roiR);
figure,imagesc(Ratio)