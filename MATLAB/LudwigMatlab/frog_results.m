addpath(genpath('O:\Ludwig\Matlab'))

%500mbar
frog_retr_time500 = load('Pulse_Time_Domain 11_24_time_2_0_1330_391.txt'); 
frog_retr_frq500 = load('Pulse_Freq_Domain 11_24_time_2_0_1330_391.txt');   
spec500 = load('spec_500mbar_500uJ.txt');
max500 = max(spec500(:,2));
spec500_norm = spec500(:,2)/max500(1);

frog_trace500_org = load('FROGtrace 11_24_time_2_0_1330_391.txt');
frog_trace500 = frog_trace500_org(:,1:238);


%200mbar
frog_retr_time200 = load('Pulse_Time_Domain 11_24_time_2_10_1965_613.txt'); 
frog_retr_frq200 = load('Pulse_Freq_Domain 11_24_time_2_10_1965_613.txt');   
spec200 = load('spec_200mbar_500uJ.txt');
max200 = max(spec200(:,2));
spec200_norm = spec200(:,2)/max200(1);

frog_trace200_org = load('FROGtrace 11_24_time_2_10_1965_613.txt');
frog_trace200 = frog_trace200_org(:,1:251);
%time axis
pulse_retr_time500(:,1) = frog_retr_time500(:,1);
pulse_retr_time500(:,2) = frog_retr_time500(:,2);
[M,I] = max(pulse_retr_time500);
d500 = find(pulse_retr_time500(:,2)>0.5);
last500 = pulse_retr_time500(d500(end),1);
first500 = pulse_retr_time500(d500(1),1);
fwhm500 = last500 - first500;



pulse_retr_time200(:,1) = frog_retr_time200(:,1);
pulse_retr_time200(:,2) = frog_retr_time200(:,2);
d200 = find(pulse_retr_time200(:,2)>0.5);
last200 = pulse_retr_time200(d200(end),1);
first200 = pulse_retr_time200(d200(1),1);
fwhm200 = last200 - first200;



%frquency axis
pulse_retr_frq500(:,1) = frog_retr_frq500(:,2);
pulse_retr_frq500(:,2) = frog_retr_frq500(:,3);


pulse_retr_frq200(:,1) = frog_retr_frq200(:,2);
pulse_retr_frq200(:,2) = frog_retr_frq200(:,3);

%plot 500muJ
figure(1)
subplot(3,1,3)
hold on
plot(pulse_retr_frq500(:,1),pulse_retr_frq500(:,2),'b','LineWidth',1.5);
plot(spec500(:,1),spec500_norm,'r-');
hold off
xlim([400 1030])
ylim([0 1.05])
xlabel('wavelength [nm]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)
box on

subplot(3,1,2)
plot(pulse_retr_time500(:,1),pulse_retr_time500(:,2),'b','LineWidth',1.5);
xlim([-250 250])
ylim([0 1.05])
xlabel('time [fs]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)

subplot(3,1,1)
imagesc(pulse_retr_time500(:,1),pulse_retr_frq500(:,1)./2,frog_trace500);
xlim([-214 243])
ylim([370 560])
xlabel('time [fs]','fontsize',18)
ylabel('wavelength [nm]','fontsize',18)


%plolt 200muJ
figure(2)
subplot(3,1,3)
hold on
plot(pulse_retr_frq200(:,1),pulse_retr_frq200(:,2),'b','LineWidth',1.5);
plot(spec200(:,1),spec200_norm,'r-');
hold off
xlim([400 1030])
ylim([0 1.05])
xlabel('wavelength [nm]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)
box on

subplot(3,1,2)
plot(pulse_retr_time200(:,1),pulse_retr_time200(:,2),'b','LineWidth',1.5);
xlim([-250 250])
ylim([0 1.05])
xlabel('time [fs]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)

subplot(3,1,1)
imagesc(pulse_retr_time200(:,1),pulse_retr_frq200(:,1)./2,frog_trace200);
xlim([-300 300])
ylim([300 600])
xlabel('time [fs]','fontsize',18)
ylabel('wavelength [nm]','fontsize',18)
%%
figure(3)

subplot(3,2,5)
hold on
plot(pulse_retr_frq200(:,1),pulse_retr_frq200(:,2),'b','LineWidth',1.5);
plot(spec200(:,1),spec200_norm,'r-');
hold off
xlim([400 1030])
ylim([0 1.05])
xlabel('wavelength [nm]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)
box on

subplot(3,2,3)
plot(pulse_retr_time200(:,1),pulse_retr_time200(:,2),'b','LineWidth',1.5);
xlim([-250 250])
ylim([0 1.05])
xlabel('time [fs]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)

subplot(3,2,1)
imagesc(pulse_retr_time200(:,1),pulse_retr_frq200(:,1)./2,frog_trace200);
xlim([-300 300])
ylim([300 600])
xlabel('time [fs]','fontsize',18)
ylabel('wavelength [nm]','fontsize',18)



subplot(3,2,6)
hold on
plot(pulse_retr_frq500(:,1),pulse_retr_frq500(:,2),'b','LineWidth',1.5);
plot(spec500(:,1),spec500_norm,'r-');
hold off
xlim([400 1030])
ylim([0 1.05])
xlabel('wavelength [nm]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)
box on

subplot(3,2,4)
plot(pulse_retr_time500(:,1),pulse_retr_time500(:,2),'b','LineWidth',1.5);
xlim([-250 250])
ylim([0 1.05])
xlabel('time [fs]','fontsize',18)
ylabel('Intensity [a.u.]','fontsize',18)

subplot(3,2,2)
imagesc(pulse_retr_time500(:,1),pulse_retr_frq500(:,1)./2,frog_trace500);
xlim([-214 243])
ylim([370 560])
xlabel('time [fs]','fontsize',18)
ylabel('wavelength [nm]','fontsize',18)