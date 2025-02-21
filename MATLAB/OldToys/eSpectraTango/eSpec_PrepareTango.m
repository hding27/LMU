path = 'O:\Electrons\20161025';
data = eSpecLowE(path);
%%
file = [path '\eSPecLowE\20161025_000_0196_eSpecLowE.png'];
img = imread(file);
figure(99),imshow(img,[1 2000])
%%
data.setBackground(2)
data.ImageSize = [120,1240]
data.ScreenMarks = [[-20,217,447,877,1061,1218]+9;100,200,300,500,600,700]'
data.calibrateEnergyScale
data.RoiTritium = [13,23;866,890]
data.calibrateTritium
data.saveChanges