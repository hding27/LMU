function FigurePWvsInterfScan()
% This is to generate the figure PWvsInterfScan
% data: pressure scan from 2016-09-08
% pressure range 8:2:18 bar

% %% Ludwig's results
% ne0 = [2.29,2.38,2.65,3.07,3.35,3.86]*1e18; % density_fit_av_new2
% ne_error = ne0 .* [5.2,4.9,4.2,4.2,4.1,4.4]*1e-2;
% lp  = [22.43,21.72,20.25,19.47,19.07,17.52];
% le_error = lp.*[2.6,2.4,2.6,2.7,3.6,3.0]*1e-2;

%% HDing's results
ne0 = [2.29,2.38,2.65,3.07,3.35,3.86]*1e18; % density_fit_av_new2 from Ludwig
lp0 = [22.47 20.61 19.04 17.75 16.92 16.10]*1.26/1.168;
lp0_error = [0.4 0.07 0.19 0.15 0.34 0.07]*1.26/1.168;
lp1 = [24.32 22.68 21.72 20.40 19.41 17.70]*1.26/1.168;;
lp1_error = [0.08 0.02 0.08 0.05 0.07 0.10]*1.26/1.168;;
pressure = (8:2:18)+1; % +1 accounts for atm.
pressure(end)=18.7;
nr = ne0./pressure;
ne = mean(nr(2:end))*pressure;
ne_error = ne/20;
FontSize = 18;
LineWidth = 2;
figure(98),h0=errorbar(pressure(2:end),ne0(2:end),ne_error(2:end),'+r','LineWidth',LineWidth);
p = linspace(10,20,100);
n = mean(nr(2:end))*p;
hold on; plot(p,n,'LineWidth',LineWidth); hold off;
xlabel('backing pressue [bar]','FontSize',FontSize); ylabel('electron density n_e [cm^{-3}]','FontSize',FontSize)
legend('measurement', 'linear fit')
set(gca,'FontSize',FontSize);
set(gcf, 'Color', 'w');
%export_fig fig1.pdf -q101

% analytical values and least squares fit
nes = linspace(1.5e18,5e18,100);
lambdap= 10.558666*sqrt(1e19./nes);

a = 0.9:0.001:1.3;
er = a*0;
    for ii = 1:length(a)
        lpf = a(ii)*10.558666*sqrt(1e19./ne(2:end));
        er(ii)=sum((lp1(2:end)-lpf).^2);
    end
[~,c]= min(er);
lambdap1= a(c)*10.5*sqrt(1e19./nes);
fprintf('Lengthening factor is %.3f.\n', a(c));
fprintf('suggesting an a0 of %.2f.\n', sqrt(2*(a(c)^4-1)));


figure(99);hold on

errorbarxy(ne(2:end),lp0(2:end),ne_error(2:end),lp0_error(2:end),{'ko', 'k', 'k'}); % nonrel.
errorbarxy(ne(2:end),lp1(2:end),ne_error(2:end),lp1_error(2:end),{'rx', 'r', 'r'}) % relativistic
plot(nes,lambdap,'k','LineWidth',LineWidth) % analytical value for lp
plot(nes,lambdap1,'r-.','LineWidth',LineWidth) % 'least squares fit for c x \lambda_p',...
%plot(nes,lambdap*1.0201, '--','Color', [0.6 0.6 0.6]) %'1D fluid model a_0=1.1',...
%plot(nes,lambdap*1.0549, ':','Color', [0.8 0.8 0.8]) %'1D fluid model a_0=1.5',...

% plot(3.0728e18, 19.05,'ko','markersize',8) %L6
% plot([2.3558e18,3.0728e18,3.9537e18], [22.098,19.355,16.977],'k*','markersize',8) %L1 21.133
% plot(3.0728e18, 19.926,'ks','markersize',8) %L2
% plot(3.0728e18, 21.133,'kd','markersize',8) %L2

xlabel('electron density n_e [cm^{-3}]','FontSize',FontSize)
ylabel('oscillation wavelength [\mum]','FontSize',FontSize)
legend('measured nonrelativistic \lambda_p',...
    'measured relativistic \lambda_p',...
    'analytical solution for \lambda_p',...
    'least squares fit for rel. \lambda_p')
box on
xlim([1.7e18,4.3e18]);
set(gca,'FontSize',FontSize);
set(gcf, 'Color', 'w');

%export_fig fig2.pdf -q101
% legend('nonrelativistic \lambda_p',...
%     'relativistic \lambda_p',...
%     'least squares fit for rel. \lambda_p',...
%     'analytical solution for \lambda_p',...
%     '3D PIC simulation a_0=1.1',...
%     '3D PIC simulation a_0=1.5',...
%     '3D PIC simulation a_0=2.0',...
%     '3D PIC simulation a_0=4.0')

end