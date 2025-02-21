% 
%
%
%

%% parameters

lambda = 0.8e-6; % central wavelength of the laser
c = 3e8; % vacuum speed of light
n_c = 1.76e21 * 1e6;
%%

%% Reference interferogram
Raw_Ref = imread('20160908_008_1305_Interferogram.png');
Pic_Ref = double(Raw_Ref(701:1300,701:1600));
Mask = zeros(size(Pic_Ref));
Mask(529:592,37:100)=1;
Spec_Ref = fft2(Pic_Ref);
Spec_Ref_Masked = Spec_Ref.*Mask;
Interferogram_Ref = ifft2(Spec_Ref_Masked);
Phase_Ref = unwrap(angle(Interferogram_Ref));
figure,imagesc(Phase_Ref)


%% plot the function dependence between signal and rotation angle
Raw = imread('20160908_007_1300_Interferogram.png');
Pic = double(Raw(701:1300,701:1600));
Interferogram  = ifft2(fft2(Pic).*Mask);
Phase = unwrap(angle(Interferogram));
figure(99), imagesc(Phase-Phase_Ref);
