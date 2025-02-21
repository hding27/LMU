function Plot_eSpecAOI(exportEnable)
%%
if nargin == 0
	exportEnable = 0;
end

load('O:\Electrons\Programs\Spectra\eSpecLowE_GPTCalibration_20170724.mat')
pt = specCal.pointing;
en = specCal.ene;
pos = specCal.pos;
figure(37)
plot(en*1e-6, pos, 'LineWidth', 1.6);

FontSize = 18;
xlabel('electron energy [MeV]','FontSize',FontSize)
ylabel('position on screen [m]','FontSize',FontSize)
legend([num2str(pt(1)) ' degree'],...
    ['  ' num2str(pt(2)) ' degree'],...
    ['  ' num2str(pt(3)) ' degree'],...
    ['   ' num2str(pt(4)) ' degree'],...
    ['   ' num2str(pt(5)) ' degree'],...
    ['   ' num2str(pt(6)) ' degree'],...
    'Location', 'northwest')
box on
ylim([0,1])
set(gca,'FontSize',FontSize);
set(gcf, 'Color', 'w');
if(exportEnable)
    export_fig fig_eSpecAOI.pdf -q101
end
end