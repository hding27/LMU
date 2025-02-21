function varargout = tapedrive(varargin)
% TAPEDRIVE M-file for tapedrive.fig
%      TAPEDRIVE, by itself, creates a new TAPEDRIVE or raises the existing
%      singleton*.
%
%      H = TAPEDRIVE returns the handle to a new TAPEDRIVE or the handle to
%      the existing singleton*.
%
%      TAPEDRIVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAPEDRIVE.M with the given input arguments.
%
%      TAPEDRIVE('Property','Value',...) creates a new TAPEDRIVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tapedrive_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tapedrive_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tapedrive

% Last Modified by GUIDE v2.5 15-Mar-2011 12:40:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tapedrive_OpeningFcn, ...
                   'gui_OutputFcn',  @tapedrive_OutputFcn, ...
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


% --- Executes just before tapedrive is made visible.
function tapedrive_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tapedrive (see VARARGIN)

% Choose default command line output for tapedrive
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tapedrive wait for user response (see UIRESUME)
% uiwait(handles.figure1);
loadlibrary ('inpout32',@mx_inpout32);
if(libisloaded('inpout32')==false)
    msgbox('could not load lpt library.. will not shoot;(');
    return
end
calllib('inpout32','Out32',hex2dec('378'),bin2dec('00000000'));
global nshots;
global mstop;
nshots=0;
global counter
counter=0;

function change_enable(handles, mstate)

    set(handles.edit1,'Enable',mstate);
    set(handles.edit2,'Enable',mstate);
    set(handles.pushbutton2,'Enable',mstate);
    set(handles.edit3,'Enable',mstate);
    set(handles.checkbox1,'Enable',mstate);
    set(handles.pushbutton3,'Enable',mstate);
    
% --- Outputs from this function are returned to the command line.
function varargout = tapedrive_OutputFcn(hObject, eventdata, handles) 
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





% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
state=get(handles.togglebutton1,'Value');
global counter
global mstop
if (state == 1)
    
    if(libisloaded('inpout32')==false)
        msgbox('Could not load lpt library..');
        return;
    end
    tt=ftp(get(handles.edit1,'String'));
    if(strcmp(class(tt),'ftp')==0)
        msgbox('Could not establish connection to ftp server..');
        return;
    end
    
    mstop=0;
    change_enable(handles,'off');
    set(handles.togglebutton1,'String','RUNNING... Click to stop');
    set(handles.togglebutton1,'BackgroundColor','green');
    
    ascii(tt);

    while(mstop==0)
        dirlisting=dir(tt);
        for(i=1:size(dirlisting,1))
            if(strcmp(dirlisting(i).name,'tapedrive_prepare'))
                pause(0.100);
                calllib('inpout32','Out32',hex2dec('378'),bin2dec('00000001'));
                pause(str2num(get(handles.edit2,'String')));
                calllib('inpout32','Out32',hex2dec('378'),bin2dec('00000000'));
                if get(handles.checkbox1,'Value')
                    counter=counter-1;
                else
                    counter=counter+1;
                end
                set(handles.text2,'String',num2str(counter));
                delete(tt,dirlisting(i).name);
                break;
            end
        end
        drawnow;
        pause(1);
        
    end
end
    if (state == 0)
        
        mstop=1;
    change_enable(handles,'on');
    set(handles.togglebutton1,'String','STOPPED...click to start');
    set(handles.togglebutton1,'BackgroundColor','red');
    end
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1




% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



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




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global counter;
counter=0;
set(handles.text2,'String',num2str(counter));




% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
calllib('inpout32','Out32',hex2dec('378'),bin2dec('00000001'));
pause(str2num(get(handles.edit3,'String')));
calllib('inpout32','Out32',hex2dec('378'),bin2dec('00000000'));
                
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


