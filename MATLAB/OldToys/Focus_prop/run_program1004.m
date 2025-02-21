clc
clear

addpath('\\z-sv-pool08\Hao.Ding\MATLAB\Focus_prop')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate the intensityfactor for each wavelength

% I=function_wavelength_vs_intensity(256);  % parameter is sampling
% wavelength=I(1,:);
% Intensityfactor=I(2,:);
% figure(1)
% plot(wavelength,Intensityfactor)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% intensity modulation mask

% Mask=function_Mask(290e-3,500e-3,2048,1); % function_Mask(aperture_diameter,gridsize,gridnumber,flag)
% figure(2)
% mesh(Mask)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% flat-top intensity mask
gridnumber = 2048;
Mask = ones(gridnumber,gridnumber);   
% figure(3)
% imagesc(Mask)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Intensity in focus
wavelength = 1053e-9;
gridsize = 500e-3;
aperture_diameter = 90e-3;
focallength = 1800e-3;
factor = 0.1;
%%

%%
Intensity = function_focus(wavelength,gridsize,gridnumber,aperture_diameter,Mask,focallength,factor);
figure
imagesc(Intensity)
title('intensity')

% new=Intensity(1024-45:1024+45,1024-45:1024+45);
% figure(5)
% mesh(new)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Intensity in focus_2step

% Intensity=function_focus_2step(1053e-9,320e-3,2048,290e-3,Mask,800e-3,0.9997);
% function_focus(wavelength,gridsize,gridnumber,aperture_diameter,Mask,focallength,propagationlength)
% figure(4)
% mesh(Intensity)

% new=Intensity(1024-45:1024+45,1024-45:1024+45);
% figure(5)
% mesh(new)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Intensity in focus for each wavelength
% 
% for i=1:1:256
% lambda=wavelength(i);
% number(i)=fun_intensity_in_focus(lambda,500e-3,n,145e-3,Mask,800e-3,0.9997*800e-3);
% newintensity(i)=number(i)*Intensityfactor(i);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IFFT of new intensity in focus

% temporalcontrast=function_1D_IFFT(Intensityfactor);
% time=temporalcontrast(1,:);
% amplitude=temporalcontrast(2,:);
% figure(5)
% semilogy(time,amplitude)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end




