% analyze camera data
% version 13.03.2011
% 15.04.2011
% 10.05.2011


function varargout = camware_v1(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @camware_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @camware_v1_OutputFcn, ...
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




function camware_v1_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

set(handles.camware_main_fig,'CloseRequestFcn',@closeGUI);


handles.CAM_BEAST1_WVF1 = mcaopen('CAM:BEAST1:WVF1');
%handles.CAM_BEAST1_WVF2 = mcaopen('CAM:BEAST1:WVF2');
%handles.CAM_BEAST1_WVF3 = mcaopen('CAM:BEAST1:WVF3');
%handles.CAM_BEAST1_WVF4 = mcaopen('CAM:BEAST1:WVF4');
if mcamontimer() == 0
    mcamontimer('start');
end


% install handle on monitor
handles.mon = mcamon(handles.CAM_BEAST1_WVF1,'camware_v1(''doplot'')');


guidata(hObject, handles);
end




function varargout = camware_v1_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
end




function closeGUI(src,evnt)

handlesData = guidata(src);
mcaclearmon(handlesData.mon);
mcaclose(handles.CAM_BEAST1_WVF1);
%mcaclose(handles.CAM_BEAST1_WVF2);
%mcaclose(handles.CAM_BEAST1_WVF3);
%mcaclose(handles.CAM_BEAST1_WVF4);
delete(gcf);

end




function doplot

pause(0.1);
beep

h_main = findall(0,'Tag','camware__main_fig');
handles = guidata(h);

h_img = findall(0,'Tag','camware__main_img');
axes(h_img);

raw = reshape(mcacache(handles.CAM_BEAST1_WVF1),640,480);
imagesc(x,y,raw');


end
