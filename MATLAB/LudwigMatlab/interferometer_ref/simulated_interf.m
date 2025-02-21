clear all
addpath(genpath('O:\Ludwig\Matlab'))


t = 1:2048;
w = 0.1;
phi = 0;
d = 100;
signal = int16(127.5 + 127.5*cos(w*t + phi));
for i = 1:length(t)
        interf(i,:) = signal;
   if 500 < i <=2000
        x = 1250 -i;
        phi = 4*exp(-x^4./d^4);
        interf(i,:) = int16(127.5 + 127.5*cos(w*t + phi));
    end
end

figure(1)
colormap gray
imagesc(interf)