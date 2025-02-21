clear all
%addpath(genpath('O:\Ludwig\Matlab'))

shadow = imread('O:\Ludwig\Matlab\Thesis\8.9.16_shadowgram\20160908_014_1411_probe.png');
shadow_comp = imread('O:\Ludwig\Matlab\Thesis\8.9.16_shadowgram\20160908_014_1411_probe_PWcrop.png');
shadow_flip = fliplr(shadow);


 for i = 1:1248
 data_cut(i,:) = shadow_flip(299+i,:);
 end

 x = linspace(-1.41,1.22,2048);
 y = linspace(-0.70,0.76,1248);
figure(1); 
%subplot(2,1,1)
imagesc(x,y,data_cut);
colormap('gray');
%cb = colorbar('vert'); 
%zlab = get(cb,'ylabel'); 

