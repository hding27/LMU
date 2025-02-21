
function x=mychirp(t,f0,t1,f1,phase)
%Y = mychirp(t,f0,t1,f1) generates samples of a linear swept-frequency
 
%   signal at the time instances defined in timebase array t.  The instantaneous
 
%   frequency at time 0 is f0 Hertz.  The instantaneous frequency f1
 
%   is achieved at time t1.
 
%   The argument 'phase' is optional. It defines the initial phase of the
 
%   signal degined in radians. By default phase=0 radian
 
    
if nargin==4
    phase=0;
end
    t0=t(1);
    T=t1-t0;
    k=(f1-f0)/T;
    x=cos(2*pi*(k/2*t+f0).*t+phase);
end



fs=500; %sampling frequency
t=0:1/fs:1; %time base - upto 1 second
 
f0=1;% starting frequency of the chirp
f1=fs/20; %frequency of the chirp at t1=1 second
x = mychirp(t,f0,1,f1); 
subplot(2,2,1)
plot(t,x,'k');
title(['Chirp Signal']);
xlabel('Time(s)');
ylabel('Amplitude');