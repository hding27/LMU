% test facility for polarimetry
%
%
%
%%
I_BKG = double(imread('20161010_000_0774_probe.png'));
figure(66),imagesc(I_BKG);
I_SGN = double(imread('20161010_000_1759_probe.png'));
figure(66),imagesc(I_SGN/mean(mean(I_SGN))-I_BKG/mean(mean(I_BKG)));
%%
spec_raw = fft2(I_BKG);
figure(67),surf(abs(spec_raw),'linestyle','none')
%%
rm = 3; % frist rm elements to-be-removed from the spectrum
spec = spec_raw;
spec(1:ceil(rm/2),1:ceil(rm/2)) = 0;
spec(end-floor(rm/2):end, end-floor(rm/2):end)= 0;
I = abs(ifft2(spec));

imagesc(I)
%%
roiX = 617;
sizeX = 480;
offsetX = -45;
roiY = 1400;
sizeY = 320;
offsetY = -10;
Raw1=double(imread('20161025_009_1801_probe.png'));
I1 = Raw1(roiY:roiY+sizeY-1,roiX:roiX+sizeX-1);
figure,imagesc(I1),axis equal tight
Raw2=double(imread('20161025_009_1801_Interferogram.png'));
Raw2=fliplr(Raw2);
I2 = Raw2(roiY+offsetY:roiY+sizeY-1+offsetY,roiX+offsetX:roiX+sizeX-1+offsetX);
figure,imagesc(I2), axis equal tight
figure,imagesc(I1./I2), axis equal tight