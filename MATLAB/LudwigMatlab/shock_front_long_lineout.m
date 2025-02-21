clear all
%addpath(genpath('O:\Ludwig\Matlab'))

shock_lin = load('O:\Ludwig\Matlab\Thesis\8.9.16_shock_lineout\20160908_1418_12bar_shock_long_lineout.asc');
shock_phase = load('O:\Ludwig\Matlab\Thesis\8.9.16_shock_lineout\20160908_1418nowafer_10bar_phase_final3.asc');



 for i = 1:440
 data_cut(i,:) = shock_phase(769+i,707:1590);
 end

x_position = linspace(-2.1,1.09,874);
y = (-236:1:205)*3.676e-3;
y2 = linspace(0,4.34,10);

figure(1); 
subplot(2,1,1)
imagesc(x_position,y,data_cut);
colormap('jet');
xlabel('position [mm]','Interpreter','tex','fontsize',16);
ylabel('radius [mm]','Interpreter','tex','fontsize',16);

subplot(2,1,2)
%plot(x_position,shock_lin)
ax1 = gca;
hold on
plot(x_position,shock_lin,'b','LineWidth',1.5);
xlim([-2.1 1.09]);
xlabel('position [mm]','Interpreter','tex','fontsize',16);
ylabel('phase shift [rad]','Interpreter','tex','fontsize',16);
ax2 = axes('Position',get(ax1,'Position'),...
       'XAxisLocation','bottom',...
       'YAxisLocation','right',...
       'Color','none',...
       'YTickLabel',[0 1.17 2.34 3.51 4.68 5.85],...     
       'XColor','k');
      

ylabel('electron density [10^{18}cm^{-3}]','Interpreter','tex','fontsize',16);
ylim([0 5]);
xlim([-2.1 1.09]);
linkaxes([ax1 ax2],'y');
hold on
plot(x_position,shock_lin,'r','Parent',ax2, 'LineWidth', 1.5);
hold off