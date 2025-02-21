t = -2*pi:0.01/(2*pi):2*pi;
E_0 = 1;
%w_1 = 0.3;
%w_2 = 0.6;
%f_1 = E_0*cos(w_1*t);
%f_2 = 2+E_0*cos(w_2*t);

for i = 1:5
    w = 1+i*0.3;
    f(i,:) = i*2+E_0*cos(w*t);
    figure(1);
    plot(t,f,'LineWidth',2)
    
end
