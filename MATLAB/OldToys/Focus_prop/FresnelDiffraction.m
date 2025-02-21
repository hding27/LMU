% function Intensity=FresnelDiffraction(wavelength,gridsize,gridnumber,aperture_diameter,Mask,focallength,factor)

% Intensity=FresnelDiffraction(wavelength,gridSize,gridNumber,aperture_diameter,Mask,focalLength,factor)
%
%
% 

wavelength = 1053e-9;
gridsize = 500e-3;
gridnumber = 2048;
aperture_diameter = 90e-3;
Mask = ones(gridnumber,gridnumber); 
focallength = 1800e-3;
factor = 0.1;

Intensity = zeros(gridnumber);
Field = zeros(gridnumber);