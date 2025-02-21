%addpath(genpath('O:\Ludwig\Matlab'))

width = [234 215 206 208 207 202 203 207 205 197 207 214 215 210 216 217 225 224 236 225]*3.676e-3;
err_width = [0.074*234 0.081*215 0.076*206 0.068*208 0.073*207 0.077*202 0.081*203 0.071*207 0.074*205 0.079*197 0.061*207 0.053*214 0.051*215 0.056*210 0.051*216 0.050*217 0.048*225 0.051*224 0.053*236 0.042*225]*3.676e-3;
err_radius_clip = err_width(1,7:18)./2;
radius_clip = width(1,7:18)./2;
x_position = linspace(-1.16,0.45,12);
xp = linspace(-1.2,0.6,12);

P = polyfit(x_position,radius_clip,1);
yfit = P(1)*xp+P(2);

figure(11)
hold on
plot(x_position,radius_clip,'b','LineWidth',1.5)
plot(x_position,yfit,'b--','LineWidth',1.5)
errorbar(x_position,radius_clip,err_radius_clip,'rx');
%xlim([-2.15 0.78])

box on
xlabel('position [mm]','fontsize',18)
ylabel('radius [mm]','fontsize',18)
hold off