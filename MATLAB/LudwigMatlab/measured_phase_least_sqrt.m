

%addpath(genpath('O:\Ludwig\Matlab'))


lambda = 880e-9;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);
%M = 3.676e-6; %8.9.16
M = 3.472e-6; %2.12.16

%x_axis = (-299:1:300)*3.676e-3;
x_axis = (-299:1:300)*3.472e-3;

%meassured_phase = (load('O:\Ludwig\Matlab\Thesis\8.9.16_pressure_scan\upper_channel\20160908_8bar_nowafer_upperchannel_lineout_nolintilt.asc'))';
meassured_phase = (load('O:\Ludwig\Matlab\20121202\density_gradient\20161202_mean_17.5bar_1stjet_x=802px_4ps_phase.asc'))';
%meassured_phase = (load('D:\Uni\Masterarbeit\Ludwig\Matlab\Thesis\8.9.16_pressure_scan\14bar\20160908_012_1377_14bar_lower_channel_phase_map_x=920_+1.5ps_nolintilt.asc'))';
edense_abel = load('20121202_17.5bar_edense_abel.mat');


xp = 1:length(meassured_phase);
phi = linspace(0,180,length(meassured_phase))*(pi/180);
r = 0.5 * length(meassured_phase) * M;
x = 2*r*sin(phi);
d = zeros(100,100);
for i = 1:100
    
    for j = 1:100
        
        n_grad = linspace(0.1*i,0.1*j,length(meassured_phase))*10^18;
        phase = w_l/(2*c*n_c).*n_grad.*x;
        
        for k = 1:length(meassured_phase)
        res(k) = (meassured_phase(k) - phase(k))^2;
        end
        
        d(i,j) = sum(res);
        
    end
end
[l,p] = find(d==min(min(d(:))));
n = linspace(0.1*l,0.1*p,length(meassured_phase))*10^18;
phase = w_l/(2*c*n_c).*n.*x;

[M,I] = max(phase);
%x_norm = ((1:length(meassured_phase)) - I)*3.676e-3;  %8.9.16
x_norm = ((1:length(meassured_phase)) - I)*3.472e-3;   %2.12.16
x_grad = linspace(min(n),max(n),length(meassured_phase));
n_max = x_grad(1,I);
y_density = 0:n_max./1e18;

a = sum(meassured_phase);
b = sum(phase);
h = a/b;

res = sqrt(sum((meassured_phase' - phase').^2)/sum(meassured_phase.^2));

figure(5)
subplot(1,2,1)
plot(-299:300,edense_abel.edens)
subplot(1,2,2)
plot(x_norm,meassured_phase,x_norm,phase)