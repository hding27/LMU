clear all
%addpath('O:\Ludwig\Matlab\timeevolution')
addpath(genpath('O:\Ludwig\Matlab'))
lambda = 880e-9;
lambda_um = 0.88;
c = 3e8;
w_l = 2*pi*c / lambda;
eps = 8.854e-12;
m_e = 9.1e-31;
q = -1.6e-19;
%M = 3.472; %2.12.16
M=3.676; %8.9.16

n_c = ((w_l)^2 * eps * m_e) / (q^2 * 100^3);
const = n_c / (pi * M)

edens = zeros(600,1);

%test = load('O:\Ludwig\Matlab\Thesis\8.9.16_error_mask\20160908_16bar_1327_phase_map_normal_mask_lineout_x1204_69_278_abel.asc');


files = dir('O:\Ludwig\Matlab\Thesis\8.9.16_error_mask\*.asc');
%files = dir('O:\Ludwig\Matlab\Thesis\8.9.16_shock_lineout\lineout_for_fit\1418_12bar_after_shock_abel.asc');
%files = dir('O:\Ludwig\Matlab\20121202\Abel\1st_jet\20121202_mean_17.5bar_1stjet_x=802px_4ps_abel.asc');
%files = dir('O:\Ludwig\Matlab\Thesis\2.12.16_lower_channel_scan\14bar_66.84s_delay\*.asc');
%files = dir('O:\Ludwig\Matlab\timeevolution\14bar_nowafer_41pxstep\*.asc');
%files = dir('O:\Ludwig\Matlab\Thesis\8.9.16_pressure_scan\upper_channel\Abel\20160908_8bar_nowafer_upperchannel_lineout_Abel.asc');
%files = dir('O:\Ludwig\Matlab\Thesis\8.9.16_long_lineout\linouts_41pxstep_new_forthesis_abel\20160908_14bar_nowafer_phasemapAbel1372-1001_44_268_abel.asc');
for i=1:length(files)
    A{:,i} = dlmread(files(i).name);
    A{:,i} = (((lambda_um * n_c) / (pi * M)) .* A{:,i});
    bg(i) = min(cell2mat(A(i)));
    middle(i) = length(A{i}) / 2;
    
    edens(1:600,i) = 0;
    edens(300 - floor(middle(i)):length(A{i})+ 299 - floor(middle(i)),i) = A{i} - bg(i);
    
    esum(i) = trapz(edens(:,i)); 
    lin(i) = edens(300,i);
    figure(1)
    subplot(6,4,i);
    plot(edens(:,i))
   
end
x_axis = (-299:1:300)*3.676e-3;  %8.9.16
%x_axis = (-299:1:300)*3.472e-3;   %2.12.16

figure(7)
plot(x_axis,edens);

figure(2)
mesh(edens);

figure(3)
plot(esum);

figure(4)
plot(lin);
