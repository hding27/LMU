function varargout = cdypress_v1(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cdypress_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @cdypress_v1_OutputFcn, ...
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




function cdypress_v1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% set close function
set(handles.cdypress_main_fig,'CloseRequestFcn',@closeGUI);

% install PV handles
handles.cdy_press   = mcacheckopen('EDAQ:CDY:PRESS');
handles.xspec_press = mcacheckopen('EDAQ:XSPEC:PRESS');

% install monitors
mcamon(handles.cdy_press,'cdypress_update_v1');
mcamon(handles.xspec_press);

if ~mcamontimer
    mcamontimer('start')
end

guidata(hObject, handles);

end





function varargout = cdypress_v1_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
end




function closeGUI(src,evnt)
try
handles = guidata(src);

mcaclearmon(handles.cdy_press);
mcaclearmon(handles.xspec_press);
  
mcaclose(handles.cdy_press);
mcaclose(handles.xspec_press);
catch err
end
delete(gcf);

end
