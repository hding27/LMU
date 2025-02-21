%%
% this is to analyse the two wave merging appeared on 2016-08-30
%
%
%
A = imread('O:\Electrons\20160830\probe\20160830_001_0629_probe.png');
%A = double(A_full);
figure,imshow(A)
mean(A(:))
test = abs(fft(double(A')));
test = test(index1:index2,:)';
test(test<0.55*max(test(:)))=0;
max(test(:))
figure,imagesc(test(1050:1100,:))%%
A = imread('O:\Electrons\20160830\probe\20160830_001_0620_probe.png');
%A = double(A_full);
figure,imshow(A)
mean(A(:))
test = abs(fft(double(A')));
test = test(index1:index2,:)';
test(test<0.55*max(test(:)))=0;
max(test(:))
figure,imagesc(test(1050:1100,:))