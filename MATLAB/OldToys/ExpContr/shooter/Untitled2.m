clear all
clc

%loadlibrary('inpout32', 'inpout32h.h');
%loadlibrary('inpout32', 'inpout32h.h', 'mfilename', 'mx_inpout32')
loadlibrary ('inpout32',@mx_inpout32);
for(i=1:4)
    calllib('inpout32','Out32',hex2dec('378'),bin2dec('00000000'));
    pause(2);
    i
    calllib('inpout32','Out32',hex2dec('378'),bin2dec('00000001'));
    pause(2);
end

unloadlibrary 'inpout32'

display('done');