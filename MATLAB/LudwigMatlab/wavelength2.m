
% measured data:

ne = [2.29,2.38,2.65,3.07,3.35,3.86]*1e18;
ne_error = ne .* [5.2,4.9,4.2,4.2,4.1,4.4]*1e-2;

lp = [22.43,21.72,20.25,19.47,19.07,17.52];
le_error = lp.*[2.6,2.4,2.6,2.7,3.6,3.0]*1e-2;

% analytical values and least squares fit

nes = linspace(1e18,10e18,100);
lambdap= 10.558666*sqrt(1e19./nes);
lp0= 10.558666*sqrt(1e19./ne);

i=0;
a = [0.9:0.001:1.3];
for i = 1:length(a)
    lp1 = a(i)*10.558666*sqrt(1e19./ne);
    er(i)=sum((lp-lp1).^2);
end
[b,c]= min(er);
lambdap1= a(c)*10.5*sqrt(1e19./nes);

%% PLOTS
clf()
figure(2);

set(gca,'fontsize',14)
hold on
% measurements with errorbars
errorbarxy(ne,lp,ne_error,le_error,{'rx', 'r', 'r'})
% analytical value for lp
plot(nes,lambdap,'k','LineWidth',1.5)



plot(nes,lambdap1,'b-.','LineWidth',1.5)
plot(nes,lambdap*1.0201, 'k--','LineWidth',1.5)
plot(nes,lambdap*1.0549, 'k:','LineWidth',1.5)

%plot(3.0728e18, 19.05,'ko','markersize',8) %L6
%plot([2.3558e18,3.0728e18,3.9537e18], [22.098,19.355,16.977],'k*','markersize',8) %L1 21.133
%plot(3.0728e18, 19.926,'ks','markersize',8) %L2
%plot(3.0728e18, 21.133,'kd','markersize',8) %L2


legend('measurement','analytical solution for \lambda_p','least squares fit for c x \lambda_p','1D fluid model a_0=1.1','1D fluid model a_0=1.5')
xlim([2e18,4.3e18])
xlabel('electron density n_e [cm^{-3}]')
ylabel('oscillation wavelength [\mum]')
box on
hold off 

figure(3)
set(gca,'fontsize',14)
hold on
% measurements with errorbars
errorbarxy(ne,lp,ne_error,le_error,{'rx', 'r', 'r'})
% analytical value for lp
plot(nes,lambdap,'k','LineWidth',1.5)

plot(nes,lambdap1,'b-.','LineWidth',1.5)
plot(3.0728e18, 19.05,'ko','markersize',8,'LineWidth',1.5) %L6
plot([2.3558e18,3.0728e18,3.9537e18], [22.098,19.355,16.977],'k*','markersize',8,'LineWidth',1.5) %L1 21.133
plot(3.0728e18, 19.926,'ks','markersize',8,'LineWidth',1.5) %L2
plot(3.0728e18, 21.133,'kd','markersize',8,'LineWidth',1.5) %L2


legend('measurement','analytical solution for \lambda_p','least squares fit for c x \lambda_p','3D PIC simulation a_0=1.1','3D PIC simulation a_0=1.5','3D PIC simulation a_0=2.0','3D PIC simulation a_0=4.0')
xlim([2e18,4.3e18])
xlabel('electron density n_e [cm^{-3}]')
ylabel('oscillation wavelength [\mum]')
box on