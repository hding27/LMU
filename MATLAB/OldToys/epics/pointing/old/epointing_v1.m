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
handles.img1 = mcacheckopen('EDAQ:CAM:EPOINTING:WVF1');
handles.img2 = mcacheckopen('EDAQ:CAM:EPOINTING:WVF2');
handles.img3 = mcacheckopen('EDAQ:CAM:EPOINTING:WVF3');
handles.img4 = mcacheckopen('EDAQ:CAM:EPOINTING:WVF4');

handles.raw     = zeros(20,1280*960);
handles.howmany = 10;

handles.axes1_xlim = [0 1280];
handles.axes1_ylim = [0 960];
set(handles.epointing_axes1,'Xlim',handles.axes1_xlim);
set(handles.epointing_axes1,'Ylim',handles.axes1_ylim);

handles.axes2_xlim = [0 1280];
handles.axes2_ylim = [0 960];
set(handles.epointing_axes2,'Xlim',handles.axes2_xlim);
set(handles.epointing_axes2,'Ylim',handles.axes2_ylim);


% centers and widths
handles.allcx = [];
handles.allcy = [];
handles.allwx = [];
handles.allwy = [];


% install monitors
mcamon(handles.img1,'epointing_update_v1');
mcamon(handles.img2);
mcamon(handles.img3);
mcamon(handles.img4);

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


handles.raw     = zeros(20,1280*960);


% plot current image

img = zeros(1280,960);

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
imagesc(img,'parent',handles.epointing_axes2,[0 128]);
    set(handles.epointing_main_fig,'CurrentAxes',handles.epointing_axes2);
    set(handles.epointing_axes2,'Visible','Off');
    set(handles.epointing_axes2,'Xlim',oldXlim);
    set(handles.epointing_axes2,'Ylim',oldYlim);
    colormap jet;
    axis ij;

% update handles structure
guidata(hObject, handles);


end
