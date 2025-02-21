

E = 1;
w = 0.2;
t = -100:1:100;


d=100;

gauss = E*exp(-1i*w*t);
fun = @(t,E,w) E*exp(-1i*w*t);
spm = integral(@(t)fun(t,1,2),-100,100,'ArrayValued',true);



figure (9)
plot(t,gauss)


