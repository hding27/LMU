path = 'O:\Electrons\20160919';
data = eSpecLowE(path)
%%
file = [path '\eSPecLowE\20160919_003_0296_eSpecLowE.png'];
img = imread(file);
figure(99),imshow(img,[1 2000])
%%
data.setBackground(52)
data.ImageSize = [235,1609]
data.ScreenMarks = [[476,868,1227,1536]; 400,500,600,700]'
data.calibrateEnergyScale
data.RoiTritium = [1,23;855,895]
data.calibrateTritium
data.saveChanges
%%

path =  'O:\Electrons\20160919\'; % path to where the data are stored
eData = eSpecLowE(path)
plot(eData.PixelPosition,eData.EnergyScale)
eData.getShot(884)
eData.getRun(3)