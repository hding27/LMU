clear all
addpath(genpath('O:\Ludwig\Matlab'))

data = load('O:\Ludwig\Matlab\Thesis\phase_map\noname6.asc');
data2 = load('O:\Ludwig\Matlab\Thesis\phase_map\20160908_14bar_nowafer_phase_map_for_lineout.asc');

 for i = 1:430
 data_cut(i,:) = data(784+i,651:1585);
 end
 
 for i = 1:430
 data_cut2(i,:) = data2(784+i,651:1585);
 end


x = linspace(-2.3,1.1,935);
y = (-229:1:201)*3.676e-3;

figure(1); 
%subplot(2,1,1)
imagesc(x,y,data_cut);
colormap('gray');
%cb = colorbar('vert'); 
%zlab = get(cb,'ylabel'); 

%subplot(2,1,2)
figure(2);
imagesc(x,y,data_cut2);
colormap('jet');
cb = colorbar('vert'); 
zlab = get(cb,'ylabel'); 
set(zlab,'String','phase shift [rad]'); 
