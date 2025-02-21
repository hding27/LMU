
%%
path = 'O:\ATLAS_Performance\20170616_TitanProfile\';

filename = [path '3H-Camera_1-Camera-1_170616-170846.h5'];

info = hdf5info(filename);
image = hdf5read(filename,'/3H-Camera_1-Camera-1/instrument/ROIImage');
data = double(image);
figure(91), imagesc(data)

int_BKG = mean(mean(data(400:500,50:150)));
im_ROI = data(100:400,100:400)-int_BKG;
im_ROI(im_ROI>1500)=0;


figure(90), hist(im_ROI(:))
figure(89), imagesc(im_ROI)