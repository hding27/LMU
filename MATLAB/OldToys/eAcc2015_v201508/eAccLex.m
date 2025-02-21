function varargout = eAccLex(varargin)
% EACCLEX MATLAB code for eAccLex.fig
%      EACCLEX, by itself, creates a new EACCLEX or raises the existing
%      singleton*.
%
%      H = EACCLEX returns the handle to a new EACCLEX or the handle to
%      the existing singleton*.
%
%      EACCLEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EACCLEX.M with the given input arguments.
%
%      EACCLEX('Property','Value',...) creates a new EACCLEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eAccLex_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eAccLex_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eAccLex

% Last Modified by GUIDE v2.5 30-Jul-2015 17:52:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eAccLex_OpeningFcn, ...
                   'gui_OutputFcn',  @eAccLex_OutputFcn, ...
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


% --- Executes just before eAccLex is made visible.
function eAccLex_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eAccLex (see VARARGIN)

% Choose default command line output for eAccLex
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global mdate;
global mrun;
global mshot;
global serialp;
global udps;

mdate = get(handles.edit1,'string');
mrun  =str2double(get(handles.edit2,'string'));
mshot =str2double(get(handles.edit3,'string'));

serialp=serial('COM1','DataTerminalReady','off');
fopen(serialp);
udps.ePointing=udp('10.153.68.17',12345,'LocalPort',9091);
fopen(udps.ePointing);

% UIWAIT makes eAccLex wait for user response (see UIRESUME)
% uiwait(handles.fig_eAccLex);


% --- Outputs from this function are returned to the command line.
function varargout = eAccLex_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close fig_eAccLex.
function fig_eAccLex_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fig_eAccLex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PrepareNextShot(handles);
ShootNow(handles);

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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global mstop;

    mstop=0;
    drawnow;
    mdelay=str2double(get(handles.edit4,'String'));
        
    while(mstop==0)
        PrepareNextShot(handles);
        ShootNow(handles);
        drawnow;
        pause(mdelay);
    end

    
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global mstop;
    mstop=1;
    
   
function PrepareNextShot(handles)

    global mdate
    global mrun
    global mshot
    
    drawnow
    mdate  =  get(handles.edit1,'string');
    mrun   = str2double(get(handles.edit2,'string'));
    mshot  = str2double(get(handles.edit3,'string'));
    mshot  = mshot+1;
    shotNo=[mdate '_' num2str(mrun,'%03i') '_' num2str(mshot,'%04i')];
    fID=fopen('O:\Electrons\AppJunk\ShotCounter.txt','w');
    fprintf(fID,'%s',shotNo);
    fclose(fID);
    
    %PrepareDevice('ePointing');
    pause(0.5);

function PrepareDevice(name)    
    
    global flags
    global udps
    global mdate
    global mrun
    global mshot
    
    if(flags.(name))
        fwrite(udps.(name),[mshot],'double');
    else disp([name ' saving was disabled']);
    end

function ShootNow(handles)
    
    global serialp;    
    global mshot;
    
    serialp.DataTerminalReady='on';
    pause(0.1);
    serialp.DataTerminalReady='off';
    
    set(handles.edit3,'String',num2str(mshot));
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function cb_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cb_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global flags
flags.ePointing=get(hObject,'Value');

% --- Executes on button press in cb_1.
function cb_1_Callback(hObject, eventdata, handles)
% hObject    handle to cb_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_1
global flags
flags.ePointing=get(hObject,'Value');


% --- Executes during object creation, after setting all properties.
function fig_eAccLex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_eAccLex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function fig_eAccLex_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to fig_eAccLex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
instrreset
