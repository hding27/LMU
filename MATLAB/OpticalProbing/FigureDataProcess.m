function FigureDataProcess(A,C,E,F)
% to produce the fig_DataProcessing for the LWAP2017 proceeding
% 
%
%
roiL = 365;
roiR = 1324;
roiT = 55;
roiB = 144;
buffer = 0;
resolution = 0.869;
yy = (-45:44)*resolution;
fontsize = 18;

B = fliplr(A(roiT-buffer:roiB+buffer,roiL:roiR));
D = fliplr(C(:,roiL:roiR)-8000);

RI = imref2d(size(B));
RI.XWorldLimits = [0 resolution*(roiR-roiL)];
RI.YWorldLimits = [min(yy) max(yy)];



figure(26),imshow(B,RI);
set(gca(),'fontsize',fontsize);
% f=getframe;
% imwrite(f.cdata,'DP_RAW.png');
% xlabel('position [\mum]','fontsize',fontsize)
% ylabel('position [\mum]','fontsize',fontsize)

figure(27),imshow(D,RI);
set(gca(),'fontsize',fontsize);
% f=getframe;
% imwrite(f.cdata,'DP_Enhance.png');
% xlabel('position [\mum]','fontsize',fontsize)
% ylabel('position [\mum]','fontsize',fontsize)

figure(28);
h=pcolor(E,yy,F);
set(h,'EdgeColor','none')
set(gca(),'fontsize',fontsize);
colormap('jet');
% f=getframe;
% imwrite(f.cdata,'DP_FFT.png');
% xlabel('wavelength [\mum]','fontsize',fontsize)
% ylabel('position [\mum]','fontsize',fontsize)
end