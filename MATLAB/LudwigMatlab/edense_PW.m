%addpath(genpath('O:\Ludwig\Matlab'))


c = 3e8;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
%M = 0.869e-6; %02.12.2016
M = 1.168e-6; %08.09.2016
%M = 0.581e-6; %05.08.2016
%M = 1.26e-6; %30.08.2016
PW_px = input('Length[px] of Plasmawave: ');
lambda_PW = PW_px*M;
lambda_PWneg = (PW_px-1)*M;
lambda_PWpos = (PW_px+1)*M;
w_p = (2*pi*c)/lambda_PW;
n_e = (w_p^2*eps*m_e)/(q^2*100^3)

err_neg = (lambda_PW-lambda_PWneg)/lambda_PW
err_pos = (lambda_PWpos-lambda_PW)/lambda_PW