function varargout = camware_v2(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camware_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @camware_v2_OutputFcn, ...
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




function camware_v2_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for camware_v2
handles.output = hObject;

% set close function
set(handles.camware_v2_main_fig,'CloseRequestFcn',@closeGUI);

if mcamontimer == 0
    mcamontimer('start');
end

% install handle on monitor
handles.CAM_BEAST1_WVF1 = mcaopen('CAM:BEAST1:WVF1');
handles.mon = mcamon(handles.CAM_BEAST1_WVF1,'camware_v2(''doplot'')');

% Update handles structure
guidata(hObject, handles);

end




% --- Outputs from this function are returned to the command line.
function varargout = camware_v2_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

end




function closeGUI(src,evnt)

handles = guidata(src);

mcaclose(mcacheckopen('CAM:BEAST1:WVF1'));
mcaclearmon(handles.mon);

%[monhandles moncallbacks] = mcamon;

%if ~isempty(monhandles)
%    mcaclearmon(monhandles);
%end

delete(gcf);
end




function doplot

beep

% get handles
%handles = guidata(camware_v2);
%handles2 = guidata(gcbo);

h_main = findall(0,'Tag','camware_v2_main_fig');
handles = guidata(h_main);

    
events = mcamonevents(handles.mon);
%img = mcacache(mcaisopen('CAM:BEAST1:WVF1'));
for ii=1:mcamonevents(handles.mon);
    img = mcacache(handles.mon);
end

%try
%events = mcamonevents(handles.mon);
set(handles.text1,'String',num2str(mcamonevents(handles.mon)));
%catch err
%end
img = reshape(img,640,480);

%h_img = findall(0,'Tag','camware_v2_axes1');
%axes(h_img);
axes(handles.camware_v2_axes1);
%axes(handles.camware_v2_axes1);
%colormap lines;
imagesc(img);
colormap jet;
drawnow;
end
