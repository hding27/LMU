x = -100:0.01:100;

y = gaussmf(x,[300 0])-1.05;
z = -gaussmf(x,[300 0])+1.05;
plot(x,y,x,z,x,0,'-k')
%vq = interp1(x,y,xq,method)