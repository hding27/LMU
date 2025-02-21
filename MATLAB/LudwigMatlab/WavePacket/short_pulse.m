
tc = gauspuls('cutoff',90e4,0.4,[],-10);
t1 = -tc : 1e-8 : tc;
y1 = gauspuls(t1,90e3,0.8);
plot(y1,'lineWidth',2)