function epointing_update_v1

mcamontimer('stop');
pause(2);
try

% get gui handles
handles = guidata(findall(0,'Tag','epointing_main_fig'));

% get image from camera
img1 = mcacache(handles.img1);
img2 = mcacache(handles.img2);
img3 = mcacache(handles.img3);
img4 = mcacache(handles.img4);
img = [img1 img2 img3 img4];
%img = uint8(img);s

% sum up
handles.raw         = circshift(handles.raw,1);
handles.raw(1,:)    = img;
summed              = sum(handles.raw(1:handles.howmany,:))/handles.howmany;

summed  = reshape(summed,1280,960)';
img     = reshape(img,1280,960)';


% plot current image
set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes1);
oldXlim = get(handles.epointing_axes1,'Xlim');
oldYlim = get(handles.epointing_axes1,'Ylim');
imagesc(img,'parent',handles.epointing_axes1,[0 128]);
    set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes1);
    set(handles.epointing_axes1,'Visible','Off');
    set(handles.epointing_axes1,'Xlim',oldXlim);
    set(handles.epointing_axes1,'Ylim',oldYlim);
    colormap jet;
    axis ij;
    
    
% plot summed images
set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes2);
oldXlim = get(handles.epointing_axes2,'Xlim');
oldYlim = get(handles.epointing_axes2,'Ylim');
imagesc(summed,'parent',handles.epointing_axes2,[0 128]);
    set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes2);
    set(handles.epointing_axes2,'Visible','Off');
    set(handles.epointing_axes2,'Xlim',oldXlim);
    set(handles.epointing_axes2,'Ylim',oldYlim);
    colormap jet;
    axis ij;


% do statistics and get long-term drift
x = 1:1280;
y = 1:960;    
[XCenter XWidth] = get_peak(x,sum(summed,1));
[YCenter YWidth] = get_peak(y,sum(summed,2)');

handles.allcx(end+1) = XCenter;
handles.allcy(end+1) = YCenter;
handles.allwx(end+1) = XWidth;
handles.allwy(end+1) = YWidth;

ll = length(handles.allcx);
if ll > 100
    idx = ll-100:ll;
else
    idx = 1:ll;
end

set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes3);
plot(idx,handles.allcx(idx),'b',idx,handles.allcy(idx),'r');
ylabel('pointing drift');

set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes4);
plot(idx,handles.allwx(idx),'b',idx,handles.allwy(idx),'r');
ylabel('pointing jitter');


% update guidata
guidata(findall(0,'Tag','epointing_main_fig'), handles);
catch er
end
mcamontimer('start');

end




function [peak width] = get_peak(x,y)
% [peak width] = get_peak(x,y)
% width is rms

    peak    = sum(x.*y) / sum(y);
    width   = sqrt(var(x,y));           % rms width

end
