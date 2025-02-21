PW_Dir = dir('*probe.png');
L = length(PW_Dir);

%% generate background image
roi_L = 800;
roi_T = 750;
roi_R = 1599;
roi_B = 949;
for jj = 1:5
I_raw = imread(PW_Dir(8+jj).name);
I = I_raw(roi_T:roi_B, roi_L:roi_R);
I_smooth = smooth(double(I_raw),50,'loess');
% figure(99),imshow(I_raw);
% figure(98),imshow(I);

height = size(I,1);           %get image dimensions
len = size(I,2);              
x = linspace(1,len,len);      % create x-vector with as many entries as x-pixels (not currently used, but useful for creating scale vectors) 

bg=zeros(height,len);         % prepare background-image

for ii = 1:height
    line = double(I(ii,:));     %extract hor. line from original image
    bg_line = smooth(line, 80, 'loess'); %smooth hor. line (low-pass). If bg shows residuals of plasma wave, increase 2nd argument, 
                                         %but keep as low as possible. Best value depends on plasma wavelength.
    
    bg(ii,:) = bg_line;  %assemble bg-image line by line
end

out = uint16(double(I)-bg+2^15);  %subtract low-pass bg from original = high-pass(original)

figure(86)
subplot(5,2,jj*2-1), imagesc(bg);    %plot bg
subplot(5,2,jj*2), imagesc(out);   %plot proc'd image
colormap('gray');
axis image;
end

%%    
for i = 2:L
    I_raw = imread(PW_Dir(i).name);
end