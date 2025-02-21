

t = linspace(-4*pi,4*pi,200);
w = linspace(100,1000,2000)';
delta_phix = 1:200;
delta_phiy = (1:2000)';
delta_phi_mat = delta_phiy*delta_phix;

d = zeros(2000,200);
for i = 2:2000
    for j = 1:200
    d(1,:) = 1:200;
    d(i,j) = d(i-1,j)+200;
    end
end


sin_mat = sin(w*t+d);
siz = size(sin_mat);

chirp = 1/(siz(1)*siz(2))*sum(sin_mat);
plot(t,chirp)


