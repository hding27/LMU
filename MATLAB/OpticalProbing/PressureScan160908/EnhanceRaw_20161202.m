baseDir = './InputFiles/';
PW_Dir = dir([baseDir '*_006_*probe.png']);
L = length(PW_Dir);

%% generate background image using average
roi_L = 750;
roi_T = 830;
roi_R = roi_L+1024;
roi_B = roi_T+160;

jj = 1;
I_raw = fliplr(imread([baseDir PW_Dir(jj).name]));
%imshow(I_raw)
%%
I = double(I_raw(roi_T:roi_B, roi_L:roi_R));
I_bg = I; 

for jj = 2:5
    I_raw = imread([baseDir PW_Dir(jj).name]);
    I = double(fliplr(I_raw(roi_T:roi_B, roi_L:roi_R)));
    I_bg = I_bg+I; 
end
I_bg = I_bg/5;
%%
jj = 1;
I_raw = imread([baseDir PW_Dir(jj).name]);
I =uint16( double(fliplr(I_raw(roi_T:roi_B, roi_L:roi_R)))-I_bg +30000);
figure(85)
imshow(I),colormap('gray')

%% generate bg using local regression
% I_smooth = smooth(double(I),25,'loess');
% % figure(99),imshow(I_raw);
% % figure(98),imshow(I);

height = size(I,1);           %get image dimensions
len = size(I,2);              
x = linspace(1,len,len);      % create x-vector with as many entries as x-pixels (not currently used, but useful for creating scale vectors) 

bg=zeros(height,len);         % prepare background-image

for ii = 1:height
    line = double(I(ii,:));     %extract hor. line from original image
    bg_line = smooth(line, 45, 'loess'); %smooth hor. line (low-pass). If bg shows residuals of plasma wave, increase 2nd argument, 
                                         %but keep as low as possible. Best value depends on plasma wavelength.
    
    bg(ii,:) = bg_line;  %assemble bg-image line by line
end

out = uint16((double(I)-bg)*15+30000);  %subtract low-pass bg from original = high-pass(original)
figure(86),
subplot(3,1,1), imagesc(I);
title(PW_Dir(jj).name(14:17)),axis image;
subplot(3,1,2), imagesc(out); axis image;  %plot proc'd image
subplot(3,1,3), imagesc(bg); axis image;    %plot bg
colormap('gray');