% analyze camera data
% version 13.03.2011
% 15.04.2011


function varargout = gui1(varargin)
% this is just for initializing the GUI
% no need for changes here

gui_Singleton   = 1;
gui_State       = struct('gui_Name', mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_OutputFcn, ...
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




function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% init function
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1 (see VARARGIN)

% set output to command line
handles.output = hObject;

set(handles.figure1,'CloseRequestFcn',@closeGUI);

% init global data
handles.raw         = zeros(640,480);       % raw image
handles.keeptrack   = zeros(10,640,480);    % save 10 consecutive images
handles.N           = 0;                    % index to save next img
handles.allcx       = [0];                  % centers in x
handles.allcy       = [0];                  % centers in y
handles.allwx       = [0];                  % widths in x
handles.allwy       = [0];                  % widths in y

handles.EDAQWVF1    = mcaopen('EDAQ:WVF1');


% update handles structure
guidata(hObject, handles);

end




function varargout = gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end




function tag_shoot_Callback(hObject, eventdata, handles)
% call back function for 'shoot' button
% hObject    handle to tag_shoot (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

N           = handles.N;
raw         = handles.raw;
keeptrack   = handles.keeptrack;


% simulate raw data input
% create new shot
% randomly distrubuted

% center of new shot
ccx = randn(1,1)*50;
ccy = randn(1,1)*50;
x  = -319:320;
y  = -239:240;

for ii=1:480
    raw(:,ii) = exp(-(x-ccx).^2/2/200) ...
        * exp(-(ii-240-ccy)^2/2/200);
end


% update index of averaged shots
N = mod(N+1,11);
if N == 0, N = 1; end


% store image
keeptrack(N,:,:) = raw;


statistics = squeeze(sum(keeptrack));
[XCenter XWidth] = get_peak(x,sum(statistics,2)');
[YCenter YWidth] = get_peak(y,sum(statistics,1));

handles.allcx(end+1) = XCenter;
handles.allcy(end+1) = YCenter;
handles.allwx(end+1) = XWidth;
handles.allwy(end+1) = YWidth;

% update statistics
set(handles.tag_XCenterOut,'String',num2str(XCenter));
set(handles.tag_YCenterOut,'String',num2str(YCenter));
set(handles.tag_XWidthOut,'String',num2str(XWidth));
set(handles.tag_YWidthOut,'String',num2str(YWidth));


% plot raw image
axes(handles.tag_axes1);
imagesc(x,y,raw');

% plot drift history
% averaged over 20 shots
ll = length(handles.allcx);
axes(handles.tag_axes2);
plot(1:ll,handles.allcx,'b',1:ll,handles.allcy,'r');
grid;

% plot pointing history
% averaged over 20 shots
axes(handles.tag_axes4);
plot(1:ll,handles.allwx,'b',1:ll,handles.allwy,'r');
grid;


% save data
handles.N           = N;
handles.raw         = raw;
handles.keeptrack   = keeptrack;

guidata(hObject, handles);

end




function [peak width] = get_peak(x,y)
% [peak width] = get_peak(x,y)
% width is rms

    peak    = sum(x.*y) / sum(y);
    width   = sqrt(var(x,y));           % rms width

end



function closeGUI(src,evnt)

handlesData = guidata(src);
mcaclose(handlesData.EDAQWVF1);
delete(gcf);

end
