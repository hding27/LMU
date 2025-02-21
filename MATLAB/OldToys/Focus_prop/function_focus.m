function Intensity=function_focus(wavelength,gridsize,gridnumber,aperture_diameter,Mask,focallength,factor)
% fun_intensity_in_focus(1053e-9,320e-3,2048,290e-3,Mask,800e-3,0.9997)
lambda=wavelength;              % wavelength
gridsize=gridsize;              % grid size
halfsize=0.5*gridsize;
gridnumber=gridnumber;          %grid dimension
aperture_radius=aperture_diameter/2;    %aperture radius
propagationlength=factor*focallength;

Field=ones(gridnumber,gridnumber);  % creat an electric field based on the grid number

M=aperture_radius*gridnumber/gridsize; % calculate the distance(grid number) between center to aperture edge

%%%%%%%%%%%%%%%%%%%%%%%%%%% to make the field out of aperture equal to zero
for p=1:1:gridnumber
    for q=1:1:gridnumber
        a=gridnumber/2-p;
        b=gridnumber/2-q;
        if sqrt(a^2+b^2)>M
            Field(p,q)=0;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Field=Field.*sqrt(Mask);  % times Intensity modulation factor via function Mask 
figure
imagesc(Field)
title('E0')

Field=fftshift(fft2(Field));  % 2D FFT of the field
figure
imagesc(abs(Field).^2)
title('E0-FFT')

f=focallength;   % focal length
L=propagationlength; % propagation length

x=linspace(-halfsize,halfsize,gridnumber); % new coordinate x  
y=linspace(-halfsize,halfsize,gridnumber); % new coordinate x  
figure
plot(x)
title('x')

%x=linspace(-halfsize,halfsize,gridnumber); % new coordinate x  
%y=linspace(-halfsize,halfsize,gridnumber); % new coordinate x  


z=L;                  % propagate to z plane
display(z)

fx=x/(lambda*z);             % spatial frequency in x direction
fy=y/(lambda*z);             % spatial frequency in y direction
figure
plot(fx)
title('fx')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% angular spectrum diffraction
approximation = zeros(gridnumber,gridnumber);
for p=1:1:gridnumber
    for q=1:1:gridnumber
approximation(p,q)=1-(lambda.*fx(p)).^2-(lambda.*fy(q)).^2; 
    end
end
H=exp(1i*2*pi*z/lambda.*sqrt(approximation));   % function H
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
imagesc(abs(H))
title('H')

Field=ifft2(fftshift(H.*Field)); % 2D IFFT


% resolution=128;
% interval=gridnumber/resolution;
% 
% for i=1:1:resolution
%     for j=1:1:resolution
%         Field_0(i,j)=Field(i*interval,j*interval);
%     end
% end
% 
% 
% dimension=gridsize*(1-factor);
% x0=linspace(-dimension/2,dimension/2,resolution);
% y0=linspace(-dimension/2,dimension/2,resolution);
% dx0=dimension/resolution;
% dy0=dimension/resolution;
% 
% x1=linspace(-dimension/2,dimension/2,resolution);
% y1=linspace(-dimension/2,dimension/2,resolution);
% 
% k=2*pi/lambda;
% L_propagation=(1-factor)*focallength;
% 
% for mm=1:1:resolution
%     for nn=1:1:resolution
%         integration=0;
%         for pp=1:1:resolution
%             for qq=1:1:resolution
%                 integration=integration+Field_0(pp,qq)*exp(-1i*k*(x1(mm)^2+y1(nn)^2)/2/f)*exp(1i*k/2/L_propagation*((x1(mm)-x0(pp))^2+(y1(nn)-y0(qq))^2))*dx0*dy0;
%             end
%         end
%         Field_1(mm,nn)=exp(1i*k*L_propagation)/(1i*lambda*L_propagation)*integration;   
%     end
% end

% Intensity=abs(Field_1).^2;         % intensity


Intensity=abs(Field).^2;

end
















