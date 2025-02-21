% analyses for nonlinear laser evoluttion inside plasma
% data were taken on 2016-12-01
% contact Hao.Ding@physik.uni-muenchen.de for support
%
%% set up working environment
addpath(genpath('\\z-sv-pool08\Hao.Ding\MATLAB\HDingMatlabTools\'));
ProfileEvl20161201Config;
%%  
ROI = [921, 1030; 1, 2048]; % [1-top, 3-bottom; 2-left, 4-right]
buffer = 50; % to be cropped after rotating image
resolution = prob.PixelSize(1); % um per px
wl_roi = [10, 25]; % shortest/longest wavelength of interest, in um

output = zeros(ROI(3)-ROI(1)+1,length(shots));
%%
close all
kk = 5;
shots =  shotSet(positionSet==positions(kk));
for jj=2:length(shots)
%%
    number = shots(jj);
    fileName = [myDir, '/Probe/', char(prob.FileName(prob.No == number))];
    A_full = imread(fileName);
    A = double(A_full(ROI(1)-buffer:ROI(3)+buffer,ROI(2):ROI(4)));
    figure,imagesc(A); colormap('gray');axis image;
bg=zeros(size(A,1),size(A,2));         % prepare background-image
for ii = 1:size(A,1) % A should be of double-type
%   If bg shows residuals of plasma wave, increase 2nd argument of smooth, 
%   but keep as low as possible. Best value depends on plasma wavelength.
    line = A(ii,:);     
    bg_line = smooth(line, 50, 'lowess');   
    bg(ii,:) = bg_line;                      
end
figure, imagesc(bg);colormap('gray'); axis image;
%% 
A_rot = imrotate(A-bg, -1.8, 'bilinear', 'crop');
A_rot = A_rot(1+buffer:end-buffer, :);
figure,imagesc(uint16(A_rot+32768)); title('A_{rot}'); colormap('gray'); axis image;
%% 
len   = ROI(4)-ROI(2)+1;
hight = ROI(3)-ROI(1)+1;
index1 = ceil(resolution*len/wl_roi(2));
index2 = ceil(resolution*len/wl_roi(1))+1;
wl_ext = resolution*len./(index1-2:index2);
wl_fft = wl_ext(2:end-1); % wavelengths coresponding to the grid of fft
wl_diff = (wl_ext(3:end)-wl_ext(1:end-2))/2; % 1st derivative of wavelength
%%
spectro_full = fft(A_rot');
spectro_norm = kron(ones(hight,1), wl_diff)';
spectrogram = abs(spectro_full(index1:index2,:)./spectro_norm);
figure,h = pcolor(wl_fft,(1:hight),spectrogram');
set(h,'EdgeColor','none')
xlabel('wavelength [\mum]'); ylabel('position [px]');
%%
kernel = Gauss2(9,3);
spectro_filt = conv2(spectrogram,kernel,'same');
spectro_filt(spectro_filt<0.3*max(spectro_filt(:))) = 0; 
% figure,h=pcolor(wl_fft,(1:hight),spectro_filt'); title(number);
% set(h,'EdgeColor','none')
% xlabel('wavelength [um]');ylabel('position [px]');
%%
profile = wl_fft*spectro_filt./(sum(spectro_filt)+eps);
%profile = conv(profile,ones(1,5)/5,'same');
%figure,plot(profile);ylim([13 19])
end

%%
% lp0 = [16.48 16.48 16.63 16.63 17.11 16.30 16.03 15.48 15.48];
% lp1 = [17.28 17.28 16.95 17.11 17.80 16.95 16.79 16.33 16.62];
% figure(61),plot(positions,lp1,'-r'); hold on
% plot(positions,lp0,'-g'); hold off
% figure(62),plot(positions,lp1./lp0);