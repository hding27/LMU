clear all;
close all;

A=imread('PW_image.png'); %read image file (always save as 16-bit greyscale !!!!!)

figure;     %plot original

imagesc(A);
colormap('gray');
axis image;

height = size(A,1);           %get image dimensions
len = size(A,2);              
x = linspace(1,len,len);      % create x-vector with as many entries as x-pixels (not currently used, but useful for creating scale vectors) 
% xx = linspace(1,len,len/65);

bg=zeros(height,len);         % prepare background-image

for ii = 1:height
    line = double(A(ii,:));     %extract hor. line from original image
%     sp = spline(x,line,xx);
%     bg_line = spline(xx,sp,x);
    bg_line = smooth(line, 50, 'lowess');   %smooth hor. line (low-pass). If bg shows residuals of plasma wave, increase 2nd argument, 
                                            %but keep as low as possible. Best value depends on plasma wavelength.
    
    bg(ii,:) = bg_line;                     %assemble bg-image line by line
    

end

figure;                                     %plot bg
imagesc(bg);
colormap('gray');
axis image;

out = uint16(double(A)-bg+32768);           %subtract low-pass bg from original = high-pass(original)

%line_out = out(120,:);


figure;                                     %plot proc'd image
imagesc(out);
colormap('gray');
axis image;

figure;
subplot(2,1,1)
imagesc(A);
colormap('gray');
axis image;

subplot(2,1,2)
imagesc(out);
colormap('gray');
axis image;