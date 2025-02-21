
mca;

hfront = figure;

mcaclose(mcacheckopen('CAM:BEAST1:WVF1'))
mcaclose(mcacheckopen('CAM:BEAST1:WVF2'))
mcaclose(mcacheckopen('CAM:BEAST1:WVF3'))
mcaclose(mcacheckopen('CAM:BEAST1:WVF4'))

CAM_BEAST1_WVF1 = mcaopen('CAM:BEAST1:WVF1');
CAM_BEAST1_WVF2 = mcaopen('CAM:BEAST1:WVF2');
CAM_BEAST1_WVF3 = mcaopen('CAM:BEAST1:WVF3');
CAM_BEAST1_WVF4 = mcaopen('CAM:BEAST1:WVF4');

all = zeros(10,1280,960);

while 1

idx = idx + 1;
idx = mod(idx,10);

p1 = mcaget(CAM_BEAST1_WVF1);
p2 = mcaget(CAM_BEAST1_WVF2);
p3 = mcaget(CAM_BEAST1_WVF3);
p4 = mcaget(CAM_BEAST1_WVF4);

img = [p1 p2 p3 p4];
img = uint8(img);
img = reshape(img,1280,960);

all(idx,:,:) = img;

imagesc(img);
colormap(hot);
caxis([0 255]);
colorbar;

end

