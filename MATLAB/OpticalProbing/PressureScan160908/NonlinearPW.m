function [pwLength, varargout] = NonlinearPW(A_full, varargin)
% [pwLength, LaserProfile] = NonlinearPW(A_full)
% [pwLength, LaserProfile] = NonlinearPW(A_full, ROI, buffer, wl_roi, resolution, shotNo.)
%
%

%% input parser, to-be-developed
ROI = varargin{1};
buffer = varargin{2};
wl_roi = varargin{3};
resolution = varargin{4};
number = varargin{5};
%% remove slow varying background
A = double(A_full(ROI(1)-buffer:ROI(3)+buffer,ROI(2):ROI(4)));
% figure,imshow(A)
bg=zeros(size(A,1),size(A,2));         % prepare background-image
for ii = 1:size(A,1) % A should be of double-type
%   If bg shows residuals of plasma wave, increase 2nd argument of smooth, 
%   but keep as low as possible. Best value depends on plasma wavelength.
    line = A(ii,:);     
    bg_line = smooth(line, 50, 'lowess');   
    bg(ii,:) = bg_line;                      
end
% figure,imagesc(bg); colormap('gray'); axis image;
%% rotate the image so that pw propagates horizontally
A_rot = imrotate(A-bg, 0, 'bilinear', 'crop');
A_rot = A_rot(1+buffer:end-buffer, :);
% figure,imagesc(uint16(A_rot+32768)); colormap('gray'); axis image;
%% prepare FFT
len   = ROI(4)-ROI(2)+1;
hight = ROI(3)-ROI(1)+1;
index1 = ceil(resolution*len/wl_roi(2));
index2 = ceil(resolution*len/wl_roi(1))+1;
wl_ext = resolution*len./(index1-2:index2);
wl_fft = wl_ext(2:end-1); % wavelengths coresponding to the grid of fft
wl_diff = (wl_ext(3:end)-wl_ext(1:end-2))/2; % 1st derivative of wavelength
%% FFT the rotated image to get spectrogram
spectro_full = fft(A_rot');
spectro_norm = kron(ones(hight,1), wl_diff)';
spectrogram = abs(spectro_full(index1:index2,:)./spectro_norm);
% figure,h = pcolor(wl_fft,(1:hight),spectrogram');
% set(h,'EdgeColor','none')
% xlabel('wavelength [\mum]')
% ylabel('position [px]')
%% smooth the spectrogram
kernal = Gauss2(9,3);
spectro_filt = conv2(spectrogram,kernal,'same');
spectro_filt(spectro_filt<0.85*max(spectro_filt(:))) = 0; 
h=pcolor(wl_fft,(1:hight),spectro_filt');
title(number)
set(h,'EdgeColor','none')
xlabel('wavelength [um]')
ylabel('position [px]')
%% count the regions in the smoothed spectrogram
spectro_bin = spectro_filt; % binarilize to count regions
spectro_bin(spectro_bin<0.85*max(spectro_bin(:)))=0; 
spectro_bin(spectro_bin~=0)=1;
[L, num] = bwlabel(spectro_bin);
N = 0; % number of regions
pwLength = [number, zeros(1,4)];
pwE = wl_roi(1)/resolution; % expected min. plasma wavelength in px
    for jj = 1:num        
        [r,c]= find(L==jj); % r for wavelength, c for transverse position
        if (max(r)-min(r)>3 || max(c)-min(c)>pwE/2)
            N = N+1;        
            if (N>2)
                pwLength(2:end) = 0;
%                 figure,h=pcolor(wl_fft,(1:hight),spectro_filt');
%                 title(number)
%                 set(h,'EdgeColor','none')
%                 xlabel('wavelength [\mum]')
%                 ylabel('position [px]')
                 break
            end
            pdf = diag(spectrogram(r,c))/sum(diag(spectrogram(r,c)));
            pwl_mean = wl_fft(r)*pdf; % mean of wavelength
            pwLength(2*N) = pwl_mean;
            pwLength(2*N+1) = sqrt((wl_fft(r)-pwl_mean).^2 * pdf); % std
        end
    end
%% prepare output
LaserProfile = 0;
varargout{1} = LaserProfile;
varargout{2} = wl_fft;
end    