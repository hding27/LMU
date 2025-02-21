%% Preparation
cd('O:\ATLAS_Permormace\20151106_Spatial_Chirp');
xx=5.7:0.2:7.5;
yy=7.2:0.2:8.4;
[X,Y]=ndgrid(xx,yy);
myDir=dir('Spec*');
L=length(myDir);
peak=zeros(1,L);
%%
roi=1900:2600;
sP=zeros(length(roi),L);
N=1;
filter=ones(N,1)/N;
for i=1:L
    data=importdata(myDir(i).name,'\t',17);
    lambda=data.data(:,1);
    spec=data.data(:,2);
    specF=conv(spec,filter,'same');
    sP(:,i)=specF(roi)/max(specF);
    [val,pos]=max(specF);
    peak(i)=lambda(pos);

end
wL=lambda(roi);
%%
figure(3),plot(wL,sP(:,1:10));
figure(4),plot(wL,sP(:,11:end));
%%
% N_200=peak;
% save('Res.mat','N_200','-append');
%%
N_200=peak;
chirpX=N_200(1:10);
chirpY=N_200(11:end);
