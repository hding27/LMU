function [lambda, n0, filtered, xcorrelation, peaks] = CalculateWavelengthFromProbe(imagesum, pixelSize, numPeaks)
% pixelSize in um

if (nargin < 3)
  numPeaks = 2;
end

if (length(imagesum) < 50)
  error('Length of lineout too short for the crosscorrelation');
end


% High pass filter
windowSize = 30;
a = 1;
b = (1/windowSize)*ones(1,windowSize);

imeif = imagesum - filter(b, a, imagesum);

% Select roi (filter produces crap on the first points)
filtered = imeif(30:end);

% Autocorrelation and find peaks around the main peak
[c, lags] = xcorr(filtered, 'coeff');
%c=c/max(c);
[peak, peakpos] = findpeaks(c);

% Select the main and 4 surrounding peaks
[~,center] = max(peak);
peakposSel = peakpos(center-numPeaks:center+numPeaks);
peakSel = peak(center-numPeaks:center+numPeaks);

peaks.pos = lags(peakposSel);
peaks.val = peakSel;

% Calculate the wavelength and corresponding plasma density
lambda = mean(diff(peakposSel)) * pixelSize; % [um]
n0 = constants.n0(2*pi*constants.c/(lambda*1e-6))*1e-6; % [1/cm^3]
xcorrelation.c = c;
xcorrelation.lags = lags;
end

