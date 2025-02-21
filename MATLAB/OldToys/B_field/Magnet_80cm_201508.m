%%clean
cd('./B_field')
load('d_tot_only');
zz=d_tot.zi;
yy=d_tot.yi;
xx=d_tot.xi;
B_raw=d_tot.Bx;
B_scaled=d_tot.Bx_scaled;
[Y,Z]=ndgrid(yy,zz);
%%
B=B_raw(7,:,:);
B=reshape(B,[177,818]);
figure,surf(Y,Z,B,'line','none'),axis 'tight'
%%
B=B_scaled(6,:,:);
B=reshape(B,[177,818]);
figure,surf(Y,Z,B,'line','none'),axis 'tight'
%%
% B_spec=(fft2(B));
% B_spec(abs(real(B_spec))<1e5)=0;
% figure,imagesc(((real(B_spec))))
% %
% B_filt=ifft2(B_spec);
% figure,surf(Y,Z,B_filt,'line','none'),axis 'tight'
%%
% N_filt=10;
% sigma_filt=10;
% %// Generate horizontal and vertical co-ordinates, where
% %// the origin is in the middle
% ind= -floor(N_filt/2) : floor(N_filt/2);
% [X_filt , Y_filt] = meshgrid(ind, ind);
% 
% %// Create Gaussian Mask
% kern_filt = exp(-(X_filt.^2 + Y_filt.^2) / (2*sigma_filt*sigma_filt));
% 
% %// Normalize so that total area (sum of all weights) is 1
% kern_filt = kern_filt / sum(kern_filt(:));
% 
% B_filt=conv2(B,kern_filt,'same');
% figure,surf(Y,Z,B_filt,'line','none'),axis 'tight'
%%
B6_raw=B_raw(6,:,:);
B6=reshape(B6_raw,[177,818]);
figure(99),surf(Y,Z,B6,'line','none')

%%
B1=B_scaled(8,:,:);
B1=reshape(B1,[177,818]);
figure,surf(Y,Z,(B-B1),'line','none'),axis 'tight'
%% remove z discontinuities
B_smooth=B_scaled;
tol=2;
tic
for i=3:8
    for j=3:177
        for k= 3:818
        diff=B_smooth(i,j,k)-mean(mean(mean(B_smooth(i-2:i,j-2:j,k-2:k))));
        if (abs(diff)>tol)
            B_smooth(i,j,k)=B_smooth(i,j,k)-round(diff);
        end
        end
        
    end
end
toc
%% remove y discontinuities
tol=1;
tic
for i=1:8
    for k=1:818
        for j= 100:110
        diff=B_smooth(i,j,k)-B_smooth(i,j-1,k);
        if (abs(diff)>tol)
            B_smooth(i,j:end,k)=B_smooth(i,j:end,k)*B_smooth(i,j-1,k)/B_smooth(i,j,k);
            
        end
        end
        
    end
end
toc

%%
B=B_smooth(7,:,:);
B=reshape(B,[177,818]);
figure,surf(Y,Z,B,'line','none'),axis 'tight'
%%
% tic
% B=B_smooth/1000;
% x=xx/1000;
% y=yy/1000;
% z=zz/1000;
% fID=fopen('201508_B-field_80cm.txt','w');
% fprintf(fID,'%-8s %-8s %-8s %-12s %-8s %-8s \r\n','X','Y','Z','Bx','By','Bz');
% for i=1:8
%     for j=1:177
%         for k=1:818
%         fprintf(fID,'%-8g %-8g %-8g %-12g %-8g %-8g \r\n',x(i),y(j),z(k),B(i,j,k),0,0);
%         end
%     end
% end
% fclose(fID);
% toc