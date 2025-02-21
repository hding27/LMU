function varargout = mster_v1(varargin)
% MSTER_V1 M-file for mster_v1.fig
%      MSTER_V1, by itself, creates a new MSTER_V1 or raises the existing
%      singleton*.
%
%      H = MSTER_V1 returns the handle to a new MSTER_V1 or the handle to
%      the existing singleton*.
%
%      MSTER_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSTER_V1.M with the given input arguments.
%
%      MSTER_V1('Property','Value',...) creates a new MSTER_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mster_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mster_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mster_v1

% Last Modified by GUIDE v2.5 05-May-2011 18:15:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mster_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @mster_v1_OutputFcn, ...
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


% --- Executes just before mster_v1 is made visible.
function mster_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mster_v1 (see VARARGIN)

% Choose default command line output for mster_v1
handles.output = hObject;

% check if open
handle_nrun = mcaisopen('EDAQ:NRUN');

% if not open, open it
if handle_nrun == 0
    handle_nrun = mcaopen('EDAQ:NRUN');
    
    % check for connection error
    if handle_nrun == 0
        msgbox('cannot open EDAQ:NRUN. abort.')
    end
end

handle_nshot = mcaisopen('EDAQ:NSHOT');
if handle_nshot == 0
    handle_nshot = mcaopen('EDAQ:NSHOT');
    if handle_nshot == 0
        msgbox('cannot open EDAQ:NSHOT. abort.')
    end
end


nrun = mcaget(handle_nrun);
nshot = mcaget(handle_nshot);

set(handles.edit_nrun,'String',num2str(mcaget(handle_nrun)));
set(handles.edit_nshot,'String',num2str(mcaget(handle_nshot)));

%handles.handle_nrun = handle_nrun;
%handles.handle_nshot = handle_nshot;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mster_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mster_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_nrun_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nrun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nrun as text
%        str2double(get(hObject,'String')) returns contents of edit_nrun as a double


% --- Executes during object creation, after setting all properties.
function edit_nrun_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nrun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nshot_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nshot as text
%        str2double(get(hObject,'String')) returns contents of edit_nshot as a double


% --- Executes during object creation, after setting all properties.
function edit_nshot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


