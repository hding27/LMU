
%addpath(genpath('O:\Ludwig\Matlab'))

dens_normalmask = [3.04e18 3.29e18 3.45e18];
dens_smallmask = [3.10e18 3.35e18 3.51e18];
dens_bigmask = [3.05e18 3.30e18 3.49e18];

dens = [dens_normalmask dens_smallmask dens_bigmask];

deviation = std(dens)/(sum(dens)/length(dens));