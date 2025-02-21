xp = 0:0.5:30; 
c = 3e8;
%w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
dens = 0:0.1e18:6e18;
pressure = 8:2:18;

density_PW = [ 2.0e18 2.3e18 2.5e18 2.8e18 3.2e18 3.9e18];
density_PW_new = [2.05e18 2.27e18 2.47e18 2.84e18 3.01e18 3.46e18];
density_PW_new2 = [ 2.22e18 2.37e18 2.73e18 2.95e18 3.07e18 3.64e18];
density_interf = [ 2.0e18 2.6e18 2.8e18 3.3e18 3.5e18 3.9e18];
density_fit = [2.18e18 2.68e18 2.49e18 3.15e18 3.45e18 3.38e18];
density_fit_av = [2.0e18 2.5e18 2.4e18 3.0e18 3.0e18 3.3e18];
density_fit_av_new = [2.1e18 2.25e18 2.35e18 2.55e18 2.8e18 3.15e18];
density_fit_av_new2 = [2.29e18 2.38e18 2.65e18 3.07e18 3.35e18 3.86e18];
density_interf_av = [ 2.26e18 2.76e18 2.88e18 3.45e18 3.72e18 4.0e18];
density_interf_minmax = [2.3e18 2.8e18 3.1e18 3.6e18 3.9e18 4.4e18];
density_interf_minmax_new = [2.69e18 2.87e18 3.27e18 3.56e18 3.89e18 4.48e18];

PW_length = [23e-6 22e-6 21e-6 20e-6 19e-6 17e-6];
PW_length_new = [23e-6 22e-6 21e-6 20e-6 19.3e-6 18e-6];
PW_length_new2 = [22.43e-6 21.72e-6 20.25e-6 19.47e-6 19.07e-6 17.52e-6];

%error
err_interf = [ 0.25*2.26e18 0.2*2.76e18 0.36*2.88e18 0.32*3.45e18 0.34*3.72e18 0.5*4.0e18]./2;
err_interfmin_max = [0.3e18 0.2e18 0.3e18 0.3e18 0.4e18 0.5e18];
err_density_fit_av = [0.075*2.1e18 0.075*2.25e18 0.09*2.35e18 0.085*2.55e18 0.085*2.8e18 0.08*3.15e18];
err_density_fit_av_new = [0.075*2.1e18 0.075*2.25e18 0.09*2.35e18 0.085*2.55e18 0.085*2.8e18 0.08*3.15e18];
err_density_fit_av_new2 = [0.052*2.29e18 0.049*2.38e18 0.043*2.65e18 0.042*3.07e18 0.041*3.35e18 0.044*3.86e18];
err_neg_PW = [0.093*2.0e18 0.097*2.3e18 0.103*2.5e18 0.109*2.8e18 0.113*3.2e18 0.126*3.9e18];
err_pos_PW = [0.107*2.0e18 0.115*2.3e18 0.123*2.5e18 0.127*2.8e18 0.138*3.2e18 0.154*3.9e18];
err_neg_PW_new = [0.093*2.0e18 0.097*2.3e18 0.101*2.5e18 0.109*2.8e18 0.11*3.2e18 0.118*3.9e18];
err_pos_PW_new = [0.107*2.0e18 0.115*2.3e18 0.121*2.5e18 0.127*2.8e18 0.133*3.2e18 0.142*3.9e18];
err_neg_PW_length_new = [0.051*23e-6 0.054*22e-6 0.056*21e-6 0.060*20e-6 0.062*19.3e-6 0.067*18e-6];
err_pos_PW_length_new = [0.047*23e-6 0.054*22e-6 0.052*21e-6 0.055*20e-6 0.057*19.3e-6 0.067*18e-6];
err_PW_length_new2 = [0.026*22.43e-6 0.024*21.72e-6 0.026*20.25e-6 0.027*19.47e-6 0.035*19.07e-6 0.030*17.52e-6];

lambda_p = 2*pi*c*sqrt((eps*m_e)./(density_fit_av_new2*1e6*q^2));
lambda_p_calc = 2*pi*c*sqrt((eps*m_e)./(dens*1e6*q^2));
%simulation
PW_length_sim_ao4 = 21e-6;
PW_length_sim_ao2 = 20.05e-6;


p = polyfit(density_fit_av,lambda_p,2);
fit1 = p(1)*dens.^2+p(2)*dens+p(3);
p2 = polyfit(density_fit_av,PW_length_new,2);
fit2 = p2(1)*dens.^2+p2(2)*dens+p2(3);


figure(1);
errorbar(pressure,density_interf,err_interf,'or')
hold on
errorbar(pressure,density_PW,err_neg_PW,err_pos_PW,'+b')
hold off

figure(2);
P = polyfit(pressure,density_interf_av,1);
yfit = P(1)*xp+P(2);

P2 = polyfit(pressure,density_PW,1);
yfit2 = P2(1)*xp+P2(2);

plot(xp,yfit)
hold on
plot(xp,yfit2)
errorbar(pressure,density_interf_av,err_interf,'or')
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


figure(12)
plot(density_fit_av,lambda_p,'bo',dens,lambda_p_calc,'b--')
hold on
errorbarxy(density_fit_av,PW_length_new,err_density_fit_av,err_density_fit_av,err_neg_PW_length_new,err_pos_PW_length_new,{'rx','r','r'})
%plot(density_fit_av,PW_length_new,'o',dens,fit2)
plot(dens,fit2,'r')
hold off
xlim([1.8e18 4e18])

%density from PW
lambda_pPW =2*pi*c*sqrt((eps*m_e)./(density_PW_new2*1e6*q^2));
p3 = polyfit(density_PW_new2,lambda_pPW,2);
fit3 = p3(1)*dens.^2+p3(2)*dens+p3(3);
p4 = polyfit(density_PW_new2,PW_length_new2,2);
fit4 = p4(1)*dens.^2+p4(2)*dens+p4(3);

figure(13)
plot(dens,lambda_p_calc,'b--')
hold on
errorbarxy(density_fit_av_new2,PW_length_new2,err_density_fit_av_new2,err_density_fit_av_new2,err_PW_length_new2,err_PW_length_new2,{'rx','r','r'})
%plot(density_fit_av,PW_length_new,'o',dens,fit2)
plot(3e18,PW_length_sim_ao2,'dg')
plot(3e18,PW_length_sim_ao4,'dg')
hold off
xlim([2e18 4.5e18])
