function varargout = geht_njiet(varargin)
% GEHT_NJIET M-file for geht_njiet.fig
%      GEHT_NJIET, by itself, creates a new GEHT_NJIET or raises the existing
%      singleton*.
%
%      H = GEHT_NJIET returns the handle to a new GEHT_NJIET or the handle to
%      the existing singleton*.
%
%      GEHT_NJIET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEHT_NJIET.M with the given input arguments.
%
%      GEHT_NJIET('Property','Value',...) creates a new GEHT_NJIET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before geht_njiet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to geht_njiet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help geht_njiet

% Last Modified by GUIDE v2.5 23-Nov-2010 12:13:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @geht_njiet_OpeningFcn, ...
                   'gui_OutputFcn',  @geht_njiet_OutputFcn, ...
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


% --- Executes just before geht_njiet is made visible.
function geht_njiet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to geht_njiet (see VARARGIN)

% Choose default command line output for geht_njiet
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


function state_change(handles, mstate)

function retrieve_trace(handles)
global rcl

   
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 4, 'Tag', '');
% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 4);
else
    fclose(obj1);
    obj1 = obj1(1)
end

obj1.InputBufferSize = 50000;
obj1.OutputBufferSize= 50000;



fopen(obj1);
obj1.Timeout=5;

% to recall settings
if (rcl ~= 0)
fprintf(obj1,['*RCL ',num2str(rcl)]);
end


flushinput(obj1);
flushoutput(obj1);
clrdevice(obj1);
fprintf(obj1,'*CLS')
fprintf(obj1,'*idn?');
fscanf(obj1)


fprintf(obj1,'trmd SINGLE');
fprintf(obj1,'*trg ARM_ACQUISITION');
pause(3);

fprintf(obj1,'C1:inspect? "wavedesc"');
s1=fscanf(obj1);

fprintf(obj1, 'INSPECT? "DATA_ARRAY_1"')
data_raw1 = fscanf(obj1);
data1=cell2mat(textscan(data_raw1(13:end),'%f'));

fprintf(obj1, 'C2:INSPECT? "DATA_ARRAY_2"')
data_raw2 = fscanf(obj1);
data2=cell2mat(textscan(data_raw2(13:end),'%f'));


p_time=findstr('TIMEBASE',s1)+21;
p_time2=strfind(s1(p_time:end),'_');
timediv=str2num(s1(p_time:p_time2(1)+p_time-2));
timebase=s1(p_time+p_time2(1):p_time+p_time2(1)+findstr(s1(p_time+p_time2(1):end),'/')-2);
p_points=findstr('PNTS_PER_SCREEN',s1)+21;
points=str2num(s1(p_points:p_points+19));
x=zeros(1,points);
for i=1:points+2
x(i)= timediv*10/points*i;
end


plot(handles.axes1,x,data1);
% xlabel(timebase);
% ylabel('Voltage [V]');
% 
% plot(handles.axes2,x,data2);

% Disconnect from instrument object, obj1.
flushinput(obj1);
flushoutput(obj1);
clrdevice(obj1);
%readasync(obj1);
fclose(obj1);
delete(obj1);
clear obj1;



% UIWAIT makes geht_njiet wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = geht_njiet_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
retrieve_trace(handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global rcl
rcl=get(hObject,'Value')-1;
set(handles.pushbutton1,'String',num2str(rcl));

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global rcl
rcl=0;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


