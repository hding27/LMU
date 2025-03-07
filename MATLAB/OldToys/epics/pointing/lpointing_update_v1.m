function lpointing_v1_update


%mcamontimer('stop');


% get gui handles
handles = guidata(findall(0,'Tag','lpointing_main_fig'));
try
% get image from camera
img = mcacache(handles.img);
img = uint8(img);

% sum up
handles.raw         = circshift(handles.raw,1);
handles.raw(1,:)    = img;
summed              = sum(handles.raw(1:handles.howmany,:));

summed  = reshape(summed,640,480)';
img     = reshape(img,640,480)';


% plot current image
set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes1);
oldXlim = get(handles.lpointing_axes1,'Xlim');
oldYlim = get(handles.lpointing_axes1,'Ylim');
imagesc(img,'parent',handles.lpointing_axes1,[0 100]);
    set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes1);
    set(handles.lpointing_axes1,'Visible','Off');
    set(handles.lpointing_axes1,'Xlim',oldXlim);
    set(handles.lpointing_axes1,'Ylim',oldYlim);
    colormap hot;
    axis xy;
    
    
% plot summed images
set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes2);
oldXlim = get(handles.lpointing_axes2,'Xlim');
oldYlim = get(handles.lpointing_axes2,'Ylim');
imagesc(img,'parent',handles.lpointing_axes2,[0 255]);
    set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes2);
    set(handles.lpointing_axes2,'Visible','Off');
    set(handles.lpointing_axes2,'Xlim',oldXlim);
    set(handles.lpointing_axes2,'Ylim',oldYlim);
    colormap hot;
    axis xy;


% do statistics and get long-term drift
x = 1:640;
y = 1:480;    
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

set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes3);
plot(idx,handles.allcx(idx),'b',idx,handles.allcy(idx),'r');
ylabel('pointing drift');

set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes4);
plot(idx,handles.allwx(idx),'b',idx,handles.allwy(idx),'r');
ylabel('pointing jitter');


energy = sum(sum(img));
if isempty(handles.energyref)
    handles.energyref = energy;
end
handles.allenergy(end+1) = energy / handles.energyref;
handles.allenergyjitter(end+1) = sqrt(var(handles.allenergy(idx)));

set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes5);
plot(idx,handles.allenergy(idx),'b');
ylim([0.9 1.1]);
ylabel('energy drift');

set(handles.lpointing_main_fig,'CurrentAxes',handles.lpointing_axes6);
plot(idx,handles.allenergyjitter(idx)*100,'b');
ylim([0 2]);
ylabel('energy jitter (%)');


catch err
end   
% update guidata
guidata(findall(0,'Tag','lpointing_main_fig'), handles);

%mcamontimer('start');

end




function [peak width] = get_peak(x,y)
% [peak width] = get_peak(x,y)
% width is rms

    peak    = sum(x.*y) / sum(y);
    width   = sqrt(var(x,y));           % rms width

end
