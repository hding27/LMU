%clear all
addpath(genpath('O:\Ludwig\Matlab'))

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

x = (-150:150)'*3.676e-06;
xq = (-200:1:200)'*3.676e-06;

%gauss = fittype('(1/1.444e+21)*a.*7.1400e06*sig.*sqrt(pi/2)*exp(-(x^2)/(2*sig^2))','dependent',{'phase'},'independent',{'x'},'coefficients',{'a','sig'});

gauss = fittype('2*a.*7.1400e06*sig.*sqrt(pi/2)*exp(-(x^2)/(2*sig^2))','dependent',{'phase'},'independent',{'x'},'coefficients',{'a','sig'});

files = dir('O:\Ludwig\Matlab\Gaussfit\Test\20160908_10bar_nowafer_nopp3_1220-1005_phase.asc');
for i=1:length(files)
    A = dlmread(files(i).name);
 
    gaussfit = fit(x,A,gauss);
    MyCoeffs = coeffvalues(gaussfit);
    a = MyCoeffs(1);
    sig = MyCoeffs(2);
    %refrac = abs(a)*exp(-(x.^2)/(2*sig^2));
    refrac = 2*n_c*abs(a)*exp(-(x.^2)/(2*sig^2));
    gaussextra(:,i) = interp1(x,refrac,xq,'spline','extrap');
    
    
    esum(i) = trapz(gaussextra(:,i)); 
    lin(i) = gaussextra(200,i);
    
    fullw(:,1) = xq;
    fullw(:,2) = gaussextra(:,i);
    FWHM(i) = fwhm(fullw);
end



figure(14);
mesh(1:length(files),xq,gaussextra)

figure(15)
subplot(2,2,1);
plot(esum)
subplot(2,2,2);
plot(lin)
subplot(2,2,3)
plot(FWHM)




