
%addpath(genpath('O:\Ludwig\Matlab'))

phase_lo2 = load('O:\Ludwig\Matlab\Thesis\8.9.16_long_lineout\20160908_14bar_nowafer_full_lineout.asc');
%phase_lo = load('O:\Ludwig\Matlab\Thesis\8.9.16_long_lineout\8.9.16_14bar_long_lineout.asc');
%measured_dens = [5.14e17 7.86e17 1.57e18 2.57e18 3.14e18 3.81e18 3.90e18 3.90e18 3.79e18 3.77e18 3.68e18 3.59e18 3.57e18 3.58e18 3.50e18 3.43e18 3.39e18 3.17e18 2.61e18 2.04e18];
measured_dens = [5.14e17 7.86e17 1.57e18 2.57e18 3.14e18 3.81e18 3.90e18 3.90e18 3.79e18 3.77e18 3.79e18 3.68e18 3.69e18 3.65e18 3.63e18 3.49e18 3.39e18 3.25e18 2.61e18 2.07e18]-5.14e17;
measured_dens_newclipped = [5.0e17 7.5e17 1.6e18 2.5e18 3.3e18 3.6e18 3.80e18 3.70e18 3.7e18 3.7e18 3.6e18 3.5e18 3.5e18 3.5e18 3.4e18 3.3e18 3.2e18 3.1e18 2.5e18 2.0e18]-5.0e17;

err_dens_newclipped = [0.074 0.081 0.076 0.068 0.073 0.077 0.081 0.071 0.074 0.079 0.061 0.053 0.051 0.056 0.051 0.050 0.048 0.051 0.053 0.042]
err_values = measured_dens_newclipped.*err_dens_newclipped;

%load('lin.mat');
%lin(1,1) = 0;
%x_phase = linspace(-2.26,1.05,901);
%x_lin = linspace(1,20,901);
%lin_interp = interp1(measured_dens,x_lin);
%lin_interp(1,1) = 0;
x_err = linspace(-2.15,0.78,20);

x_phase2 = linspace(-2.15,0.78,799);
x_lin2 = linspace(1,20,799);
lin_interp2 = interp1(measured_dens_newclipped,x_lin2);

x_41step = 1:42:799;
zerox = zeros(1,799);
zerox(x_41step) = measured_dens_newclipped;
%figure(7)
%subplot(2,1,1)
%plot(x_phase,phase_lo)

%subplot(2,1,2)
%plot(x_phase,lin_interp)

figure(8)

plotyy(x_phase2,phase_lo2,x_phase2,lin_interp2)
hold on

figure(9);
%x=[0:1:10];
[AX,H1,H2] = plotyy(x_phase2,phase_lo2,x_phase2,lin_interp2)
set(H2(1), 'Color', 'r','LineWidth',1.5); 
set(H1(1), 'Color', 'b','LineWidth',1.5); 
set(AX(1),'fontsize',18);
set(AX(1),'YLim',[0 6.2])
set(AX(1),'XLim',[-2.2 0.8])
set(AX(1),'YTick',[0:1:6.2])
set(AX(1),'Ycolor','b');
set(AX(2),'YLim',[0 3.5e18])
set(AX(2),'XLim',[-2.2 0.8])
set(AX(2),'fontsize',18);
set(AX(2),'YTick',[0:1e18:3.5e18])
set(AX(2),'Ycolor','r');
ylabel('phase shift [rad]')
set(get(AX(2),'Ylabel'),'string','electron density [cm^{-3}]')

figure(10);
%x=[0:1:10];
hold on
errorbar(x_err,measured_dens_newclipped,err_values,'rx');
[AX,H1,H2] = plotyy(x_phase2,phase_lo2,x_phase2,lin_interp2)
set(H2(1), 'Color', 'r','LineWidth',1.5); 
set(H1(1), 'Color', 'b','LineWidth',1.5); 
set(AX(1),'fontsize',18);
set(AX(1),'YLim',[0 6.2])
set(AX(1),'XLim',[-2.2 0.8])
set(AX(1),'YTick',[0:1:6.2])
set(AX(1),'Ycolor','b');
set(AX(2),'YLim',[0 3.5e18])
set(AX(2),'XLim',[-2.2 0.8])
set(AX(2),'fontsize',18);
set(AX(2),'YTick',[0:1e18:3.5e18])
set(AX(2),'Ycolor','r');
ylabel('phase shift [rad]')
set(get(AX(2),'Ylabel'),'string','electron density [cm^{-3}]')
hold off
