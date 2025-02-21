clear all

t = -100:0.1:100;
tau = 30;
a = 3;
b = 0.023;
I = a*exp(-t.^2/tau^2);
zero = zeros(1,2001);


sin_neg = b.*t.*I;

figure(4)
plot(t,I,'b',t,sin_neg,'r',t,zero,'k')