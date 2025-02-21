x = 5:2.5:17.5;   %2.12.16
xp = 0:0.5:55;     
y = [1.4e18 1.89e18 2.33e18 2.68e18 3.22e18 3.4e18];  %2.12.16 IDEA
yf =[1.38e18 1.82e18 2.28e18 2.62e18 2.91e18 3.20e18];  %2.12.16 phase fitting
yf_average =[1.5e18 1.9e18 2.3e18 2.7e18 3.0e18 3.3e18];  %2.12.16 phase fitting average
y_comb = [1.55e18 1.95e18 2.39e18 2.72e18 3.16e18 3.35e18]; %2.12.16 average
y_comb_nofit = [1.64e18 2.02e18 2.45e18 2.77e18 3.29e18 3.43e18];  %2.12.16 average of abel reconstruction
err_comb = [0.23*1.55e18 0.14*1.95e18 0.12*2.39e18 0.10*2.72e18 0.18*3.16e18 0.11*3.35e18]./2;
err_yf_average = [0.049*1.5e18 0.045*1.9e18 0.043*2.3e18 0.042*2.7e18 0.043*3.0e18 0.035*3.3e18];
err_y_comb_nofit = [0.14*1.64e18 0.06*2.02e18 0.05*2.45e18 0.03*2.77e18 0.02*3.29e18 0.01*3.43e18];

x2 = 8:2:18;
y2 = [2.0e18 2.56e18 2.8e18 3.3e18 3.5e18 3.86e18];
y2min_max = [2.3e18 2.8e18 3.1e18 3.6e18 3.9e18 4.4e18];
y2min_max_new = [2.69e18 2.87e18 3.27e18 3.56e18 3.89e18 4.48e18];  %new lineouts and Abel reconstruction
yf_average_fit =[2.1e18 2.25e18 2.35e18 2.55e18 2.8e18 3.15e18];   %new lineouts
err_min_max = [0.3e18 0.2e18 0.3e18 0.3e18 0.4e18 0.5e18];    
y2f = [2.18e18 2.68e18 2.49e18 3.15e18 3.45e18 3.38e18];
ylin_abel = [2.38e18 2.54e18 2.90e18 3.17e18 3.48e18 3.95e18];  %upper channel central values

P2 = polyfit(x2,y2,1);
yfit2 = P2(1)*xp+P2(2);
%plot(x2,y2,'o',xp,yfit2)


P = polyfit(x,yf,1);
yfit = P(1)*xp+P(2);
%plot(x,y,'o',x,yf,'x',x2,y2,'d',x2,y2f,'+',xp,yfit2,xp,yfit)
figure(3);
%plot(x,y,'o',x,yf,'x',xp,yfit)
plot(x,yf,'x',xp,yfit)

P3 = polyfit(x,y_comb,1);
yfit3 = P3(1)*xp+P3(2);
figure(2);
%plot(x,y,'o',x,yf,'x',x2,y2,'d',x2,y2f,'+',xp,yfit2,xp,yfit)
plot(xp,yfit3)
hold on
errorbar(x,y_comb,err_comb,'o')
hold off

P4 = polyfit(x2,y2min_max,1);
yfit4 = P4(1)*xp+P4(2);
figure(12);
%plot(x,y,'o',x,yf,'x',x2,y2,'d',x2,y2f,'+',xp,yfit2,xp,yfit)
plot(xp,yfit4)
hold on
errorbar(x2,y2min_max,err_min_max,'o')
hold off

figure(23)
P23 = polyfit(x,yf_average,1);
yfit23 = P23(1)*xp+P23(2);

P24 = polyfit(x,y_comb_nofit,1);
yfit24 = P24(1)*xp+P24(2);
plot(xp,yfit23)
hold on
plot(xp,yfit24)
errorbar(x,y_comb_nofit,err_y_comb_nofit,'o')
errorbar(x,yf_average,err_yf_average,'x')
hold off

figure(25)
P25 = polyfit(x2,y2min_max_new,1);
yfit25 = P25(1)*xp+P25(2);

P26 = polyfit(x2,yf_average_fit,1);
yfit26 = P26(1)*xp+P26(2);
plot(xp,yfit25)
hold on
plot(xp,yfit26)
errorbar(x2,y2min_max_new,0.04*y2min_max_new,'o')
errorbar(x2,yf_average_fit,0.04*yf_average_fit,'x')
hold off

%2.12.16 lin values

figure(29)
P29 = polyfit(x,y,1);
yfit29 = P29(1)*xp+P29(2);

P30 = polyfit(x,yf_average,1);
yfit30 = P30(1)*xp+P30(2);
plot(xp,yfit29,'b-','LineWidth',1.5)
xlim([0 55])
ylim([0 10e18])
xlabel('pressure [bar]','fontsize',18)
ylabel('electron density [cm^{-3}]','fontsize',18)
hold on
plot(xp,yfit30,'r-','LineWidth',1.5)
xlim([0 55])
ylim([0 10e18])
xlabel('pressure [bar]','fontsize',18)
ylabel('electron density [cm^{-3}]','fontsize',18)
errorbar(x,y,0.056*y,'bo')
errorbar(x,yf_average,err_yf_average,'rx')
hold off



%error calculation
rmsd = sqrt(sum((yfit23-yfit24).^2)/length(yfit23));
rms = rmsd/(max(yfit24)-min(yfit24));
grad = (max(yfit25)-min(yfit25))/30;

