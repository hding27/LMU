%LightPipesforMatlab
%Phasereconstruction
m=1; nm=1e-9*m; um=1e-6*m; mm=1e-3*m; cm=1e-2*m;
rad=1;
lambda=780*nm;
size=55*1e-3*mm;
N=200;
z=0.05*mm;
%Readtheexperimentaldataofthenearandthefarfield
%intensitypatternsfromdisk:
x=('lion1small.png');
Inear=centroid(x,N);
%Inear=average(Inear,N);
%Inear=mat2gray(Inear);
y=('pengu1small.png');
Ifar=centroid(y,N);
%Ifar=average(Ifar,N);
%Inew=fileout(v,N);
%rect=[1068,574,790,790];
%Inew=imcrop(Inew,rect);
F=LPBegin(size,lambda,N);
FnearOrg=LPSubIntensity(Inear,F);
InearOrg=LPIntensity(1,FnearOrg);
FfarOrg=LPSubIntensity(Ifar,F);
IfarOrg=LPIntensity(1,FfarOrg);
%Wavefrontretrievalloop!
for ij=2
    %a=2^(ij-1)
    n=10;
    %5*a;
    SizeNew=size;%10*mm;
    Nnew=N;%250;
    %starttheiteration:
    F=LPBegin(size,lambda,N);
    for k=1:n;
        %progress(k,n,1);
        F=LPSubIntensity(Ifar,F);
        F=LPForvard(z,F);
        %F=LPInterpol(size,N,0,0,0,1,F);
        F=LPSubIntensity(Inear,F);
        F=LPSubPhase(-LPPhase(F),F);
        F=LPForvard(z,F);
        %F=LPSubIntensity(Inew,F);
        %F=LPSubPhase(-LPPhase(F),F);
        %F=LPForvard(-2*z,F);
        F=LPSubPhase(-LPPhase(F),F);
    end
    %Imagesprintedout
    FfarRec=F;
    IfarRec=LPIntensity(1,FfarRec);
    F=LPSubIntensity(Ifar,F);
    FnearRec=LPFresnel(z,F);
    FnearR=LPForvard(z,F);
    InearRec=LPIntensity(1,FnearR);
    %fori=1:21
    %tre=(-100+(i-1)*100/10)*10^(-6)
    %Figar=LPForvard(tre,FfarRec);
    %iftre==0;
    %Figar=FfarRec;
    %end
    %Ifigar=LPIntensity(1,Figar);
    %figure(i+20);
    %imshow(Ifigar);colormapparula
    %Figar=FfarRec;
    %end
    Fhalfz=LPForvard(z/2,F);Ihalfz=LPIntensity(1,Fhalfz);
    Ftwoz=LPForvard(2*z,F);Itwoz=LPIntensity(1,Ftwoz);
    Fmhalfz=LPForvard(-z/2,F);Imhalfz=LPIntensity(1,Fmhalfz);
    Fmz=LPForvard(-z,F);Imz=LPIntensity(1,Fmz);
    Fmtwoz=LPForvard(-2*z,F);Imtwoz=LPIntensity(1,Fmtwoz);
    figure(1);subplot(1,3,1);imshow(InearOrg);
    figure(56);imshow(InearRec);colormap parula
    %subplot(1,3,3);imshow(InearOrg-InearRec);colormapparula;
    %print-dmeta'..nfiguresnman00271';
    figure(2);subplot(1,3,1);imshow(IfarOrg);colormap parula
    subplot(1,3,2);imshow(IfarRec);
    subplot(1,3,3);imshow(IfarOrg-IfarRec);colormap parula;
    %%print-dmeta'..nfiguresnman00272';
    %B(ij)=mean2(IfarOrg-IfarRec)
    %C(ij)=std2(IfarOrg-IfarRec)
    %D(ij)=mean2(InearOrg-InearRec)
    %E(ij)=std2(InearOrg-InearRec)
end

PhiRec=LPPhase(FnearRec);
PhiRec=LPPhaseUnwrap(1,PhiRec);

%clean up phase if low intensity, meaningless anyway
%Though Lenny: Do not use this for further caluclation, better keep
%phase!?
for ii=1:N;
    for jj=1:N;
        if InearRec(ii,jj)==0;
            PhiRec(ii,jj)=0;
        end
    end
end

figure(3);
%
surf(PhiRec);zlabel('Phase(rad)','FontSize',15);
xlabel('Pixel','FontSize',15);
ylabel('Pixel','FontSize',15');colormap(parula);
shading interp;axis on;view(-70,50);
%%print-dmeta'..nfiguresnman00273';
%%figure(4);;
%%d=1:500;
%%imshow(IfarOrg-IfarRec);
%%Y=Y(250,:);
%%Y=fft(Y);
%%plot(d,Y)
%figure(5);
%
%subplot(1,7,1);imshow(Imtwoz);title('-100um');
%subplot(1,7,2);imshow(Imz);title('-50um');
%subplot(1,7,3);imshow(Imhalfz);title('-25um');
%subplot(1,7,4);imshow(IfarRec);title('0um');
%subplot(1,7,5);imshow(Ihalfz);title('25um');
%subplot(1,7,6);imshow(InearRec);title('50um');
%subplot(1,7,7);imshow(Itwoz);title('100um');
%%figure(6);
%%subplot(1,2,1);imshow(Itwoz);title('100um');
%%subplot(1,2,2);imshow(Inew);