function [Z, varargout]=eTrajectory( E, xP, yP, LANEX )
%
%
%
%% initialization
% clean
% E = 480; % electron energy in MeV
% xP = 0;   % transverse poitng, measured from laser axis, in mm
% yP = 0;   % vertical poiting, measured from laser axis, in mm
% yS_o = -135; % vertical position at spectrometer exit, in mm
% zS_o = 1000; % longitudinual postion at spectrometer exit, in mm

% parameters
B = 0.850;   % magnetic field strength, in T
D_TP = 1800; % distance between target and pointing LANEX, in mm
D_PS = 360;  % distance from pointing LANEX to sepctrometer entrance, in mm
H_SL = 130;  % height of laser axis with repect to bottom of magnet

alpha = atan(xP/D_TP); % trasverse angle about laser axis, in radian
beta_i  = atan(yP/D_TP);  % vertical angle about laser axis, in radian
yS_i = (D_TP+D_PS)*yP/D_TP; % vertical postion at sepctrometer input
Rc = 3.3*E*cos(alpha)/B; % radius of cyclotron motion, in mm
yC = yS_i-Rc*cos(beta_i); % vertical centre of cyclotron motion
zC = Rc*sin(beta_i); % longitudial centre of cyclotron motion
if(Rc+Rc*cos(beta_i)<H_SL)
    display('electron can not reach LANEX')
    return
end
yS_o = - H_SL; % vertical postion at sepctrometer output
zS_o = zC + sqrt(Rc^2-(yS_o-yC)^2); % longitudial sepctrometer output
%%
if(zS_o>800)
    zS_o = 800;
    yS_o = yC+sqrt(Rc^2-(zS_o-zC)^2);
    
end
beta_o = -atan((zS_o-zC)/(yS_o-yC));
varargout{1}=beta_o;

% ! electron trajectory Y_e(z)!
Y_e = @(z) (z<=zS_o).*(yC+sqrt(Rc^2-(z-zC).^2))...
          +(z> zS_o).*(yS_o+(z-zS_o)*tan(beta_o));
varargout{2}=Y_e;
%%
options=optimoptions('fsolve','Display','off');
if(strcmp(LANEX,'LE')==1)
    Screen = @(z) (z<=700).*(-135)+(z>700).*(-300);
    fun = @(z) Y_e(z)-Screen(z);
    Z=fsolve(fun,600,options); % longitudinal intersection with LANEX

    if(Z>=700)
    display('out of lowE LANEX !')    
    end
end
if(strcmp(LANEX,'HE')==1)
    Screen = @(z) (z<750).*(-300)+ (z>=750).*(sqrt(40^2-29^2)/29*(z-750)-295);
    fun = @(z) Y_e(z)-Screen(z);
    Z=fsolve(fun,600,options); % longitudinal intersection with LANEX
    varargout{1}=acos(29/40)-beta_o;
    if(Z<750)
        display('out of highE LANEX !')
    end
end

end