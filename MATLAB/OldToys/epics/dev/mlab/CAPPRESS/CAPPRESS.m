function varargout = CAPPRESS(varargin)
% CAPPRESS M-file for CAPPRESS.fig
%      CAPPRESS, by itself, creates a new CAPPRESS or raises the existing
%      singleton*.
%
%      H = CAPPRESS returns the handle to a new CAPPRESS or the handle to
%      the existing singleton*.
%
%      CAPPRESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAPPRESS.M with the given input arguments.
%
%      CAPPRESS('Property','Value',...) creates a new CAPPRESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CAPPRESS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CAPPRESS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CAPPRESS

% Last Modified by GUIDE v2.5 05-May-2011 21:04:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CAPPRESS_OpeningFcn, ...
                   'gui_OutputFcn',  @CAPPRESS_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before CAPPRESS is made visible.
function CAPPRESS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CAPPRESS (see VARARGIN)

% Choose default command line output for CAPPRESS
handles.output = hObject;

set(handles.CAPPRESS_figure1,'CloseRequestFcn',@closeGUI);

% check if open
handle_CAPPRESS = mcaisopen('EDAQ:CAPPRESS:P');

% if not open, open it
if handle_CAPPRESS == 0
    handle_CAPPRESS = mcaopen('EDAQ:CAPPRESS:P');
    
    % check for connection error
    if handle_CAPPRESS == 0
        msgbox('cannot open EDAQ:CAPPRESS. abort.');
    end
end

handles.CAPPRESS = handle_CAPPRESS;

if mcamontimer() == 0
    mcamontimer('start');
end

mcamon(handle_CAPPRESS,'CAPPRESS(''doupdate'')');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CAPPRESS wait for user response (see UIRESUME)
% uiwait(handles.CAPPRESS_figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = CAPPRESS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

function doupdate
    
    h = findall(0,'Tag','CAPPRESS_figure1');
    figure(h);
    handles = guidata(h);
    figure(axes1);
    plot(mca)
end

function closeGUI(src,evnt)

handlesData = guidata(src);
mcaclearmon(handlesData.CAPPRESS);
mcaclose(handlesData.CAPPRESS);
delete(gcf);

end
