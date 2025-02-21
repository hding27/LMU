clear all

x = -50:0.1:50;
s1 = 25;
s2 = 35;
y1 = 2.*exp(-x.^2/s1^2);
y2 = 2.5 + (exp(-x.^2/s2^2)).^2;

figure(5)
plot(x,y1,x,y2)