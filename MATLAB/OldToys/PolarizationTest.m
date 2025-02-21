date = '20161127/';
diagnostic = 'Interferogram/';
run1 = '_004_*';
run2 = '_005_*';
%%
cd(strcat('O:/electrons/', date, diagnostic))
mydir1 = dir(strcat('*', run1, '.png'));
mydir2 = dir(strcat('*', run2, '.png'));

I1 = double(imread(mydir1(1).name));
I2 = double(imread(mydir2(1).name));

for i = 2:length(mydir1)
    I = double(imread(mydir1(i).name));
    I1 = I/i+I1/(i-1);    
end


for i = 2:length(mydir2)
    I = double(imread(mydir2(i).name));
    I2 = I/i+I2/(i-1);
end
%%
figure,imagesc(I1(1100:1300,550:1150))
figure,imagesc(I2(1100:1300,550:1150))
%%
figure,imagesc(I2(1100:1300,550:1150)./I1(1110:1310,600:1200))