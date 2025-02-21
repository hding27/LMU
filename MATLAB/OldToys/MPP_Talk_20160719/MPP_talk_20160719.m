%% Initializaton
Initialized = exist('Initialized','var');
if(~Initialized)
    run('Initialization_20160719.m');
    display('Successfully initialized.')
end

%% process spectra
I = imread('20160714_000_5980_eSpecLowE.png');
I = double(I);
I_tri  = I (PosTri(2):PosTri(4),PosTri(1):PosTri(3)); % rigion of T-capsule
I_spec = I(PosPx(1):PosPx(2),A_Px)-I_bkg(PosPx(1):PosPx(2),A_Px);
I_spec = I_spec/sum(sum(I_tri))/2.21*10*0.2;
A_Charge = sum(sum(I_spec));
display(A_Charge);

%% plot spectra
figure(86),h=pcolor(A_En,A_X,4*I_spec*diag(d_En.^-1.*cos(A_An).^-1));
set(h,'linestyle','none')
xlabel('Energy (MeV)','FontSize',16);
ylabel('Distance (mm)','FontSize',16);
colorbar
set(gca,'FontSize',16)