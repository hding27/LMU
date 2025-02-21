%% Plot the density profile
load('Density.mat')

% The units of position and density are micrometer and electrons/cm^3,
% respectively.

% Positive position is in the direction of the laser propagation, i.e. the
% longer jet with the shock is the first stage. The absolute position
% offset is random.

% The noise is most probably artifacts in the reconstruction of the
% density.

% The density of the 1mm jet is measured for 5 bar pressure, the
% experiments were done with 2,3 and 4 bar. Linear scaling of density to
% pressure can be assumed.

figure(1)
plot(Density.Nozzle1mm.Position, ...
     Density.Nozzle1mm.Density, ...
     Density.Nozzle5mm.Position, ...
     Density.Nozzle5mm.Density)
legend('1mm Nozzle @ 5 bar', '5mm Nozzle @ 15 bar');
ylim([0 7.2e18]);
xlim([-7000 4000]);
title('Density profile on Dec, 2nd', 'interpreter', 'latex', 'fontsize', 16);
xlabel('Position in $[\mu m]$', 'interpreter', 'latex', 'fontsize', 16);
ylabel('Density in $[cm^{-3}]$', 'interpreter', 'latex', 'fontsize', 16);