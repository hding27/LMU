function varargout = ePointing(varargin)
% EPOINTING MATLAB code for ePointing.fig
%      EPOINTING, by itself, creates a new EPOINTING or raises the existing
%      singleton*.
%
%      H = EPOINTING returns the handle to a new EPOINTING or the handle to
%      the existing singleton*.
%
%      EPOINTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EPOINTING.M with the given input arguments.
%
%      EPOINTING('Property','Value',...) creates a new EPOINTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ePointing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ePointing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ePointing

% Last Modified by GUIDE v2.5 31-Jul-2015 10:38:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ePointing_OpeningFcn, ...
                   'gui_OutputFcn',  @ePointing_OutputFcn, ...
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


% --- Executes just before ePointing is made visible.
function ePointing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ePointing (see VARARGIN)

% Choose default command line output for ePointing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global udps
udps.eMaster=udp('10.153.232.74',9091,'LocalPort',12345);
set(udps.eMaster,'InputBufferSize',24);
set(udps.eMaster,'Timeout',1)
fopen(udps.eMaster);

% UIWAIT makes ePointing wait for user response (see UIRESUME)
% uiwait(handles.fig_ePointing);


% --- Outputs from this function are returned to the command line.
function varargout = ePointing_OutputFcn(hObject, eventdata, handles) 
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
global udps
global mstop
flushinput(udps.eMaster);
mstop=0;
while(mstop==0)
    [shotNo,~,msg]=fread(udps.eMaster,3,'double');
    drawnow;
    disp(shotNo);    
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mstop
mstop=1;

% --- Executes when user attempts to close fig_ePointing.
function fig_ePointing_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fig_ePointing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global udps
fclose(udps.eMaster);
delete(udps.eMaster);
delete(hObject);


% --- Executes during object creation, after setting all properties.
function fig_ePointing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fig_ePointing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
