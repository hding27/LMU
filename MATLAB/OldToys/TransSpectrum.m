Date='20160225';
DiagnosticName='OceanOptics';
KeyWord='*_1.txt';

cd(['O:\Electrons\' Date '\' DiagnosticName]);
myDir= dir(KeyWord);
%%
L=length(myDir);
N=1;
filter=ones(N,1)/N;

data=importdata(myDir(1).name,'\t',3);
lambda=data.data(:,1);
spec=data.data(:,2);
specF=conv(spec,filter,'same');

temp=lambda;
temp(temp>879)=[];
I2=length(temp);
temp(temp>741)=[];
I1=length(temp);

sP=zeros(I2-I1+1,L);
sP(:,1)=specF(I1:I2)/max(specF);
figure(100),plot(lambda(I1:I2),specF(I1:I2))
%%
tic
for i=2:L
    data=importdata(myDir(i).name,'\t',3);
    lambda=data.data(:,1);
    spec=data.data(:,2);
    specF=conv(spec,filter,'same');
    sP(:,i)=specF(I1:I2)/max(specF);
    i
end
toc
figure(101),imagesc(lambda(I1:I2),1:L,sP');
%%
figure(101),imagesc(lambda(I1:I2),1:L,sP');
