function varargout = frontmark_v2(varargin)
% version 02-06-2011

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frontmark_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @frontmark_v2_OutputFcn, ...
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




function frontmark_v2_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


% set close function
set(handles.frontmark_main_fig,'CloseRequestFcn',@closeGUI);


% open PVs
handles.img     = mcacheckopen('EDAQ:CAM:BEAST:FRONT:WVF');
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
mcamon(handles.img,'frontmark_update_v2');


if ~mcamontimer
    mcamontimer('start')
end


% update handles structure
guidata(hObject, handles);

end




function varargout = frontmark_v2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end




function closeGUI(src,evnt)

% get gui handles
handles = guidata(findall(0,'Tag','frontmark_main_fig'));

% clear monitor handles
mcaclearmon(handles.img);

% clear PV handles
mcaclose(handles.img);

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
