function Intensity=function_focus_2step(wavelength,gridsize,gridnumber,aperture_diameter,Mask,focallength,factor)
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

Field=fftshift(fft2(Field));  % 2D FFT of the field


f=focallength;   % focal length
L=propagationlength; % propagation length

x=linspace(-halfsize,halfsize,gridnumber)/(1-L/f); % new coordinate x  
y=linspace(-halfsize,halfsize,gridnumber)/(1-L/f); % new coordinate x  

z=L;                  % propagate to z plane

fx=x/(lambda*z);             % spatial frequency in x direction
fy=y/(lambda*z);             % spatial frequency in y direction
k=2*pi/lambda;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fresnel diffraction
for p=1:1:gridnumber
    for q=1:1:gridnumber
approximation(p,q)=fx(p).^2+fy(q).^2; 
    end
end
H1=exp(1i*k*z).*exp(-1i*pi*lambda*z.*approximation);   % function H
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Field=ifft2(fftshift(H1.*Field)); % 2D IFFT

Field=fftshift(fft2(Field));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angular spectrum diffraction


x1=linspace(-halfsize,halfsize,gridnumber); % new coordinate x  
y1=linspace(-halfsize,halfsize,gridnumber); % new coordinate x  

L_rest=(1-factor)*focallength;

fx1=x1/(lambda*L_rest);             % spatial frequency in x direction
fy1=y1/(lambda*L_rest);             % spatial frequency in y direction


for p=1:1:gridnumber
    for q=1:1:gridnumber
approximation1(p,q)=1-(lambda.*fx1(p)).^2-(lambda.*fy1(q)).^2; 
    end
end
H2=exp(1i*2*pi*L_rest/lambda.*sqrt(approximation));   % function H
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Field=ifft2(fftshift(H2.*Field));


Intensity=abs(Field).^2;         % intensity
end
















