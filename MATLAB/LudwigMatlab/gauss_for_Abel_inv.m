clear all

x = -50:0.1:50;
s = 35;
y = exp(-x.^2/s^2);

figure(4)
plot(x,y)