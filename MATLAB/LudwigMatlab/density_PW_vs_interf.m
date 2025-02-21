close all;

addpath(genpath('O:\Ludwig\Matlab'))


xp = 0:0.5:30; 


density_PW = [ 2.0e18 2.3e18 2.5e18 2.8e18 3.2e18 3.9e18];
density_PW_new = [ 2.0e18 2.3e18 2.5e18 2.8e18 3.0e18 3.46e18];
density_PW_new2 = [ 2.22e18 2.37e18 2.73e18 2.95e18 3.07e18 3.64e18];
density_interf = [ 2.0e18 2.6e18 2.8e18 3.3e18 3.5e18 3.9e18];
density_fit = [2.18e18 2.68e18 2.49e18 3.15e18 3.45e18 3.38e18];
density_fit_av = [2.0e18 2.5e18 2.4e18 3.0e18 3.0e18 3.3e18];
density_fit_av_new = [2.1e18 2.25e18 2.35e18 2.55e18 2.8e18 3.15e18];
density_fit_av_new2 = [2.29e18 2.38e18 2.65e18 3.07e18 3.35e18 3.86e18];
density_interf_av = [ 2.26e18 2.76e18 2.88e18 3.45e18 3.72e18 4.0e18];
density_interf_minmax = [2.3e18 2.8e18 3.1e18 3.6e18 3.9e18 4.4e18];
pressure = 8:2:18;

err_interf = [ 0.25*2.26e18 0.2*2.76e18 0.36*2.88e18 0.32*3.45e18 0.34*3.72e18 0.5*4.0e18]./2;
err_interfmin_max = [0.3e18 0.2e18 0.3e18 0.3e18 0.4e18 0.5e18];
err_density_fit_av_new = [0.075*2.1e18 0.075*2.25e18 0.09*2.35e18 0.085*2.55e18 0.085*2.8e18 0.08*3.15e18];
err_density_fit_av_new2 = [0.052*2.29e18 0.049*2.38e18 0.043*2.65e18 0.042*3.07e18 0.041*3.35e18 0.044*3.86e18];
err_neg_PW = [0.093*2.0e18 0.097*2.3e18 0.103*2.5e18 0.109*2.8e18 0.113*3.2e18 0.126*3.9e18];
err_pos_PW = [0.107*2.0e18 0.115*2.3e18 0.123*2.5e18 0.127*2.8e18 0.138*3.2e18 0.154*3.9e18];
err_neg_PW_new = [0.093*2.0e18 0.097*2.3e18 0.101*2.5e18 0.109*2.8e18 0.11*3.2e18 0.118*3.9e18];
err_pos_PW_new = [0.107*2.0e18 0.115*2.3e18 0.121*2.5e18 0.127*2.8e18 0.133*3.2e18 0.142*3.9e18];



figure(1);
errorbar(pressure,density_interf,err_interf)
hold on
errorbar(pressure,density_PW,err_neg_PW,err_pos_PW)
hold off

figure(2);
P = polyfit(pressure,density_interf_av,1);
yfit = P(1)*xp+P(2);

P2 = polyfit(pressure,density_PW,1);
yfit2 = P2(1)*xp+P2(2);

plot(xp,yfit)
hold on
plot(xp,yfit2)
errorbar(pressure,density_interf_av,err_interf,'o')
errorbar(pressure,density_PW,err_neg_PW,err_pos_PW,'x')
hold off

figure(3);
P3 = polyfit(pressure,density_fit,1);
yfit3 = P3(1)*xp+P3(2);
plot(pressure,density_fit,'x',xp,yfit3,pressure,density_PW,'o',xp,yfit2)


figure(4);
P4 = polyfit(pressure,density_interf_minmax,1);
yfit4 = P4(1)*xp+P4(2);

P2 = polyfit(pressure,density_PW_new,1);
yfit2 = P2(1)*xp+P2(2);

plot(xp,yfit4)
hold on
plot(xp,yfit2)
errorbar(pressure,density_interf_minmax,err_interfmin_max,'o')
errorbar(pressure,density_PW_new,err_neg_PW_new,err_pos_PW_new,'x')
hold off


figure(5);
P5 = polyfit(pressure,density_fit_av,1);
yfit5 = P5(1)*xp+P5(2);

P2 = polyfit(pressure,density_PW_new,1);
yfit2 = P2(1)*xp+P2(2);

plot(xp,yfit5)
hold on
plot(xp,yfit2)
%plot(xp,yfit4)
%errorbar(pressure,density_interf_minmax,err_interfmin_max,'d')
errorbar(pressure,density_fit_av,0.1*density_fit_av,'o')
errorbar(pressure,density_PW_new,err_neg_PW_new,err_pos_PW_new,'x')
hold off

figure(6);
P6 = polyfit(pressure,density_fit_av_new,1);
yfit6 = P6(1)*xp+P6(2);

P21 = polyfit(pressure,density_PW_new,1);
yfit21 = P21(1)*xp+P21(2);

plot(xp,yfit6)
hold on
plot(xp,yfit21)
errorbar(pressure,density_fit_av_new,err_density_fit_av_new,'o')
errorbar(pressure,density_PW_new,err_neg_PW_new,err_pos_PW_new,'x')
hold off


figure(7);
P7 = polyfit(pressure,density_fit_av_new2,1);
yfit7 = P7(1)*xp+P7(2);

P22 = polyfit(pressure,density_PW_new2,1);
yfit22 = P22(1)*xp+P22(2);

plot(xp,yfit7)
hold on
plot(xp,yfit22)
errorbar(pressure,density_fit_av_new2,err_density_fit_av_new2,'o')
errorbar(pressure,density_PW_new2,0.01*density_PW_new2,'x')
hold off


grad = (max(yfit21)-min(yfit21))/30;


