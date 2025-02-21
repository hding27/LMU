% this script analyses the pressure scan on 2016-09-08
% nonrel. and relativistic plasma wavelengths are retrieved and plottd
% contact Hao.Ding@physik.uni-muenchen.de for support

%% set up working environment
addpath(genpath('\\z-sv-pool08\Hao.Ding\MATLAB\HDingMatlabTools\'));
myDir = 'O:\Electrons\20160908\';
addpath(genpath(myDir));
Probe = Probe(myDir);
resolution = Probe.PixelSize(1); % 1.168 um per px
Druck = [4,   6,   8,   10,  12,  14,  16,  18.7]; % set prssure of the runs
runW  = [22,  19,  18,  15,  14,  11,  10,  6];  % runs with shockfront
runWo = [21,  20,  17,  16,  13,  12,  9,   7];  % without shockfront
%% calculate the non-relativistic an drelativistic plasma wavelengths
lp0  = [25.0 23.5 23.3 21.5 20.0 19.0 18.2 17.1]; % prior of plasma wavelength
ROI = [800, 960; 1, 2048]; % [top, bottom; left, right] of the input image
buffer = 50; % to be cropped after rotating image
delta = 3; % half width of the wavelength window to explore
for ii = find(Druck == 12);
    shots = Probe.No(Probe.Run==runWo(ii)); % shots to be analysed
    if(runWo(ii)==6)
        shots = (1271:1293)'; 
    end
    if(runWo(ii)==7)
        shots = [1256:1258 1261:1270, 1294:1303]'; 
    end
    lambdaP = zeros(length(shots),5); % non-rel. and rel. plasma wavelengths and errs
    wl_roi = [lp0(ii)-delta, lp0(ii)+delta]; % shortest/longest wavelength of interest, in um
    for jj = 1:length(shots);
        fileName = [myDir, 'Probe/', char(Probe.FileName(Probe.No == shots(jj)))];
        A_full = imread(fileName);
        figure(jj)
        pwLength = NonlinearPW(A_full, ROI, buffer, wl_roi, resolution, shots(jj));
        lambdaP(jj,:) = pwLength;
    end
end
% correct the value of plasma wavelength
value = lambdaP(:,2);
xxx = lambdaP;
value(value==0)=[];
avg = mean(value);
for ii=1:size(lambdaP,1)
    if(lambdaP(ii,2)<avg)
        xxx(ii,:)=lambdaP(ii,:);
        continue
    elseif( lambdaP(ii,2) < lambdaP(ii,4))
        xxx(ii,:)=lambdaP(ii,:);
        continue
    end  
    xxx(ii,2)=lambdaP(ii,4);
    xxx(ii,3)=lambdaP(ii,5);
    xxx(ii,4)=lambdaP(ii,2);
    xxx(ii,5)=lambdaP(ii,3);
end
%%
close all
value1 = xxx(:,2);
value1(value1==0)=[];
err1   = xxx(:,3);
err1(err1==0)=[];
figure(1),errorbar(value1,err1)
display([mean(value1),std(value1)/sqrt(length(value1)),std(value1)/mean(value1)])
title('linear');

value2 = xxx(:,4);
value2(value2==0)=[];
err2   = xxx(:,5);
err2(err2==0)=[];
figure(2),errorbar(value2,err2)
display([mean(value2),std(value2)/sqrt(length(value2)),std(value2)/mean(value2)])
display(mean(value2)/mean(value1))
title('nonlinear');
AAA = xxx;