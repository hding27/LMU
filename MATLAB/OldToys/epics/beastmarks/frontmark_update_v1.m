function frontmark_update_v1
% version 2011-05-14

%beep;
%mcamontimer('stop');

% wait for all data to be uploaded
pause(.5);

% get gui handles
handles = guidata(findall(0,'Tag','frontmark_main_fig'));


% assemble image from camera
img1    = mcacache(handles.img1);
img2    = mcacache(handles.img2);
img3    = mcacache(handles.img3);
img4    = mcacache(handles.img4);

img = [img1 img2 img3 img4];
img = uint8(img);


% sum up
handles.raw         = circshift(handles.raw,1);
handles.raw(1,:)    = img;
summed              = sum(handles.raw(1:handles.howmany,:));
summed              = reshape(summed,1280,960);


% reshape to image
img     = reshape(img,1280,960)';
summed  = reshape(summed,1280,960)';


% plot current image
set(handles.frontmark_main_fig,'CurrentAxes',handles.frontmark_axes1);
oldXlim = get(handles.frontmark_axes1,'Xlim');
oldYlim = get(handles.frontmark_axes1,'Ylim');
imagesc(img,'parent',handles.frontmark_axes1,[0 50]);
    set(handles.frontmark_main_fig,'CurrentAxes',handles.frontmark_axes1);
    set(handles.frontmark_axes1,'Visible','Off');
    set(handles.frontmark_axes1,'Xlim',oldXlim);
    set(handles.frontmark_axes1,'Ylim',oldYlim);
    colormap hot;
    axis ij;


% plot summed images
set(handles.frontmark_main_fig,'CurrentAxes',handles.frontmark_axes2);
oldXlim = get(handles.frontmark_axes2,'Xlim');
oldYlim = get(handles.frontmark_axes2,'Ylim');
imagesc(summed,'parent',handles.frontmark_axes2,[0 255]);
    set(handles.frontmark_main_fig,'CurrentAxes',handles.frontmark_axes2);
    set(handles.frontmark_axes2,'Visible','Off');
    set(handles.frontmark_axes2,'Xlim',oldXlim);
    set(handles.frontmark_axes2,'Ylim',oldYlim);
    colormap hot;
    axis ij;


% update guidata
guidata(findall(0,'Tag','frontmark_main_fig'), handles);

%mcamontimer('start');

end