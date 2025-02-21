clear all;
close all;
%load('constants');

t = linspace(1,333, 300)*1e-11;
x = linspace(0,1,300);
y = linspace(-0.1,0.1,101);
[X,Y] = meshgrid(x,y);
clims = [-3 3]; 
k = pi*10;
c= 3e8;
w = c*k;
yb = 0;


for i = 1:300
   xb = c*t(i);
   ampl =  (sin(w*t(i)+k*X)-sin(w*t(i)-k*X));
   bunch = ((-ampl+3).*exp(-(((X-xb)/0.01).^2)).*exp(-((Y/0.01).^2)));
   field = (sin(w*t(i)+k*X)-sin(w*t(i)-k*X)).*exp(-((Y/0.05).^2));
   drawnow;
   imagesc(x,y,bunch+field,clims);
   %rectangle('Position',[0,02,-0.07,0.07,0.07],'Curvature',0.03);
   daspect([1,1,1]);
   set(gca,'Visible','off');
   F(i) = getframe(gcf);
   
   
end

video = VideoWriter('RF_acc.avi','Uncompressed AVI');
open(video);
writeVideo(video,F);
close(video);