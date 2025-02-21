function varargout = epointing_v1(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @epointing_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @epointing_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end




function epointing_v1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


% set close function
set(handles.epointing_main_fig,'CloseRequestFcn',@closeGUI);


% open handles to image
handles.img = mcacheckopen('EDAQ:CAM:XSPEC:WVF');
xx = mcaget(mcacheckopen('EDAQ:CAM:XSPEC:X'));
yy = mcaget(mcacheckopen('EDAQ:CAM:XSPEC:Y'));

handles.raw     = zeros(10,xx*yy);
handles.howmany = 10;

handles.axes1_xlim = [1 xx];
handles.axes1_ylim = [1 yy];
set(handles.epointing_axes1,'Xlim',handles.axes1_xlim);
set(handles.epointing_axes1,'Ylim',handles.axes1_ylim);

handles.axes2_xlim = [1 xx];
handles.axes2_ylim = [1 yy];
set(handles.epointing_axes2,'Xlim',handles.axes2_xlim);
set(handles.epointing_axes2,'Ylim',handles.axes2_ylim);


% install monitors
mcamon(handles.img,'epointing_update_v1');


if ~mcamontimer
    mcamontimer('start')
end


% update handles structure
guidata(hObject, handles);

end




function varargout = epointing_v1_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
end




function closeGUI(src,evnt)


% clear monitor handles
monitor_handles = mcamon;
for ii=1:length(monitor_handles)
    mcaclearmon(monitor_handles(ii));
end

% clear PV handles
pv_handles = mcaopen;
for ii=1:length(pv_handles)
    mcaclose(pv_handles(ii));
end

if mcamontimer
    mcamontimer('stop');
end

delete(gcf);

end


% --- Executes on button press in epointing_reset.
function epointing_reset_Callback(hObject, eventdata, handles)

xx = mcaget(mcacheckopen('EDAQ:CAM:XSPEC:X'));
yy = mcaget(mcacheckopen('EDAQ:CAM:XSPEC:Y'));

handles.raw     = zeros(20,xx*yy);

% plot current image
img = zeros(xx,yy);

set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes1);
oldXlim = get(handles.epointing_axes1,'Xlim');
oldYlim = get(handles.epointing_axes1,'Ylim');
imagesc(img,'parent',handles.epointing_axes1,[0 20]);
    set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes1);
    set(handles.epointing_axes1,'Visible','Off');
    set(handles.epointing_axes1,'Xlim',oldXlim);
    set(handles.epointing_axes1,'Ylim',oldYlim);
    colormap jet;
    axis ij;
     caxis([0 20]);
    
% plot summed images
set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes2);
oldXlim = get(handles.epointing_axes2,'Xlim');
oldYlim = get(handles.epointing_axes2,'Ylim');
imagesc(img,'parent',handles.epointing_axes2,[0 20]);
    set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes2);
    set(handles.epointing_axes2,'Visible','Off');
    set(handles.epointing_axes2,'Xlim',oldXlim);
    set(handles.epointing_axes2,'Ylim',oldYlim);
    colormap jet;
    axis ij;
    caxis([0 20]);

% update handles structure
guidata(hObject, handles);


end
