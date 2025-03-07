addpath(genpath('O:\Ludwig\Matlab'))

lambda = 880e-9;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);
M = 3.472e-6;
phase = zeros(10,400);
%meassured_phase = (load('20161202_mean_5bar_1stjet_x=802px_4ps_phase.asc'))';

files = dir('O:\Ludwig\Matlab\20121202\shockfront\20161202_006_1939_14bar_shockfront_rightside_lineout_upper_channel_phase.asc');
for u=1:1%length(files)
    A = dlmread(files(u).name);

xp = 1:length(A);
phi = linspace(0,180,length(A))*(pi/180);
r = 0.5 * length(A) * M;
x = 2*r*sin(phi);
d = zeros(100,100);
for i = 1:100
    
    for j = 1:100
        
        n_grad = linspace(0.1*i,0.1*j,length(A))*10^18;
        pha = w_l/(2*c*n_c).*n_grad.*x;
        
        for k = 1:length(A)
        res(k) = (A(k) - pha(k)).^2;
        end
        
         %bg(i) = min(cell2mat(A(i)));
        
        d(i,j) = sum(res);
        
    end
end
[l,p] = find(d==min(min(d(:))));
n = linspace(0.1*l,0.1*p,length(A)).*10^18;

middle(u) = length(A) / 2;
phase(u,200 - floor(middle(u)):199 + length(A) - floor(middle(u))) = w_l/(2*c*n_c).*n.*x;

    


end
%figure(5)
%plot(xp,meassured_phase,xp,phase)