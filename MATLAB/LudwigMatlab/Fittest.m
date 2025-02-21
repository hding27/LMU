lambda = 880e-9;
k = (2*pi)/lambda;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
M = 1/0.274;


n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);
phase = load('phaseshift_test.asc');
x = (-150:150)'*3.676e-06;

gauss = fittype('2*a.*7.1400e06*sig.*sqrt(pi/2)*exp(-(x^2)/(2*sig^2))','dependent',{'phase'},'independent',{'x'},'coefficients',{'a','sig'});
gaussfit = fit(x,phase,gauss);

MyCoeffs = coeffvalues(gaussfit);
a = MyCoeffs(1);
sig = MyCoeffs(2);

refrac = 2*n_c*abs(a)*exp(-(x.^2)/(2*sig^2));

%padd = zeros(401,1);
%padd(50:350,1) = refrac(:,1);
xq = (-200:1:200)'*3.676e-06;
gaussextra = interp1(x,refrac,xq,'spline','extrap');

figure(13);
plot(gaussfit,x,phase)

figure(14);
plot(xq,gaussextra)

