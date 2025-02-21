clear all
addpath(genpath('O:\Ludwig\Matlab'))
spec = load('before_fiber.txt');
norm_spec(:,1)=spec(:,1);
norm_spec(:,2)=spec(:,2)./max(spec(:,2));

plot(norm_spec(:,1),norm_spec(:,2))


xlim([600,1000])
ylim([0,1])

xlabel('Wavelength [nm]')
ylabel('Intensity [a.u.]')

box on

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [0 0 10 8]); 

filename_png = 'spectrum.png';
filename_eps = 'spectrum.eps';

print(filename_png, '-dpng', '-r600');
print(filename_eps,'-depsc')