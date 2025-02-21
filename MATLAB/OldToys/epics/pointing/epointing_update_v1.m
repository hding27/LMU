function epointing_update_v1

mcamontimer('stop');
pause(2);
try

% get gui handles
handles = guidata(findall(0,'Tag','epointing_main_fig'));

% get image from camera
img = mcacache(handles.img);
%img = uint8(img);s

% sum up
handles.raw         = circshift(handles.raw,1);
handles.raw(1,:)    = img;
summed              = sum(handles.raw(1:handles.howmany,:))/handles.howmany;

xx = mcaget(mcacheckopen('EDAQ:CAM:XSPEC:X'));
yy = mcaget(mcacheckopen('EDAQ:CAM:XSPEC:Y'));

summed  = reshape(summed,xx,yy)';
img     = reshape(img,xx,yy)';


% plot current image
set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes1);
oldXlim = get(handles.epointing_axes1,'Xlim');
oldYlim = get(handles.epointing_axes1,'Ylim');
imagesc(img,'parent',handles.epointing_axes1,[0 64]);
    set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes1);
    set(handles.epointing_axes1,'Visible','Off');
    set(handles.epointing_axes1,'Xlim',oldXlim);
    set(handles.epointing_axes1,'Ylim',oldYlim);
    colormap jet;
    caxis([0 20])
    axis ij;
    
    
% plot summed images
set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes2);
oldXlim = get(handles.epointing_axes2,'Xlim');
oldYlim = get(handles.epointing_axes2,'Ylim');
imagesc(summed,'parent',handles.epointing_axes2,[0 64]);
    set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes2);
    set(handles.epointing_axes2,'Visible','Off');
    set(handles.epointing_axes2,'Xlim',oldXlim);
    set(handles.epointing_axes2,'Ylim',oldYlim);
    colormap jet;
    caxis([0 20])
    axis ij;


% update guidata
guidata(findall(0,'Tag','epointing_main_fig'), handles);
catch err
    disp(err);
end
mcamontimer('start');

end

