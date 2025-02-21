P=1e5;
T=293;
E_i=21.7;

e=1.60217662e-19;
c=299792458;
hbar=1.0545718e-34;

k_B=1.38064852e-23;
m_e=9.10938356e-31;
e0=8.854187817620e-12;

rho=P/k_B/T;
omega_p=E_i/hbar*e;
n=sqrt(E_i/13.6);

n2=1e24*3.92e-2*rho*omega_p^-5/hbar/c/gamma(n+1)^2*(e^2*2^(4*n)/m_e/e0)^2

