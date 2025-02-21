clear all
addpath(genpath('O:\Ludwig\Matlab'))

lambda = 880e-9;
k = (2*pi)/lambda;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);

x = (-200:199)'*3.676e-6;
xp = (1:150)'*3.676e-6;
xa = (1:50)'*3.676e-06;
xb = (51:150)'*3.676e-06;
%r1 = 50*3.676e-06;
%r2 = 120*3.676e-06;
%delta_r = abs(r1 - r2);

load('supergaussfit.mat');
load('trapez_xa.mat');
load('trapez_xb.mat');
load('trapez_xa2.mat');
load('comp.mat');
load('comp_nopp3');
phase = load('O:\Ludwig\Matlab\Gaussfit\Test\20160908_10bar_nowafer_nopp3_1220-1005_phase.asc');
%phase = load('O:\Ludwig\Matlab\Trapezfit\Test\phasetest.asc');
phase_p = phase(151:300);
phase_xa = phase(151:190);
phase_xb = phase(191:300);
phase_xb2(1:110) = phase(191:300);

%trapfit1 = fittype('(xp<=41*3.676e-6)*a.*7.14e06*(2*sqrt((41*3.676e-6)^2-xp.^2) + (1/(41*3.676e-6-r2))*(xp.^2.*log((r2+sqrt((r2)^2-xp.^2))./(41*3.676e-6+sqrt((41*3.676e-6)^2-xp.^2))) - r2*sqrt((r2)^2-xp.^2) -41*3.676e-6*sqrt((41*3.676e-6)^2-xp.^2) + 2*r2*sqrt((41*3.676e-6)^2-xp.^2)))+(41*3.676e-6<xp<=r2)*a.*7.1400e06*((1/((41*3.676e-6)-r2))*(xp.^2.*log((r2+sqrt((r2)^2-xp.^2))./(abs(xp))) - r2*sqrt((r2)^2-xp.^2)))+(xp>r2)*0','independent',{'xp'},'coefficients',{'a','r2'});
%trapfit1 = fittype('2*a.*7.14e6*sqrt((50*3.676e-6)^2 - xa.^2)','independent',{'xa'},'coefficients',{'a'});
%trapfit2 = fittype('a.*7.1400e06*((1/(80*3.676e-06))*(xb.^2.*log((130*3.676e-06+sqrt((130*3.676e-06)^2-xb.^2))./(abs(xb))) - 130*3.676e-06*sqrt((130*3.676e-06)^2-xb.^2)))','independent',{'xb'},'coefficients',{'a'});


%xa = (1:50)'*3.676e-06;
%xb = (51:120)'*3.676e-06;
%r1 = 50*3.676e-06;
%r2 = 120*3.676e-06;
%delta_r = abs(r1 - r2);

%superg = fittype('(1/d^4)*2*xa.^3.*a*exp(-xa.^4/(2*d^4))','independent',{'xa'},'coefficients',{'a','d'});

%trapfit1 = fittype('a.*7.14e06*(2*sqrt(r1^2-xa.^2) + (1/abs(120*3.676e-6 - r1))*(xa^2.*log((120*3.676e-6+sqrt((120*3.676e-6)^2-xa.^2))./(r1+sqrt((r1)^2-xa.^2))) - 120*3.676e-6*sqrt((120*3.676e-6)^2-xa.^2) -r1*sqrt((r1)^2-xa.^2) + 2*120*3.676e-6*sqrt((r1)^2-xa.^2)))','independent',{'xa'},'coefficients',{'a','r1'});
%trapfit2 = fittype('a.*7.1400e06*((1/(120*3.676e-6 - r1))*(xb^2.*log((120*3.676e-6+sqrt((120*3.676e-6)^2-xb.^2))./(abs(xb))) - 120*3.676e-6*sqrt((120*3.676e-6)^2-xb.^2)))','independent',{'xb'},'coefficients',{'a','r1'});

%phase = load('O:\Ludwig\Matlab\Gaussfit\Test\16bar_nowafer_1078-1004_phase.asc');
%options = fitoptions(trapfit1);
%options.Lower = [0 0 ];
%options.Upper = [Inf 4e-04];
%[trapez,gof] = fit(xp,phase(151:300,1),trapfit1);

%MyCoeffs2 = coeffvalues(trapez);
%a1 = MyCoeffs2(1);
%refrac2 = 2*n_c*abs(a1)
%r1 = MyCoeffs2(2);
%r2 = MyCoeffs2(2);



%trapez2 = fit(xb,phase(201:270,1),trapfit2);
MyCoeffs3 = coeffvalues(trapez_xa2);
a2 = MyCoeffs3(1);
r1_2 = MyCoeffs3(2);
r2_2 = MyCoeffs3(3);
x_r1 = (1:102)'*3.676e-6;
refrac2 = n_c*2*a2;
%refrac3 = 2*n_c*abs(a1)*(xb-r2)./((41*3.676e-6)-r2);
zzz = (x_r1<r1_2)*a2.*7.14e06.*(2.*sqrt((r1_2)^2-x_r1.^2) + (1/(r1_2-r2_2))*(x_r1.^2.*log((r2_2+sqrt((r2_2)^2-x_r1.^2))./(r1_2+sqrt((r1_2)^2-x_r1.^2))) - r2_2*sqrt((r2_2)^2-x_r1.^2) -r1_2*sqrt((r1_2)^2-x_r1.^2) + 2*r2_2*sqrt((r1_2)^2-x_r1.^2)));
%zzz2 = a1.*7.1400e06*((1/((41*3.676e-6)-r2))*(xp.^2.*log((r2+sqrt((r2)^2-xp.^2))./(abs(xp))) - r2*sqrt((r2)^2-xp.^2)));

test = zeros(600,1);
test(300-int16(r1_2/3.676e-6):300+int16(r1_2/3.676e-6)) = refrac2;

test2 = zeros(150,1);
test2(1:102) = zzz;

