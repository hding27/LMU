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

x = (50:120)'*3.676e-06;
r1 = 50*3.676e-06;
r2 = 120*3.676e-06;
delta_r = abs(r1 - r2);
x1 = sqrt(r1^2-x.^2);
x2 = sqrt(r2^2-x.^2);

trapfit2 = fittype('a.*7.1400e06*((1/(70*3.676e-06))*(x^2.*log((120*3.676e-06+sqrt((120*3.676e-06)^2-x.^2))./(abs(x))) - 120*3.676e-06*sqrt((120*3.676e-06)^2-x.^2)))','independent',{'x'},'coefficients',{'a'});

phase = load('O:\Ludwig\Matlab\Trapezfit\Test\phasetest.asc');


trapez2 = fit(x,phase(201:271,1),trapfit2);
MyCoeffs3 = coeffvalues(trapez2);
a2 = MyCoeffs3(1);

refrac3 = 2*n_c*abs(a2)*(x-r2)./(r1-r2)

   
for i = 1:50
    while i <=50;
        
        trapfit1 = fittype('a.*7.1400e06*(2*sqrt((50*3.676e-06)^2-x.^2) + (1/(70*3.676e-06))*(x^2.*log((120*3.676e-06+sqrt((120*3.676e-06)^2-x.^2))./(50*3.676e-06+sqrt((50*3.676e-06)^2-x.^2))) - 120*3.676e-06*sqrt((120*3.676e-06)^2-x.^2) -50*3.676e-06*sqrt((50*3.676e-06)^2-x.^2) + 2*120*3.676e-06*sqrt((50*3.676e-06)^2-x.^2)))','independent',{'x'},'coefficients',{'a'});

        trapez1 = fit(x(i),phase(151:200,1),trapfit1);
        MyCoeffs2 = coeffvalues(trapez1);
        a = MyCoeffs2(1);
        %refrac1 = 2*n_c*abs(a);
    end

   if 50 < i <= 121;
        
        trapfit2 = fittype('a.*7.1400e06*((1/(70*3.676e-06))*(x^2.*log((120*3.676e-06+sqrt((120*3.676e-06)^2-x.^2))./(abs(x))) - 120*3.676e-06*sqrt((120*3.676e-06)^2-x.^2)))','independent',{'x'},'coefficients',{'a'});

        trapez2 = fit(x(i),phase(201:271,1),trapfit2);
        MyCoeffs3 = coeffvalues(trapez2);
        a = MyCoeffs3(1);
        refrac2(:,i) = 2*n_c*abs(a2)*(x-r2)./(r1-r2);
        
    end
    
end


