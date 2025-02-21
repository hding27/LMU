% 5fs gaussian pulse centered at t0 = 1fs and f0 = 300THz
p = gaussianPulse('units', 'fs', 'fwhm', 5, 't0', 0, 'f0', 374/800, ...
  'dt', 0.1, 'nPoints', 2048);

% physical constants
speedOfLight = 300; % nm / fs

% material properties
n2eff = 4*pi;

p2 = p.copy;
p2.temporalPhase = p2.temporalPhase + n2eff * p2.temporalIntensity;


% amplitude-phase plot
ax = p.plot();
p2.plot(ax)
legend(ax(2),'flat phase','SPM');