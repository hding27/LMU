

x = -200:0.1:200;

%y = gaussmf(x,[300 0])-1.05;
%z = -gaussmf(x,[300 0])+1.05;
%plot(x,y,x,z,x,0,'-k')
%vq = interp1(x,y,xq,method)
c = 0;
s = 1000;
y = exp(-x.^2/s^2)-1.01;
y2= -exp(-x.^2/s^2)+1.01;
null = zeros(1,4001);
plot(x,y,'b',x,y2,'b',x,null,'-k')