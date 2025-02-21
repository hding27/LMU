addpath(genpath('\\z-sv-pool08\Hao.Ding\MATLAB\Frog_retrieval'))

name0 =  '11_19_time_13_38_1439561_750';
name200 = '11_24_time_2_10_1965_613';
name500 = '11_24_time_2_0_1330_391';
name = name0;

frog_retr_time = load(['Pulse_Time_Domain ' name '.txt']); 
frog_retr_frq = load(['Pulse_Freq_Domain ' name '.txt']);   
frog_trace_raw = load(['FROGtrace ' name '.txt']);
figure,imagesc(frog_trace_raw)
% frog trace
frog_trace = frog_trace_raw(:,1:end-6);
figure,imagesc(frog_trace_raw)

% spectrum
pWavelength = frog_retr_frq(:,2); % in nm 
pSpectrum = frog_retr_frq(:,3);
%% convert from wavelength to frequency
pFrequency = 299.792458./pWavelength; % in PHz
figure,plot(pFrequency-frog_retr_frq(:,1)-0.3747)

%% temporal profile
pTime = frog_retr_time(:,1);
pIntensity = frog_retr_time(:,2);
oTime = linspace(-50,50,1000);
oIntensity = interp1(pTime,pIntensity,oTime,'cubic');
figure,plot(oTime,oIntensity)
%%
figure(98)
imagesc(pTime,(pWavelength),frog_trace);
%xlim([-150 150])
%ylim([370 560])
xlabel('time [fs]','fontsize',18)
ylabel('wavelength [nm]','fontsize',18)
%% plot
figure(99)
subplot(3,1,3)
hold on
plot(pWavelength,pSpectrum,'b','LineWidth',1.5);
hold off
%xlim([500 1000])
ylim([0 1.05])
xlabel('wavelength [nm]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)
box on

subplot(3,1,2)
plot(pTime,pIntensity,'b','LineWidth',1.5);
%xlim([-150 150])
ylim([0 1.05])
xlabel('time [fs]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)

subplot(3,1,1)
imagesc(pTime,pWavelength./2,frog_trace);
%xlim([-150 150])
ylim([370 560])
xlabel('time [fs]','fontsize',18)
ylabel('wavelength [nm]','fontsize',18)
%%
temp = sum(frog_trace,1);
figure,plot(pIntensity,'-r')
hold on
plot(temp/max(temp))
hold off
