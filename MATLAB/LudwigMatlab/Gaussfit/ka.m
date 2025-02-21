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

x = (-150:150)'*3.676e-6;
xp = (1:150)'*3.676e-6;
xn = (-150:-1)'*3.676e-6;
xa = (1:68)'*3.676e-06;
xb = (69:350)'*3.676e-06;
r1 = 50*3.676e-06;
r2 = 120*3.676e-06;
delta_r = abs(r1 - r2);


%gaussexp = fittype('')
%superg = fittype('a*exp(-(xa.^4)/(2*d^4))','independent',{'xa'},'coefficients',{'a','d'});
%superg = fittype('7.14e6*(1/d^4)*2*xa.^3.*a*exp(-(xa.^4)/(2*d^4))','independent',{'xa'},'coefficients',{'a','d'});
load('supergaussfit.mat');
load('trapez_xa.mat');
load('trapez_xb.mat');
load('trapez_2sec.mat');
phase = load('O:\Ludwig\Matlab\Trapezfit\Test\16bar_nowafer_1078-1004_phase.asc');
phase_p = phase(151:300);
phase_xa = phase(151:200);
phase_xb = phase(201:270);
%sug = fit(xa,phase,gaussian4fit);

Coeffs_a = coeffvalues(trapez_xa);
a_a = Coeffs_a(1);
delta_r_a = Coeffs_a(2);
r1_a = Coeffs_a(3);
r2_a = Coeffs_a(4);
x1_a = Coeffs_a(5);
x2_a = Coeffs_a(6);

%Coeffs_b = coeffvalues(trapez_xb);
%a_b = Coeffs_b(1);
%delta_r_b = Coeffs_b(2);
%r1_b = Coeffs_b(3);
%r2_b = Coeffs_b(3);
%x1_b = Coeffs_b(5);
%x2_b = Coeffs_b(4);
%r1_b = abs(delta_r_b - r2_b);
%trapez_xa_curve = a_a*7.14e6*(2*x1_a+1/delta_r_a*(xa.^2.*log((r2_a+x2_a)/(r1_a+x1_a))-r2_a*x2_a-r1_a*x1_a+2*r2_a*x1_a));
%trapez_xb_curve = a_b*7.14e6*(1/delta_r_b.*(xb.^2.*log((r2_b+x2_b)./(abs(xb)))-r2_b*x2_b));

%refrac_a = 2*n_c*abs(a_a);
%refrac_b = 2*n_c*abs(a_b)*(xb-r2)./(r1-r2);

%test(1:31) = 0;
%test(32:101) = refrac_b;
%test(102:151) = refrac_a;
%test(152:301) = fliplr(test(1:150));
%test(51:120) = flipud(refrac_b);
%MyCoeffs2 = coeffvalues(sug);
%a1 = MyCoeffs2(1);
%d = MyCoeffs2(2);
%refrac2 = 2*n_c*(1/d^4)*2.*xa.^3.*abs(a1).*exp(-(xa.^4)./(2*d^4));
%fit = a1*exp(-(xa.^4)/(2*d^4));
%refrac2 = 2*n_c*abs(a1)*exp(-xa.^4/(2*d^4));
%r1 = MyCoeffs2(2);
%r2 = MyCoeffs2(3);

Coeffs_super = coeffvalues(supergaussfit);
a = Coeffs_super(1);
d = Coeffs_super(2);
supergauss_curve = a*exp(-(x./d).^4);
gauss_grad = gradient(supergauss_curve);
%test = -4*a*(1/d^4)*x.^3.*exp(-(x./d).^4);
fun = @(x,r) (gradient( a*exp(-(x./d).^4))).*1/sqrt(x.^2-r^2);
f_r = -2*n_c*(1/pi)*integral(@(x,r)fun(xp,0),0,inf,'ArrayValued',true);

Coeffs_2sec = coeffvalues(trapez_2sec);
a = Coeffs_2sec(1);
r1 = Coeffs_2sec(2);
r2 = Coeffs_2sec(3);
trapez2sec_curve_a = a*7.14e6*(2*sqrt(abs(r1^2-x.^2))+1/(r1-r2)*(x.^2.*log((r2+sqrt(abs(r2^2-x.^2)))./(r1+sqrt(abs(r1^2-x.^2))))-r2*sqrt(abs(r2^2-x.^2))-r1*sqrt(abs(r1^2-x.^2))+2*r2*sqrt(abs(r1^2-x.^2))));
trapez2sec_curve_b = a*7.14e6*1/(r1-r2).*(x.^2.*log((r2+sqrt(abs(r2^2-x.^2)))./(abs(x)))-r2*sqrt(abs(r2^2-x.^2)));

trap_curve = zeros(600,1);
trap_curve(232:368) = trapez2sec_curve_a(82:218);
trap_curve(164:231) = trapez2sec_curve_b(15:82);
trap_curve(368:436) = trapez2sec_curve_b(219:287);
refrac_a = 2*n_c*abs(a);
refrac_b = 2*n_c*abs(a)*(xb-r2)./(r1-r2);
refrac_curve = zeros(600,1);
refrac_curve(301:368) = refrac_a;
%refrac_curve(164:231) = refrac_b(15:82);
refrac_curve(368:436) = refrac_b(1:69);

