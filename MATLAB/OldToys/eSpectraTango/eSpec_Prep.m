path =  'O:\Electrons\20161209';
eData = eSpecLowE(path)

%%
img = imread([path '\eSpecLowE\20161025_000_0044_eSpecLowE.png']);
figure,imshow(img,[1,900])
%%
eData.setBackground(2)

eData.RoiTritium = [12,23; 869,888]
eData.calibrateTritium

eData.ScreenMarks = [[-20,217,447,877,1061,1218]+7;100,200,300,500,600,700]';
eData.ImageSize = [235,1069];
eData.calibrateEnergyScale

eData.saveChanges

%%
plot(eData.PixelPosition,eData.EnergyScale)
path =  'O:\Electrons\20161209\'; % path to where the data are stored
eData = eSpecLowE(path);
eData.getShot(884)
eData.getRun(3)