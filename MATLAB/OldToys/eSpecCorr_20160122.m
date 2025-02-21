%% pointing imaging calibration
eP_raw = imread('20151119_001_1584_ePointing.png');
eP=eP_raw;
figure(2),contour(eP),axis equal
eP_ref = zeros(size(eP));
eP(eP<0.01*max(max(eP)))=0;
P=centerOfMass(eP)
figure(1),imshow(eP,[0,3000]),axis equal
figure(2),contour(eP),axis equal
figure,imagesc(log(double(eP))),axis equal
%%
%  spectrometer LE imaging calibration, define the centre points in the 
%  picture and save the coordinates in 'IMG_Calib_eSpecLE_H.txt' with 
%  the format %i\t,%i\t,%i, Z_real_space(mm), Z_pixel, X_pixel
eSL_ref = imread('20151119_001_0172_eSpecLE.png');
%figure(1),subplot(2,1,1),imshow(eSL_ref);
figure(1),imshow(eSL_ref,[0,max(max(eSL_ref))/2]);
%%
Data=dlmread('IMG_Calib_eSpecLE_H.txt');
CLB_Z_mm=Data(:,1);
CLB_Z_px=Data(:,2);
CLB_H_px=Data(:,3);
P_H = polyfit(CLB_Z_px,CLB_H_px,1);
figure(2),plot(CLB_Z_px,CLB_H_px,'o'), title('rotation'), hold on
plot(CLB_Z_px,CLB_Z_px*P_H(1)+P_H(2),'-r'), hold off
t=atan(P(1));
Kern_rot=[cos(t),-sin(t);sin(t),cos(t)];
t=size(eSL_ref);
Data=[CLB_Z_px-(t(2)-1)/2,CLB_H_px-(t(1)-1)/2]*Kern_rot;
CLB_Z_px =(round(Data(:,1)+(t(2)-1)/2));
CLB_H_px =(round(Data(:,2)+(t(1)-1)/2));
Ang_rot=atan(P_H(1))*180/pi;
eSL_rot = imrotate(eSL_ref,Ang_rot,'bicubic','crop');
figure(1),imshow(eSL_rot,[0,max(max(eSL_rot))/2]);
%%

Data=dlmread('IMG_Calib_eSpecLE_V.txt');
CLB_X_mm=Data(:,1)/10;
CLB_X_px=Data(:,2);
P_X = polyfit(CLB_X_px,CLB_X_mm,1);
CLB_X = @(x) x*P_X(1)+P_X(2);
figure(2),plot(CLB_X_px,CLB_X_mm,'o'),title('X calibration'), hold on
plot(CLB_X_px, CLB_X(CLB_X_px),'-r'), hold off

P_Z = polyfit(CLB_Z_px,CLB_Z_mm,1);
CLB_Z = @ (x) x*P_Z(1)+P_Z(2);
figure(3),plot(CLB_Z_px,CLB_Z_mm,'o'),title('Z calibration'), hold on
plot(CLB_Z_px, CLB_Z(CLB_Z_px),'-r'), hold off

%%
ROI_S=[58, 215, 1, 1260]; %top bottom left right

xx=CLB_X(ROI_S(1):ROI_S(2));
zz=CLB_Z(ROI_S(3):ROI_S(4));

tic
N=10;
En=zeros(1,N);
Z=zeros(1,N);

for ii=1:N
    Z(ii)=(N-ii)/(N-1)*min(zz)+(ii-1)/(N-1)*max(zz);
    fun = @(E) eTrajectory(E,0,0,'LE')-Z(ii);
    options=optimoptions('fsolve','Display','off');
    En(ii) = fsolve(fun,300,options);
end

P_E=polyfit(Z,En,2);
CAL_E=@(x) x.^2*P_E(1)+x*P_E(2)+P_E(3);

figure,plot(zz,CAL_E(zz)),hold on;
plot(zz,EE,'-r'), hold off;
% 
% figure,plot((CAL_E(zz)-EE)./EE)
toc

%%
eSL = imread('20151119_001_1584_eSpecLE.png');
eSL_rot = imrotate(eSL,Ang_rot,'bicubic','crop');
eSL_ROI = eSL_rot(ROI_S(1):ROI_S(2),ROI_S(3):ROI_S(4));
figure(11),imagesc(CAL_E(zz), xx, eSL_ROI);
xlabel('Energy (MeV)')
ylabel('Position (mm)')
%eSL_norm=bsxfun(@rdivide,eSL_ROI,max(eSL_ROI));

%%
eSH = imread('20151119_001_1584_eSpecHE.png');
figure(3),imshow(eSH,[0,10])

%% initialization
% Rc = 3.3*E*cos(beta)/B;  radius of cyclotron motion, in mm

xP = 0;   % transverse poitng, measured from laser axis, in cm
yP = 0;   % vertical poiting, measured from laser axis, in cm

yS_o = -135; % vertical position at spectrometer exit, in mm
zS_o = 150; % longitudinual postion at spectrometer exit, in mm

% parameteres
B = 0.85; % magnetic field strength, im T
D_TP = 1500; % distance between target and pointing LANEX, in mm
D_PS = 300;  % distance from pointing LANEX to sepctrometer entrance, in mm
alpha= atan(xP/D_TP);  % transverse angle about laser axis, in radian
beta = atan(yP/D_TP);  % vertical angle about laser axis, in radian
yS_i = (D_TP+D_PS)*yP/D_TP; % vertical postion at sepctrometer entrance

%function getRadius(yS_i,yS_o,zS_o,zP,yP)

C=linsolve([D_TP+D_PS, yS_i; zS_o, yS_o-yS_i],...
    [yS_i^2;(yS_o^2-yS_i^2+zS_o^2)/2]);
R=sqrt((zS_o-C(1))^2+(yS_o-C(2))^2);
E=R*B/3.30/cos(alpha)



%%

R=@(x) (x.^2+6400)./x/2;
figure,plot(R(5:0.001:13))
x_k=10;
sym x
sol=solve(R(x)/x_k==x_k,x)
%%
B = 0.85; % magnetic field strength, im T
xP = 0;   % transverse poitng, measured from laser axis, in cm
yP = 0;   % vertical poiting, measured from laser axis, in cm
beta = 0;  % vertical angle about laser axis, in radian

D_TP = 150; % distance between target and pointing LANEX, in cm
D_PS = 30;  % distance from pointing LANEX to sepctrometer entrance, in cm

alpha=atan(yP/D_TP); % trasverse angle about laser axis, in radian
yS_i = (D_TP+D_PS)*yP/D_TP; % vertical postion at sepctrometer entrance
yS_o = -25; % vertical position at spectrometer exit, in cm
zS_o = 100; % longitudinual postion at spectrometer exit, in cm
% (D_TP+D_PS)*z-(yS_i-y)*yS_i==0
% (80-z)*(zS_o-80)+(x-y)*(yS_o-x)==0
% z^2+(yS_i-y)^2==(80-z)^2+(x-y)^2
%function getRadius(yS_i,yS_o,zS_o,zP,yP)
z=0;
syms x y z
eqn1 = (D_TP+D_PS)*z+(yS_i-y)*yS_i==0;
eqn2 = (80-z)*(zS_o-80)+(x-y)*(yS_o-x)==0;
eqn3 = z^2+(yS_i-y)^2==(80-z)^2+(x-y)^2;

Sol=solve([eqn1,eqn3],[z,y,x])
