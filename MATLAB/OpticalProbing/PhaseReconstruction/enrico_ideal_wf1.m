%Theoretical comparison of the different methods
m=1; nm=1e-9*m; um=1e-6*m; mm=1e-3*m; cm=1e-2*m;
lambda=800*nm;
z=0.055*mm;
size=55*um;
N=500;
pixel=size/N;
X=1:N;
Y=1:N;
X=pixel*X;
Y=pixel*Y;
wo=lambda/6;
zr=pi*wo^2/lambda;
k=2*pi/lambda;
R=z*(1+(zr/z)^2);
for i=1:N
    for j=1:N
        Phase(i,j)=k*(X(i)-X(N/2))^2/(2*R)+k*(Y(j)-Y(N/2))^2/(2*R);
    end
end
Fr=LPBegin(size,lambda,N);
Fr=LPGaussHermite(0,0,1,wo,Fr);
I=LPIntensity(1,Fr);
F=LPForvard(z,Fr);
Ii=LPIntensity(1,F);
P=LPPhase(F);
P=LPPhaseUnwrap(1,P);
%P=P(:,53);
Fi=LPFresnel(z,Fr);
Iii=LPIntensity(1,Fi);
Pi=LPPhase(Fi);
Pi=LPPhaseUnwrap(1,Pi);
%Pi=Pi(:,250);
%imshow(P);
%Z=zeros(N,N);
%Z=(sqrt(Phase'))*(sqrt(Phase));
x=1:500;
figure;
surf(x,x,Phase);
shading interp;
%plot(x,P);hold on;plot(x,Phase);hold on;plot(x,Pi);