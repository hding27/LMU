%% pointing imaging calibration
eP_raw = imread('20151119_001_1584_ePointing.png');
eP_ref = ones(size(eP_raw))*mean(mean(eP_raw));
eP=double(eP_raw)-double(eP_ref);
eP(eP<0)=1;
figure,imagesc(log(eP))

eP(eP<0.02*max(max(eP)))=0;
figure(1),imshow(eP,[0,3000])
figure,imagesc(log(double(eP)))
%
%%
%  spectrometer imaging calibration, define the centre points in the 
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
t=atan(P_H(1));
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
xlabel('pixels'),ylabel('mm');

P_Z = polyfit(CLB_Z_px,CLB_Z_mm,1);
CLB_Z = @ (x) x*P_Z(1)+P_Z(2);
figure(1),plot(CLB_Z_px,CLB_Z_mm,'o'),title('Z calibration'), hold on
plot(CLB_Z_px, CLB_Z(CLB_Z_px),'-r'), hold off
xlabel('pixels'),ylabel('mm')

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

% figure,plot(zz,CAL_E(zz)),hold on;
% plot(zz,EE,'-r'), hold off;
% 
% figure,plot((CAL_E(zz)-EE)./EE)
toc

% %%
% tic
% EE=zeros(size(zz));
% for ii=1:length(zz)
%     ZZ = @(E) eTrajectory(E,15,0,'LE')-zz(ii);
%     options=optimoptions('fsolve','Display','off');
%     EE(ii) = fsolve(ZZ,300,options);
%     if(mod(ii,100)==0)
%         display(ii);
%     end
% end
% toc
% figure,plot(EE)
%

%%
eSL = imread('20151119_001_1584_eSpecLE.png');
eSL_rot = imrotate(eSL,Ang_rot,'bicubic','crop');
eSL_ROI = eSL_rot(ROI_S(1):ROI_S(2),ROI_S(3):ROI_S(4));
figure(10),imagesc(CAL_E(zz), xx, eSL_ROI);
xlabel('Energy (MeV)')
ylabel('Position (mm)')
%eSL_norm=bsxfun(@rdivide,eSL_ROI,max(eSL_ROI));

%%
eSH = imread('20151119_001_1584_eSpecHE.png');
figure(3),imshow(eSH,[0,10])
