%clear all

%addpath(genpath('O:\Ludwig\Matlab'))

lambda = 880e-9;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);
M = 3.676e-6; %8.9.16
%M = 3.472e-6; %2.12.16

x_axis = (-299:1:300)*3.676e-3;
%x_axis = (-299:1:300)*3.472e-3;


meassured_phase = (load('O:\Ludwig\Matlab\Thesis\8.9.16_shock_lineout\lineout_for_fit\1418_12bar_middle_after_shock.asc'))';

%meassured_phase = (load('O:\Ludwig\Matlab\Thesis\8.9.16_long_lineout\lineouts_41pxstep_new_forthesis\20160908_14bar_nowafer_phasemapAbel0784-1016_32_264.asc'))';
%meassured_phase = (load('O:\Ludwig\Matlab\Thesis\8.9.16_pressure_scan\18bar\IDEA_clip_scan\20160908_007_1296_18bar_lower_channel_clip8.asc'))';
%meassured_phase = (load('O:\Ludwig\Matlab\20121202\density_gradient\20161202_mean_5bar_1stjet_x=802px_4ps_phase.asc'))';
%meassured_phase = (load('D:\Uni\Masterarbeit\Ludwig\Matlab\Thesis\8.9.16_pressure_scan\18bar\IDEA_clip_scan\20160908_007_1296_18bar_lower_channel_clip8.asc'))';
test = load('edense_lineout_14bar_+1.5ps.mat');
edense_abel175 = load('20121202_17.5bar_edense_abel.mat');
edense_abel15 = load('20121202_15bar_edense_abel.mat');
edense_abel125 = load('20121202_12.5bar_edense_abel.mat');
edense_abel10 = load('20121202_10bar_edense_abel.mat');
edense_abel75 = load('20121202_7.5bar_edense_abel.mat');
edense_abel5 = load('20121202_5bar_edense_abel.mat');

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
n_average = sum(n)/length(n);
n_grad = (max(n)-min(n))/(2*r*1000);
phase = w_l/(2*c*n_c).*n.*x;

res = sqrt(sum((meassured_phase' - phase').^2)/sum(meassured_phase.^2));
n_at_PW = n(1,length(phase)-133);

[M,I] = max(phase);
x_norm = ((1:length(meassured_phase)) - I)*3.676e-3;  %8.9.16
%x_norm = ((1:length(meassured_phase)) - I)*3.472e-3;   %2.12.16
x_grad = linspace(min(n),max(n),length(meassured_phase));
n_max = x_grad(1,I);
y_density = 0:n_max./1e18;


figure(5)
plot(x_norm,meassured_phase,x_norm,phase)


figure(6);
ax1 = gca;
ax1_pos = ax1.Position;
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right')
plot(x_norm,meassured_phase)
plot(x_norm,phase,'parent',ax2,'Color','k')

figure(7);
subplot(1,2,1)
plot(x_axis,edense_abel5.edens,'b-','LineWidth', 1.5)
xlim([-0.6 0.61]);
xlabel('radius [mm]','Interpreter','tex','fontsize',18);
ylabel('electron density [cm^{-3}]','Interpreter','tex','fontsize',18);
subplot(1,2,2)
ax1 = gca;
hold on
plot(x_norm,meassured_phase,'b-','LineWidth', 1.5);

xlabel('radius [mm]','Interpreter','tex','fontsize',18);
ylabel('phase shift [rad]','Interpreter','tex','fontsize',18);


ax2 = axes('Position',get(ax1,'Position'),...
       'XAxisLocation','top',...
       'YAxisLocation','right',...
       'Color','none',...
       'YTickLabel',[],...
       'XColor','k');
xlabel('electron density [x10^{18}cm^{-3}]','Interpreter','tex','fontsize',18);
ylim([0 1]);
linkaxes([ax1 ax2],'y');
hold on
plot(x_norm,phase,'r','Parent',ax2, 'LineWidth', 1.5);
hold off


