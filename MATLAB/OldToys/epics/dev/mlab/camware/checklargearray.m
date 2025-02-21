
mca

if ~mcaisopen('CAM:BEAST1:WVF')
    handle = mcaopen('CAM:BEAST1:WVF');
end

data = mcaget(handle);

data(:) = 1;

mcaput(handle,data);

