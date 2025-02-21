point = dir('*1260*.asc');
for i=1:length(point)
    A{:,i} = dlmread(point(i).name);
end
%ascfiles = dlmread('20160908_1260_18bar_x=772px_+8ps_Backus-Abel.asc');
