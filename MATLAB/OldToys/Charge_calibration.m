cd('O:\Electrons\20160627\CameraCalibration')
%% LowE charge Calib
myDir_LE=dir('*Charge_CLB_LowE*');
LE_L=1;
LE_T=105;
LE_R=1610;
LE_B=340;
TCap_LE=zeros(1,length(myDir_LE));
BKG_LE=TCap_LE;
for i=1:length(myDir_LE)
I=imread(myDir_LE(i).name);
I=I(LE_T:LE_B,LE_L:LE_R);
TCap_LE(i)=sum(sum(double(I(24:48,916:998))));
BKG_LE(i)=sum(sum(double(I)));
end
%
t=[0.1,0.2,0.5,1.0,2.0];
figure(1),plot(t,TCap_LE./t,'+')
figure(2),plot(t,BKG_LE./t)
%% HighE charge Calib
myDir_HE=dir('*Charge_CLB_HighE*');
LE_L=300;
LE_T=610;
LE_R=1620;
LE_B=770;
TCap_HE=zeros(1,length(myDir_HE));
BKG_HE=TCap_HE;
for i=1:length(myDir_HE)
I=imread(myDir_HE(i).name);
I=I(LE_T:LE_B,LE_L:LE_R);
TCap_HE(i)=sum(sum(double(I(15:25,543:578))));
BKG_HE(i)=sum(sum(double(I)));
end
%%
t=[0.1,0.2,0.5,1.0,2.0];
figure(1),plot(t,TCap_HE./t,'+')
figure(2),plot(t,BKG_HE./t)
figure,imagesc(double(I))