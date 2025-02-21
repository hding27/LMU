%% set up working environment
addpath(genpath('O:\HDing\MATLAB\HDingMatlabTools\'));
%%


%% ATLAS bandwidth and pulse duration
data = load('20170418_Spectrum_TIT1_3.2J_Mazz_AVG5shots.txt');
wl = data(:,1);
In = data(:,2);
figure(98),plot(wl,In)
xlim([750,850])
%% a little game with three-step-ionization
%
%
%
wavelength = 0.8; % wavelength in um
tFWHM = 5;  % FWHM pulse duration in fs
phi0 = 0*pi/2; % carrier envelope phase
cVac = 0.299792458;

dt = 0.011;
t = dt*(0:900);
E = exp(-t.^2 *4*log(2)/tFWHM^2).*cos( 2*pi * cVac/wavelength *t + phi0);

figure, plot(t,E)

velocity = @(x) sum(E(floor(x/dt)+1:end));
figure,plot(t(t<1),velocity(t(t<1)))

%% linearity of gas nozzle density
pressure = (8:2:18)+1;
ne = [2.29,2.38,2.65,3.07,3.35,3.86];
nr = ne./pressure;
nr1 = ne./(pressure-1);
figure(1),plot(pressure, ne, 'r+')
figure(2),plot(pressure, nr)

p1 = 13:2:19;
n1 = [2.65,3.07,3.35,3.86];
pf = polyfit(p1,n1,1);

p = linspace(0,20,100);
n = mean(nr(3:end))*p;
figure(1), hold on
plot(p,n);
%%
load('registered');
top = 180;
bottom = 225;
data = registered(top:bottom,:);
figure,imagesc(data)
temp = fft(data');
spectrogram = abs(temp(2:100,:))';
figure, imagesc(spectrogram)
set(gcf, 'Color', 'w');
xlabel('spatial frequency [1/windowSize]')
ylabel('transverse position [px]')
export_fig withFFT.png -m2.5