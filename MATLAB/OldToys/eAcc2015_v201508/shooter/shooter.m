function varargout = shooter(varargin)
% SHOOTER M-file for shooter.fig
%      SHOOTER, by itself, creates a new SHOOTER or raises the existing
%      singleton*.
%
%      H = SHOOTER returns the handle to a new SHOOTER or the handle to
%      the existing singleton*.
%
%      SHOOTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOOTER.M with the given input arguments.
%
%      SHOOTER('Property','Value',...) creates a new SHOOTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shooter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shooter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shooter

% Last Modified by GUIDE v2.5 28-Jul-2015 16:08:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shooter_OpeningFcn, ...
                   'gui_OutputFcn',  @shooter_OutputFcn, ...
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


% --- Executes just before shooter is made visible.
function shooter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shooter (see VARARGIN)

% Choose default command line output for shooter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global serialp;
serialp=serial('COM1','DataTerminalReady','off');
fopen(serialp);
global nshots;
global mstop;
nshots=0;
% UIWAIT makes shooter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = shooter_OutputFcn(hObject, eventdata, handles) 
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
function change_enable(handles, mstate)

    set(handles.pushbutton1,'Enable',mstate);
    set(handles.pushbutton2,'Enable',mstate);
    set(handles.pushbutton3,'Enable',mstate);
    set(handles.pushbutton4,'Enable',mstate);
    set(handles.pushbutton5,'Enable',mstate);
    set(handles.edit1,'Enable',mstate);
    set(handles.edit3,'Enable',mstate);

% --- ARM ftp daemon
function pushbutton1_Callback(hObject, eventdata, handles)

    global mstop;
    global nshots;
    global serialp;
  
%     tt=ftp(get(handles.edit1,'String'));
%     if(strcmp(class(tt),'ftp')==0)
%         msgbox('Could not establish connection to ftp server..');
%         return;
%     end
    
    mstop=0;
    change_enable(handles,'off');
    set(handles.pushbutton2,'Enable','on');

    ascii(tt);

    while(mstop==0)
        aa=fread(Master_udp,3);

            if(aa(3))
                pause(0.100);
                serialp.DataTerminalReady='on';
                pause(0.1);
                serialp.DataTerminalReady='off';
                
                nshots=nshots+1;
                set(handles.edit2,'String',num2str(nshots));
                delete(tt,dirlisting(i).name);
                break;
            end

        drawnow;
        pause(1);
        
    end
    
    change_enable(handles,'on');






% --- Disarm daemon
function pushbutton2_Callback(hObject, eventdata, handles)

    global mstop;
    mstop=1;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global serialp;
fclose(serialp);
delete(hObject);



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


% --- SHOOT NOW
function pushbutton3_Callback(hObject, eventdata, handles)

    global nshots;
    global serialp;
        
    serialp.DataTerminalReady='on';
    pause(0.1);
    serialp.DataTerminalReady='off';
    
    nshots=nshots+1;
    set(handles.edit2,'String',num2str(nshots));
        
    



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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global serialp;
    global mstop;
    global nshots;
    mstop=0;

    mdelay=str2double(get(handles.edit3,'String'));
    
    change_enable(handles,'off');
    set(handles.pushbutton5,'Enable','on');
    
    while(mstop==0)
        serialp.DataTerminalReady='on';
        pause(0.1);
        serialp.DataTerminalReady='off';
        nshots=nshots+1;
        set(handles.edit2,'String',num2str(nshots));
        drawnow;
        pause(mdelay);
    end
    
    change_enable(handles,'on');
    

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global mstop;
    mstop=1;


% --- Executes during object creation, after setting all properties.
function pushbutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
