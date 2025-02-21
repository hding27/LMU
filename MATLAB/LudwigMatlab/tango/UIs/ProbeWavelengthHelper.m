function varargout = ProbeWavelengthHelper(varargin)
% PROBEWAVELENGTHHELPER MATLAB code for ProbeWavelengthHelper.fig
%      PROBEWAVELENGTHHELPER, by itself, creates a new PROBEWAVELENGTHHELPER or raises the existing
%      singleton*.
%
%      H = PROBEWAVELENGTHHELPER returns the handle to a new PROBEWAVELENGTHHELPER or the handle to
%      the existing singleton*.
%
%      PROBEWAVELENGTHHELPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROBEWAVELENGTHHELPER.M with the given input arguments.
%
%      PROBEWAVELENGTHHELPER('Property','Value',...) creates a new PROBEWAVELENGTHHELPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ProbeWavelengthHelper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ProbeWavelengthHelper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ProbeWavelengthHelper

% Last Modified by GUIDE v2.5 16-Mar-2017 13:11:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @ProbeWavelengthHelper_OpeningFcn, ...
  'gui_OutputFcn',  @ProbeWavelengthHelper_OutputFcn, ...
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
% End initialization code - DO NOT EDIT
end

% --- Executes just before ProbeWavelengthHelper is made visible.
function ProbeWavelengthHelper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ProbeWavelengthHelper (see VARARGIN)

% Choose default command line output for ProbeWavelengthHelper
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


set(hObject,'Toolbar','figure');
set(gcf,'Units','normalized')

% UIWAIT makes ProbeWavelengthHelper wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = ProbeWavelengthHelper_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pOpen.
function pOpen_Callback(hObject, eventdata, handles)
% hObject    handle to pOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.probe = Probe(get(handles.eExperimentPath,'String'));
handles.currentShotIdx = handles.probe.No(1);
if length(handles.probe.PixelSize) > 0
  set(handles.ePixelSize,'String',num2str(handles.probe.PixelSize(1)));
end
guidata(hObject, handles);
updateShot(hObject);
end


function eExperimentPath_Callback(hObject, eventdata, handles)
% hObject    handle to eExperimentPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eExperimentPath as text
%        str2double(get(hObject,'String')) returns contents of eExperimentPath as a double
end

% --- Executes during object creation, after setting all properties.
function eExperimentPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eExperimentPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end
end


function eCurrent_Callback(hObject, eventdata, handles)
% hObject    handle to eCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eCurrent as text
%        str2double(get(hObject,'String')) returns contents of eCurrent as a double
handles = guidata(hObject);
handles.currentShotIdx = find(handles.probe.No == str2num(get(handles.eCurrent, 'String')));
guidata(hObject, handles);
updateShot(hObject);
end

% --- Executes during object creation, after setting all properties.
function eCurrent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eCurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pNext.
function pNext_Callback(hObject, eventdata, handles)
% hObject    handle to pNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
found = false;
handles.currentShotIdx = handles.currentShotIdx + 1;
guidata(hObject, handles);
updateShot(hObject);
end

% --- Executes on button press in pPrev.
function pPrev_Callback(hObject, eventdata, handles)
% hObject    handle to pPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.currentShotIdx = handles.currentShotIdx - 1;
guidata(hObject, handles);
updateShot(hObject);
end


function updateShot(hObject)
handles = guidata(hObject);
if (handles.currentShotIdx < 1)
  handles.currentShotIdx = 1;
end
p = handles.probe.getRecord(handles.probe.No(handles.currentShotIdx));

set(handles.eCurrent, 'String', num2str(p.No(1)));
set(handles.eRun, 'String', num2str(p.Run(1)));


axes(handles.Image);
im = p.Image{1};
if isfield(handles, 'BackgroundImage') && get(handles.cBackground,'Value')
  im = double(im)./handles.BackgroundImage;
  im(isinf(im) | isnan(im)) = 0;
  im = uint16(im/mean(mean(im))*65535/2);
end
imagesc(im);

handles.currentImage = im;
colormap('gray');
guidata(hObject, handles);
updateRects(hObject);
end


% --- Executes on button press in pNewRect.
function pNewRect_Callback(hObject, eventdata, handles)
% hObject    handle to pNewRect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Image);

k = waitforbuttonpress;
set(gca, 'Units', 'pixels');
point1 = get(gca, 'CurrentPoint');
rbbox;
point2 = get(gca, 'CurrentPoint');
point1 = point1(1,1:2);
point2 = point2(1,1:2);

pos = round(min(point1, point2));
size = round(abs(point1 - point2));

pos(pos<1) = 1;
size(size<1) = 1;


rect_pos = [pos(1), pos(2),  size(1), size(2)];

handles.probe.PlasmawaveRects{handles.currentShotIdx}{end+1} = rect_pos;
handles.probe.saveChanges();
updateRects(hObject);
end



function updateRects(hObject)
handles = guidata(hObject);

corrCol = hsv(10);

rects = handles.probe.PlasmawaveRects{handles.currentShotIdx};
axes(handles.Image);

if isfield(handles, 'rectangles')
  % clear annotations
  for i = length(handles.rectangles):-1:1
    if ishandle(handles.rectangles{i})
      delete(handles.rectangles{i});
    end
  end
