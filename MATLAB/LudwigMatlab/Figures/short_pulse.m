
%tc = gauspuls('cutoff',90e4,0.4,[],-10);
%t1 = -tc : 1e-8 : tc;
%y1 = gauspuls(t1,90e3,0.8);
%plot(t1,y1,'lineWidth',2)


tc = gauspuls('cutoff',90e3,0.4,[],-40);
t = -tc : 1e-8 : tc;
yi = gauspuls(t,90e3,0.8);
plot(t,yi,'lineWidth',2)

