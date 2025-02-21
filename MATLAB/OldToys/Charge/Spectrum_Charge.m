clean
myDir = dir('*.png');
%%
L = length(myDir);
c_BKG = 7300736;
c_tot = zeros(L,1);
c_tri = zeros(L,1);

for i=1:L
    I = imread(myDir(i).name);
    figure,imagesc(I)
    c_tot(i) = sum(double(I(:)));
    I_tri = I(12:22,540:580);
    figure,imagesc(I_tri)
    c_tri(i) = sum(sum(double(I_tri)));
end

charge =( c_tot-c_BKG-c_tri)/2.21./(c_tri/0.2/10);
figure,plot(charge)
