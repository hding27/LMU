function varargout = eSpectrum(varargin)
% ESPECTRUM MATLAB code for eSpectrum.fig
%      ESPECTRUM, by itself, creates a new ESPECTRUM or raises the existing
%      singleton*.
%
%      H = ESPECTRUM returns the handle to a new ESPECTRUM or the handle to
%      the existing singleton*.
%
%      ESPECTRUM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESPECTRUM.M with the given input arguments.
%
%      ESPECTRUM('Property','Value',...) creates a new ESPECTRUM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eSpectrum_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eSpectrum_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eSpectrum

% Last Modified by GUIDE v2.5 21-Jan-2016 10:22:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eSpectrum_OpeningFcn, ...
                   'gui_OutputFcn',  @eSpectrum_OutputFcn, ...
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



% --- Executes just before eSpectrum is made visible.
function eSpectrum_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eSpectrum (see VARARGIN)

% Choose default command line output for eSpectrum
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes eSpectrum wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eSpectrum_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
tgroup = uitabgroup('Parent', hObject);
tab1 = uitab('Parent', tgroup, 'Title', 'Pointing Calibration');
tab2 = uitab('Parent', tgroup, 'Title', 'Spectrum Calibration');
tab3 = uitab('Parent', tgroup, 'Title', 'Spectrum Analyses');