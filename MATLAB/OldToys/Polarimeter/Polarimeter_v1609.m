%
%
%
%

Raw = imread('Polarimetry_testPic_000.png');
figure(99),imshow(Raw,[0,20])
size = 1023;
top = 100;
left = 860;


%%
offsetV = 793;
offsetH = -703;
I1 = double(Raw(top:top+size,left:left+size));
I2 = double(Raw(top+offsetV:top+offsetV+size,left+offsetH:left+offsetH+size));
figure,imagesc(I1)
figure,imagesc((1+I1)./(1+I2))

%%
I = 3/5*2^16*double(Raw)/max(max(double(Raw)));
I = uint16(I);
imwrite(I,'Polarimetry_testPic.png')