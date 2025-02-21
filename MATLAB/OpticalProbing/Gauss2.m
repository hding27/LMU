function A = Gauss2(n,sigma)
m = (n-1)/2;
x = ndgrid(-m:m,-m:m);
A = exp(-x.^2/sigma^2);
A = A/sum(A(:));
end