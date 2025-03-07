function varargout = lpointing_v1(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lpointing_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @lpointing_v1_OutputFcn, ...
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




function lpointing_v1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


% set close function
set(handles.lpointing_main_fig,'CloseRequestFcn',@closeGUI);


% open handles to image
handles.img = mcacheckopen('EDAQ:CAM:LPOINTING:WVF');


handles.raw     = zeros(20,640*480);
handles.howmany = 10;

handles.axes1_xlim = [0 640];
handles.axes1_ylim = [0 480];
set(handles.lpointing_axes1,'Xlim',handles.axes1_xlim);
set(handles.lpointing_axes1,'Ylim',handles.axes1_ylim);

handles.axes2_xlim = [0 640];
handles.axes2_ylim = [0 480];
set(handles.lpointing_axes2,'Xlim',handles.axes2_xlim);
set(handles.lpointing_axes2,'Ylim',handles.axes2_ylim);


% centers and widths
handles.allcx = [];
handles.allcy = [];
handles.allwx = [];
handles.allwy = [];

handles.allenergy = [];
handles.energyref = [];
handles.allenergyjitter = [];


% install monitors
mcamon(handles.img,'lpointing_update_v1');

if ~mcamontimer
    mcamontimer('start')
end


% update handles structure
guidata(hObject, handles);

end




function varargout = lpointing_v1_OutputFcn(hObject, eventdata, handles) 

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




function energy_reset_Callback(hObject, eventdata, handles)



% update handles structure
guidata(hObject, handles);

end