end
handles.rectangles = [];

% get selection of lRects to plot that rect blue
selection = get(handles.lRects, 'Value');
if selection > length(rects)
  set(handles.lRects, 'Value', length(rects));
end
rectStrings = {};

% plot new rects
if ~get(handles.cRects,'Value')
  for i = 1:length(rects)
    if i == selection
      color = [0 0 1];
    else
      color = corrCol(i,:);
    end
    handles.rectangles{i} = rectangle('Position', rects{i}, 'EdgeColor', color);
  end
end




% plot correlations
cla(handles.XCorr);
cla(handles.Filtered);

if get(handles.cAnalyze, 'Value')
  
  handles.probe.Wavelength{handles.currentShotIdx} = [];
  
  for i = 1:length(rects)
    
    if i == selection
      color = 'blue';
    else
      color = corrCol(i,:);
    end
    
    rect = round(rects{i});
    imagesum = sum(handles.currentImage(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3)),1);
    
    try
      
      [lambda, n0, filtered, xcorrelation, peaks] = CalculateWavelengthFromProbe(imagesum, handles.probe.PixelSize(2));
      
      
      handles.probe.Wavelength{handles.currentShotIdx}(i) = lambda;
      
      
      axes(handles.Filtered);
      plot(filtered/max(filtered), 'Color', color);
      axes(handles.XCorr);
      plot(xcorrelation.lags, xcorrelation.c, 'Color', color, 'DisplayName', [num2str(i) ': ' num2str(lambda,3) ' / ' num2str(n0,3)]);
      hold on
      legend('-DynamicLegend');
      plot(peaks.pos, peaks.val, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', color, 'Markersize', 6);
      xlim([-60 60]);
      
    end
  end
  
  
  
  handles.probe.saveChanges();
end



% update listbox

pre = '<HTML><FONT color="';
mid = '</FONT><FONT>';
post = '</FONT></HTML>';
listboxStr = cell(length(rects),1);
for i = 1:length(rects)
  
  %if i == selection
  %  color = [0 0 1];
  %else
  color = corrCol(i,:);
  %end
  
  rawstr = [num2str(rects{i}(1)) ' ' num2str(rects{i}(2)) ' ' num2str(rects{i}(3)) ' ' num2str(rects{i}(4))];
  listboxStr{i} = [pre reshape( dec2hex( round(color*255), 2 )',1, 6) '">' num2str(i) ': ' mid rawstr post];
end
set(handles.lRects,'String',listboxStr);
if selection == 0
  set(handles.lRects, 'Value', 1);
end

guidata(hObject, handles);

end


% --- Executes on selection change in lRects.
function lRects_Callback(hObject, eventdata, handles)
% hObject    handle to lRects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lRects contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lRects
updateRects(hObject);



end

% --- Executes during object creation, after setting all properties.
function lRects_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lRects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pEditRect.
function pEditRect_Callback(hObject, eventdata, handles)
% hObject    handle to pEditRect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pDeleteRect.
function pDeleteRect_Callback(hObject, eventdata, handles)
% hObject    handle to pDeleteRect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
selection = get(handles.lRects, 'Value');
handles.probe.PlasmawaveRects{handles.currentShotIdx}(selection) = [];
handles.probe.saveChanges();
updateRects(hObject);
end


% --- Executes on button press in cAnalyze.
function cAnalyze_Callback(hObject, eventdata, handles)
% hObject    handle to cAnalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cAnalyze
updateRects(hObject)
end



function eBackground_Callback(hObject, eventdata, handles)
% hObject    handle to eBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eBackground as text
%        str2double(get(hObject,'String')) returns contents of eBackground as a double
backgroundShot = str2num(get(hObject, 'String'));
[p, ava] = handles.probe.getRecord(backgroundShot);
if ava
  handles.BackgroundImage = double(p.Image{1});
end
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function eBackground_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in cBackground.
function cBackground_Callback(hObject, eventdata, handles)
% hObject    handle to cBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cBackground
updateShot(hObject);
end



function eRun_Callback(hObject, eventdata, handles)
% hObject    handle to eRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eRun as text
%        str2double(get(hObject,'String')) returns contents of eRun as a double
handles = guidata(hObject);
shotsByRun = handles.probe.shotsByRun(str2num(get(handles.eRun, 'String')));
if ~isempty(shotsByRun)
  handles.currentShotIdx = find(handles.probe.No == shotsByRun(1));
  guidata(hObject, handles);
  updateShot(hObject);
end
end


% --- Executes during object creation, after setting all properties.
function eRun_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in cRects.
function cRects_Callback(hObject, eventdata, handles)
% hObject    handle to cRects (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cRects
updateRects(hObject);
end



function ePixelSize_Callback(hObject, eventdata, handles)
% hObject    handle to ePixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ePixelSize as text
%        str2double(get(hObject,'String')) returns contents of ePixelSize as a double
handles = guidata(hObject);

handles.probe.PixelSize = [1 1] .* str2double(get(handles.ePixelSize,'String'));
handles.probe.saveChanges();
updateRects(hObject);
end


% --- Executes during object creation, after setting all properties.
function ePixelSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ePixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

end
