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

x = (0:49)'*3.676e-06;
r1 = 50*3.676e-06;
r2 = 120*3.676e-06;
delta_r = abs(r1 - r2);
x1 = sqrt(r1^2-x.^2);
x2 = sqrt(r2^2-x.^2);


trapfit1 = fittype('a.*7.14e06*(2*sqrt((50*3.676e-06)^2-xa.^2) + (1/(70*3.676e-06))*(xa^2.*log((120*3.676e-06+sqrt((120*3.676e-06)^2-xa.^2))./(50*3.676e-06+sqrt((50*3.676e-06)^2-xa.^2))) - 120*3.676e-06*sqrt((120*3.676e-06)^2-xa.^2) -50*3.676e-06*sqrt((50*3.676e-06)^2-xa.^2) + 2*120*3.676e-06*sqrt((50*3.676e-06)^2-xa.^2)))','independent',{'xa'},'coefficients',{'a'});

%gauss_trapez1 = fittype('2*a.*7.14e+06*sig.*sqrt(pi/2)*exp(-(x^2)/(2*sig^2))','dependent',{'phase'},'independent',{'x'},'coefficients',{'a','sig'});
  
phase = load('O:\Ludwig\Matlab\Trapezfit\Test\phasetest.asc');

trapez = fit(x,phase(151:200,1),trapfit1);
MyCoeffs2 = coeffvalues(trapez);
a = MyCoeffs2(1);

refrac2 = 2*n_c*abs(a)



