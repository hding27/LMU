function T = centroid(x,N)
%x=link;
%N=500;
X=double(imread(x));
X=X(:,:,1);
%imshow(I)
%X=medfilt2(X);
X=mat2gray(X);
%rect=[252,203,636,636];
%X=imcrop(X,rect);
%[mii,nii]=size(X);
%X=imcrop(X,rect);
G=X;
%H=I2(:,:,1);
%imshow(H)
[mi,ni]=size(G);
S=max(max(G));
%intensityfilter
for ii=1:mi;
for jj=1:ni;
if G(ii,jj)<=S/2;
G(ii,jj)=0;
end
end
end
G=G/sum(G(:));
[I,J]=ndgrid(1:mi,1:ni);
I=single(I);
J=single(J);
cent=[dot(J(:),G(:)),dot(I(:),G(:))];
%recta=[fix(cent(1)-N/2),fix(cent(2)-N/2),499,499];
%T=imcrop(X,recta);
T=X;
%figure(1);
%imshow(T)
%figure(2);imshow(X)
%hold on
%plot(cent(1),cent(2),'r.','MarkerSize',20);
%figure(2);imshow(X);
end