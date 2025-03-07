function varargout = frontmark_v1(varargin)
% version 14-05-2011

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frontmark_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @frontmark_v1_OutputFcn, ...
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




function frontmark_v1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


% set close function
set(handles.frontmark_main_fig,'CloseRequestFcn',@closeGUI);


% open PVs
handles.img1    = mcacheckopen('EDAQ:CAM:BEAST:FRONT:WVF1');
handles.img2    = mcacheckopen('EDAQ:CAM:BEAST:FRONT:WVF2');
handles.img3    = mcacheckopen('EDAQ:CAM:BEAST:FRONT:WVF3');
handles.img4    = mcacheckopen('EDAQ:CAM:BEAST:FRONT:WVF4');

handles.raw     = zeros(20,1280*960);
handles.howmany = 10;

handles.axes1_xlim = [0 1280];
handles.axes1_ylim = [0 960];
set(handles.frontmark_axes1,'Xlim',handles.axes1_xlim);
set(handles.frontmark_axes1,'Ylim',handles.axes1_ylim);

handles.axes2_xlim = [0 1280];
handles.axes2_ylim = [0 960];
set(handles.frontmark_axes2,'Xlim',handles.axes2_xlim);
set(handles.frontmark_axes2,'Ylim',handles.axes2_ylim);

% install monitors
mcamon(handles.img1,'frontmark_update_v1');
%mcamon(handles.img1);
mcamon(handles.img2);
mcamon(handles.img3);
mcamon(handles.img4);


if ~mcamontimer
    mcamontimer('start')
end


% update handles structure
guidata(hObject, handles);

end




function varargout = frontmark_v1_OutputFcn(hObject, eventdata, handles) 
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




function button_reset_Callback(hObject, eventdata, handles)

handles.raw = zeros(20,1280*960);

% update handles structure
guidata(hObject, handles);
end
