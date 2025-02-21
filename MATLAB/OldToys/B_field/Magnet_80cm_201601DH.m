%% load raw data
load('d1raw');
D1 = d_a;
clear('d_a');
load('d2raw');
D2 = d;
load('d3raw');
D3 = d;
load('d4raw');
D4 = d;
clear('d')

%% plot the slices of the magnetic fields
[M1Y,M1X,M1Z] = meshgrid(D1.y,D1.x,D1.z);
% sx, sy, sz, are the x,y,z postion where you want to see slices, respectively
sx = 0;
sy = 0;
sz = [347, 600, 800];
figure,slice(M1Y,M1X,M1Z,D1.By,sx,sy,sz); 
title('By 1');
figure,slice(M1Y,M1X,M1Z,D1.Bx,sx,sy,sz); 
title('Bx 1');
figure,slice(M1Y,M1X,M1Z,D1.Bz,0,0,400);
title('Bz 1');

[M2Y,M2X,M2Z] = meshgrid(D2.y,D2.x,D2.z);
figure,slice(M2Y,M2X,M2Z,D2.By,0,0,100);
title('By 2');
figure,slice(M2Y,M2X,M2Z,D2.Bz,0,0,100);
title('Bz 2');