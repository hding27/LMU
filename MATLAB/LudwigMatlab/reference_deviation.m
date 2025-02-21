%addpath(genpath('O:\Ludwig\Matlab'))

phasemap_normal_org = load('O:\Ludwig\Matlab\Thesis\8.9.16_error_mask\20160908_16bar_1327_phase_map_normal_mask.asc');
phasemap_small_org = load('O:\Ludwig\Matlab\Thesis\8.9.16_error_mask\20160908_16bar_1327_phase_map_small_mask.asc');
phasemap_big_org = load('O:\Ludwig\Matlab\Thesis\8.9.16_error_mask\20160908_16bar_1327_phase_map_big_mask.asc');

phasemap_normal = phasemap_normal_org(920:1056,800:1432);
phasemap_normal = phasemap_normal-phasemap_normal(1,1);
phasemap_small = phasemap_small_org(920:1056,800:1432);
phasemap_small = phasemap_small-phasemap_small(1,1);
phasemap_big = phasemap_big_org(920:1056,800:1432);
phasemap_big = phasemap_big-phasemap_big(1,1);
[n, m] = size(phasemap_normal);
phase_matrix = zeros(n,m,1);
phase_matrix(:,:,1) = phasemap_normal;
phase_matrix(:,:,2) = phasemap_small;
phase_matrix(:,:,3) = phasemap_big;

stand = std(phase_matrix,1,3);

dev = (sum(sum(stand))/sqrt(sum(sum(phasemap_normal.^2))));

dev1 = sqrt(sum(sum(phasemap_normal-phasemap_big).^2)/sum(sum(phasemap_normal.^2)));
%files = dir('O:\Ludwig\Matlab\Thesis\8.9.16_error_mask\*.asc');
%for i=1:length(files)
  % A(:,:,i) = dlmread(files(i).name);
 
  %  A(:,:,i) = A(:,:,i)-A(1,1,i);
%end

%S = std(A,0,3);

%figure(1);     

%imagesc(S);
%colormap('jet');
%axis image;
%colorbar;
%%
a= sum(sum(phasemap_normal))
b=sqrt(sum(sum(phasemap_normal.^2)))
figure,imagesc(phasemap_normal)