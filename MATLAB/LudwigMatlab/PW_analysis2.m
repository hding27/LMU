%clear all;
%close all;

%addpath(genpath('O:\Ludwig\Matlab'))
%splinefit = load('spline_fit.mat');
%A=imread('O:\Ludwig\Matlab\Thesis\8.9.16_PW_analysis\20160908_007_1296_18bar.png'); %read image file (always save as 16-bit greyscale !!!!!)
A=imread('O:\Ludwig\Matlab\PW_image.png');
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

%figure;                                     %plot bg
%imagesc(bg);
%colormap('gray');
%axis image;

out = uint16(double(A)-bg+32768);           %subtract low-pass bg from original = high-pass(original)

line_out = out(122,:);
line_out = double(line_out(1,360:920));
xaxis = 1:561;

average = sum(line_out)/length(line_out);
%fitobject = fit(xaxis,line_out,'smoothingspline');

%[pks,locs] = findpeaks(double(line_out(1,60:200)));

figure(3); 
subplot(4,1,1)
imagesc(A(:,360:912));
colormap('gray');
%axis image;
subplot(4,1,2)%plot proc'd image
imagesc(out(:,360:912));
colormap('gray');
%axis image;
subplot(4,1,3)
plot(line_out-average)
xlim([1 561]);
ylabel('a.u.')
subplot(4,1,4)
plot(splinefit)
xlim([1 561]);
xlabel('pixel')
ylabel('a.u.')

%figure;
%plot(pks);