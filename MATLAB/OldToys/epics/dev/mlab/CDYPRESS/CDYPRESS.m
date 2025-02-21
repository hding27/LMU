function varargout = CDYPRESS(varargin)
% CDYPRESS M-file for CDYPRESS.fig
%      CDYPRESS, by itself, creates a new CDYPRESS or raises the existing
%      singleton*.
%
%      H = CDYPRESS returns the handle to a new CDYPRESS or the handle to
%      the existing singleton*.
%
%      CDYPRESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CDYPRESS.M with the given input arguments.
%
%      CDYPRESS('Property','Value',...) creates a new CDYPRESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CDYPRESS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CDYPRESS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CDYPRESS

% Last Modified by GUIDE v2.5 05-May-2011 20:42:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CDYPRESS_OpeningFcn, ...
                   'gui_OutputFcn',  @CDYPRESS_OutputFcn, ...
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


% --- Executes just before CDYPRESS is made visible.
function CDYPRESS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CDYPRESS (see VARARGIN)

% Choose default command line output for CDYPRESS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CDYPRESS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CDYPRESS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
