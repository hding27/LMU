%
%
%
%
%
%% imaging calibration of LowE
ROI = load('LowE_ROI.txt');

I_clb = imread('LowE_Calib.png');
I = I_clb(ROI(2):ROI(4),ROI(1):ROI(3));
figure(1),imshow(I,[1,1e5]);
%% 
PosPz = [119, 342, 550, 753, 944, 1129, 1305, 1470]; % pixel in picture
PosZ = [30, 35, 40, 45, 50, 55, 60, 65 ]; % cm distacne to spec entrance

PosPx = [55, 214];
PosTri = [917, 1, 976, 33];
P = polyfit(PosPz, PosZ, 1);
CLB_Im = @(x) P(1)*x + P(2);

% figure(2),plot(PosP,PosZ,'+');
% hold on
% plot(ROI(1):ROI(3),CLB_Im(ROI(1):ROI(3)),'-r');
% hold off


%% energy calibration of LowE
Temp = load('LANEX_Calibration_20160714.txt');
LX_En = Temp(:,1)*1e-6; % convert eV to MeV
LX_Z = Temp(:,2)*100; % convert m to cm on lanex
clear('Temp');
%figure(3),plot(LX_En,LX_Z);
CLB_En = @(x) interp1(LX_Z, LX_En, CLB_Im(x));

%% incidence angle correction 
hight = -14; % relative hight of LANEX to beam axis
CLB_An = @(x) -pi/2 - 2* atan(CLB_Im(x)/hight);
%%
A_Px = 1:ROI(3)-ROI(1);
A_En = CLB_En(A_Px);
d_En = A_En-[CLB_En(0),A_En(1:end-1)];
A_An = CLB_An(A_Px);
A_X  = linspace(-20,20,PosPx(2)-PosPx(1)+1);
figure(4),plot(A_Px,A_En,'-black');
title('energy calibration')
xlabel('position in picture (px)');
ylabel('energy (MeV)');
axis tight
figure(5),plot(A_Px,cos(A_An))
title('incidence angle')
xlabel('position in picture (px)');
ylabel('cos \theta_{in}');
axis tight

%% load background
I_bkg1 = double(imread('20160714_000_0001_eSpecLowE.png'));
I_bkg2 = double(imread('20160714_000_0002_eSpecLowE.png'));
I_bkg3 = double(imread('20160714_000_0003_eSpecLowE.png'));
I_bkg = (I_bkg1 + I_bkg2 + I_bkg3)/3;
figure,imagesc(uint16(I_bkg),[1,5000])
title('bakground')
