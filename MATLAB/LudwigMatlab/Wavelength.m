%% measured data:

ne = [2.29,2.38,2.65,3.07,3.35,3.86]*1e18;
ne = [3.86/19*9, 3.86*11/19,3.86/19*13,3.86*15/19,3.86*17/19, 3.86]*1e18;
ne_error = ne .* [5.2,4.9,4.2,4.2,4.1,4.4]*1e-2;
% Ludwigs Data
% lp = [22.43,21.72,20.25,19.47,19.07,17.52];
% le_error = lp.*[2.6,2.4,2.6,2.7,3.6,3.0]*1e-2;

% HDings Data
lp       = [22.29 20.67 18.69 18.1 16.89 15.60]/1.168*1.26;

lp2       = [24.52 22.78 21.5 20.5 19.40 17.38]/1.168*1.26;
le_error = [0.22, 0.14, 0.21, 0.26, 0.21, 0.19];

% analytical values and least squares fit

nes = linspace(1e18,10e18,100);
lambdap= 10.558666*sqrt(1e19./nes);
lp0= 10.558666*sqrt(1e19./ne);

a = [0.9:0.001:1.3];
for i = 1:length(a)
    lp1 = a(i)*10.558666*sqrt(1e19./ne);
    er(i)=sum((lp-lp1).^2);
end
[b,c]= min(er);
lambdap1= a(c)*10.558666*sqrt(1e19./nes);

% PLOTS
clf()
figure(95);hold on
% measurements with errorbars
errorbarxy(ne,lp,ne_error,le_error,{'rx', 'r', 'r'})
% analytical value for lp
plot(nes,lambdap,'k')



plot(nes,lambdap1,'b-.')
plot(nes,lambdap*1.0549, ':','Color', [0.8 0.8 0.8])

plot(3.0728e18, 19.05,'ko','markersize',8) %L6
plot([2.3558e18,3.0728e18,3.9537e18], [22.098,19.355,16.977],'k*','markersize',8) %L1 21.133
% plot(3.0728e18, 19.926,'ks','markersize',8) %L2
% plot(3.0728e18, 21.133,'kd','markersize',8) %L2
plot(ne, lp2, '+b')

legend('measurement','analytical solution for \lambda_p',...
    'least squares fit for c x \lambda_p',...
    '1D fluid model a_0=1.5','3D PIC simulation a_0=1.1',...
    '3D PIC simulation a_0=1.5')%,'3D PIC simulation a_0=2.0','3D PIC simulation a_0=4.0')
xlim([1.5e18,4.3e18])

xlabel('electron density n_e [cm^{-3}]')
ylabel('oscillation wavelength [\mum]')
box on
set(gcf, 'Color', 'w');
%%
export_fig test.png -m3 -painter
%figure,plot(ne, lp2./lp)
