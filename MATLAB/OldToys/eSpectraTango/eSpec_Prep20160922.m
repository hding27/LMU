path = 'O:\Electrons\20160922';
data = eSpecLowE(path)
%%
file = [path '\eSPecLowE\20160922_025_1888_eSpecLowE.png'];
img = imread(file);
figure(99),imshow(img,[1 1000])
%%
data.setBackground(102)
data.ImageSize = [235,1609]
data.ScreenMarks = [[476,868,1227,1536]-118; 400,500,600,700]'
data.calibrateEnergyScale
data.RoiTritium = [1,23;737,777]
data.calibrateTritium
data.saveChanges
%%

path =  'O:\Electrons\20160922\'; % path to where the data are stored
eData = eSpecLowE(path)
plot(eData.PixelPosition,eData.EnergyScale)
eData.getShot(884)
%eData.getRun(3)