
lambda = 880e-9;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;

meassured_phase = (load('20161202_1823_17.2bar_1stjet_phase.asc'))';  %20161202_1945_14bar_1stjet_phase.asc,n=3.4, 2,r=0.0005
                                                                    %20161202_1823_17.2bar_1stjet_phase.asc,n=4,
                                                                    %2.8,r=0.00046
                                                                  
n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);
const = ((2*pi*3e8)/880e-9)/(2*3e8*1.444e21);
n = linspace(4,2.8,length(meassured_phase))*10^18;
phi = linspace(0,180,length(meassured_phase))*(pi/180);
r = 0.00046;
x = 2*r*sin(phi);
xp = 1:length(meassured_phase);
N = 1 - n./(2*n_c);
phase = w_l/(2*c*n_c).*n.*x;


fit = fittype(' 2.4723e-15*n*a*x','independent',{'x'},'coefficients',{'a','n'});

%trapfit2 = fittype('a.*7.1400e06*((1/(80*3.676e-06))*(xb.^2.*log((130*3.676e-06+sqrt((130*3.6','independent',{'xb'},'coefficients',{'a'});

%trapez2 = fit(xb,phase(201:270,1),trapfit2);

%phase_fit = fit(1:length(meassured_phase),meassured_phase(1,:),fit)

figure(2)
plot(xp,meassured_phase,xp,phase)

%%


lambda = 880e-9;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);

meassured_phase = (load('20121202_1939_1stjet_14bar.asc'))';

xp = 1:length(meassured_phase);
phi = linspace(0,180,length(meassured_phase))*(pi/180);
r = 0.00046;
x = 2*r*sin(phi);
d = zeros(40,40);
for i = 1:35
    n1 = 3 + 0.1*i;
    for j = 1:25
        n2 = 1 + 0.1*j;
        n_grad = linspace(n1,n2,length(meassured_phase))*10^18;
        phase = w_l/(2*c*n_c).*n_grad.*x;
        
        for k = 1:length(meassured_phase)
        r(k) = (meassured_phase(k) - phase(k))^2;
        end
        
        d(i,j) = sum(r);
        
    end
end
[l,p] = find(d==min(min(d(1:35,1:25))));
n = linspace(3 + 0.1*l, 1 + 0.1*p,length(meassured_phase))*10^18;
phase = w_l/(2*c*n_c).*n.*x;

figure(3)
plot(xp,meassured_phase,xp,phase)





