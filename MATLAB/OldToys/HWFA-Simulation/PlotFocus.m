%% Plot the HDR focus profile
load('Focus.mat')

% Positions (Focus.X and Focus.Y) are in micrometer, the Intensity in
% W/cm^2

% Focus.Intensity is the intensity in focus, Focus.IntensityMinus5mm and
% Focus.IntensityPlus5mm the intensity 5mm out of focus. Plus 5mm is in the
% direction of the laser propagation.

% The intensity in focus is a combination of the measurement with three
% different filters (ND0, ND1, ND2, ND3) to have a higher dynamic range.

% There are two ghost images south and north-east.

figure(2)
imagesc(Focus.X, Focus.Y, log10(abs(Focus.Intensity)));
xlabel('$x \; [\mu m]$', 'interpreter', 'latex', 'fontsize', 16);
ylabel('$y \; [\mu m]$', 'interpreter', 'latex', 'fontsize', 16);
title('Focus on Dec, 2nd', 'interpreter', 'latex', 'fontsize', 16);
colormap('jet');
c = 10.^(12:19);
h = colorbar('YTick',log10(c),'YTickLabel',c);
ylabel(h,'$I \; [Wcm^-2]$', 'interpreter', 'latex', 'fontsize', 16)

figure(3)
imagesc(Focus.X, Focus.Y, log10(abs(Focus.IntensityPlus5mm)));
xlabel('$x \; [\mu m]$', 'interpreter', 'latex', 'fontsize', 16);
ylabel('$y \; [\mu m]$', 'interpreter', 'latex', 'fontsize', 16);
title('Focus on Dec, 2nd, $+5mm$', 'interpreter', 'latex', 'fontsize', 16);
colormap('jet');
c = 10.^(12:19);
h = colorbar('YTick',log10(c),'YTickLabel',c);
ylabel(h,'$I \; [Wcm^-2]$', 'interpreter', 'latex', 'fontsize', 16)

figure(4)
imagesc(Focus.X, Focus.Y, log10(abs(Focus.IntensityMinus5mm)));
xlabel('$x \; [\mu m]$', 'interpreter', 'latex', 'fontsize', 16);
ylabel('$y \; [\mu m]$', 'interpreter', 'latex', 'fontsize', 16);
title('Focus on Dec, 2nd, $-5mm$', 'interpreter', 'latex', 'fontsize', 16);
colormap('jet');
c = 10.^(12:19);
h = colorbar('YTick',log10(c),'YTickLabel',c);
ylabel(h,'$I \; [Wcm^-2]$', 'interpreter', 'latex', 'fontsize', 16)

