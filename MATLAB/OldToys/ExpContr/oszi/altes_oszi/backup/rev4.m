function varargout = rev4(varargin)
% REV4 M-file for rev4.fig
%      REV4, by itself, creates a new REV4 or raises the existing
%      singleton*.
%
%      H = REV4 returns the handle to a new REV4 or the handle to
%      the existing singleton*.
%
%      REV4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REV4.M with the given input arguments.
%
%      REV4('Property','Value',...) creates a new REV4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rev4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rev4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rev4

% Last Modified by GUIDE v2.5 07-Dec-2010 15:51:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rev4_OpeningFcn, ...
                   'gui_OutputFcn',  @rev4_OutputFcn, ...
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


% --- Executes just before rev4 is made visible.
function rev4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rev4 (see VARARGIN)

% Choose default command line output for rev4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rev4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global mstop
global x;
global data1;
global data2;
global timebase;
x=0;
data1=0;
data2=0;
timebase=0;


function change_enable(handles, mstate)

    set(handles.pushbutton1,'Enable',mstate);
    
    set(handles.popupmenu1,'Enable',mstate);
    set(handles.edit1,'Enable',mstate);
    



function retrieve_trace(handles)
global rcl;
global x;
global data1;
global data2;
global timebase;   
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 4, 'Tag', '');
% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 4);
else
    fclose(obj1);
    delete(obj1);
    clear obj1;
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


scale= str2double(get(handles.edit4,'String'));

%hold on;
plot(handles.axes1,x,data1,x,data2*scale,'r');
xlim(handles.axes1,[0 x(end)]);
xlabel(handles.axes1,timebase);
ylabel(handles.axes1,'Voltage [V]');
%plot(handles.axes1,x,data2,'Color','red');
%hold off;
plot(handles.axes2,x,data2,'r');
xlim(handles.axes2,[0 x(end)]);
xlabel(handles.axes2,timebase);
ylabel(handles.axes2,'Voltage [V]');
% ymin=min(data2);
% ymax=max(data2);
% set(handles.axes2,'ylim',[ymin ymax]);
global data_w;
data_w=[x' data1 data2];

% Disconnect from instrument object, obj1.
flushinput(obj1);
flushoutput(obj1);
clrdevice(obj1);
%readasync(obj1);
fclose(obj1);
delete(obj1);
clear obj1;


% --- Outputs from this function are returned to the command line.
function varargout = rev4_OutputFcn(hObject, eventdata, handles) 
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
global mstop
global data_w
   tt=ftp(get(handles.edit1,'String'));
    if(strcmp(class(tt),'ftp')==0)
        msgbox('Could not establish connection to ftp server..');
        return;
    end
    
    mstop=0;
    change_enable(handles,'off');
    ascii(tt);

    while(mstop==0)
        dirlisting=dir(tt);
        for(i=1:size(dirlisting,1))
            if(strcmp(dirlisting(i).name,'oszi_prepare'))
                  
               pause(0.100);
               mget(tt,'oszi_prepare');
               aa=dlmread('oszi_prepare');                
               retrieve_trace(handles);
               savefolder='D:\DATA2\';
               oszi_file=sprintf('%06d\\%s%03d\\%s%04d%s',aa(1),'Run',aa(2),'Shot',aa(3),'_oszi');
               set(handles.shotinfo,'String',sprintf('%06d  %s %03d  %s% 04d',aa(1),'Run',aa(2),'Shot',aa(3)));
               mkdir([savefolder,sprintf('%06d\\%s%03d\\',aa(1),'Run',aa(2))]);
               dlmwrite([savefolder,oszi_file],data_w);
               %%%% %nshots=nshots+1;
               mkdir(tt,sprintf('%06d',aa(1)));
               mkdir(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
               cd(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
               mput(tt,[savefolder,oszi_file]);
               cd(tt,'/');

                %%%%%%set(handles.edit2,'String',num2str(nshots));
               delete(tt,dirlisting(i).name);
               break;
            end
        end
        drawnow;
    end
    
%    retrieve_trace(handles);
    
    change_enable(handles,'on');



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mstop
mstop=1;



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

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1



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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

scale= str2double(get(handles.edit4,'String'));
global x;
global data1;
global data2;
global timebase;

plot(handles.axes1,x,data1,x,data2*scale,'r');
xlim(handles.axes1,[0 x(end)]);
xlabel(handles.axes1,timebase);
ylabel(handles.axes1,'Voltage [V]');
drawnow;

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


