function varargout = rev0(varargin)
% REV0 MATLAB code for rev0.fig
%      REV0, by itself, creates a new REV0 or raises the existing
%      singleton*.
%
%      H = REV0 returns the handle to a new REV0 or the handle to
%      the existing singleton*.
%
%      REV0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REV0.M with the given input arguments.
%
%      REV0('Property','Value',...) creates a new REV0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rev0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rev0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rev0

% Last Modified by GUIDE v2.5 07-Nov-2011 16:15:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rev0_OpeningFcn, ...
                   'gui_OutputFcn',  @rev0_OutputFcn, ...
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


% --- Executes just before rev0 is made visible.
function rev0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rev0 (see VARARGIN)

% Choose default command line output for rev0
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rev0 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rev0_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function open_oszi(handles)

global deviceObj;
    ip = get(handles.ip_edit,'String');
    % Create a VISA-TCPIP object.
    interfaceObj = instrfind('Type', 'visa-tcpip', 'RsrcName', sprintf('TCPIP0::%s::inst0::INSTR',ip), 'Tag', '');
    % Create the VISA-TCPIP object if it does not exist
    % otherwise use the object that was found.
    if isempty(interfaceObj)
        interfaceObj = visa('NI', sprintf('TCPIP0::%s::inst0::INSTR',ip));
    else
        fclose(interfaceObj);
        interfaceObj = interfaceObj(1);
    end
    deviceObj = icdevice('tektronix_tds7104.mdd', interfaceObj);
    % Connect device object to hardware.
    connect(deviceObj);
    res = selftest(deviceObj);
    if res ~= 0
       errordlg('Selftest failed');
    end
    model = get(deviceObj, 'InstrumentModel');
    msgbox(['Connected model: ',model],'SEEMS WORKING!!!');
    set(deviceObj.Acquisition(1), 'Control', 'run-stop');
    set(deviceObj.Acquisition(1), 'State', 'stop');




function ip_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ip_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ip_edit as text
%        str2double(get(hObject,'String')) returns contents of ip_edit as a double


% --- Executes during object creation, after setting all properties.
function ip_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ip_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in connect_button.
function connect_button_Callback(hObject, eventdata, handles)
% hObject    handle to connect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open_oszi(handles);


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deviceObj;

ch = str2num(get(handles.load_edit,'String'));

groupObj = get(deviceObj, 'System');
groupObj = groupObj(1);
invoke(groupObj, 'loadstate', ch);



function load_edit_Callback(hObject, eventdata, handles)
% hObject    handle to load_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of load_edit as text
%        str2double(get(hObject,'String')) returns contents of load_edit as a double


% --- Executes during object creation, after setting all properties.
function load_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to load_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function retrieve_trace(handles,filename);

global deviceObj;
i = 0 ;

set(deviceObj.Acquisition(1), 'State', 'stop');
set(deviceObj.Acquisition(1), 'Control', 'single');
set(deviceObj.Acquisition(1), 'State', 'run'); %%%% AcquisitionCount =0

while (get(deviceObj.Acquisition(1), 'AcquisitionCount') == 0 && i*5 <20)
    pause(0.2);
    i = i+1;
end
if i*5 <20 
    get_data_bunker(handles,0,filename)
else
    errordlg('TRIGGER TIMEOUT!!!');
end


% --- Executes on button press in getsingle_button.
function getsingle_button_Callback(hObject, eventdata, handles)
% hObject    handle to getsingle_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deviceObj;
set(deviceObj.Acquisition(1), 'State', 'stop');
set(deviceObj.Acquisition(1), 'Control', 'single');
set(deviceObj.Acquisition(1), 'State', 'run'); %%%% AcquisitionCount =0

filename = fullfile(get(handles.savefolder_button,'String'),...
    get(handles.filename_edit,'String'));
while (get(deviceObj.Acquisition(1), 'AcquisitionCount') == 0)
    pause(0.2);
end
get_data(handles,filename)

function change_enable(handles, mstate)

    set(handles.ip_edit,'Enable',mstate);
    
    set(handles.edit1,'Enable',mstate);
    set(handles.savefolder_button,'Enable',mstate);
    set(handles.startbutton,'Enable',mstate);
    set(handles.connect_button,'Enable',mstate);
    set(handles.load_button,'Enable',mstate);
    set(handles.getsingle_button,'Enable',mstate);
    set(handles.save_checkbox,'Enable',mstate);
    set(handles.load_edit,'Enable',mstate);



function get_data_bunker(handles, filename)
global deviceObj;
    
    groupObj = get(deviceObj, 'Waveform');
    groupObj = groupObj(1);
    
    savevar = get(handles.save_checkbox,'Value');
    
    if (get(handles.checkbox2,'Value'))
        [y, x, yUnit, xUnit] = invoke(groupObj, 'readwaveform', 'channel2',1);
        
        plot(handles.axes2,x,y,'b');
        
        if savevar
            dlmwrite([filename,'_CH2.txt'],[x',y']);
        end
        
    end
    
    if (get(handles.checkbox3,'Value'))
        [y, x, yUnit, xUnit] = invoke(groupObj, 'readwaveform', 'channel3',1);
        plot(handles.axes3,x,y,'r');
        if savevar
            dlmwrite([filename,'_CH3.txt'],[x',y']);
        end
    end
    
    if (get(handles.checkbox4,'Value'))
        [y, x, yUnit, xUnit] = invoke(groupObj, 'readwaveform', 'channel4',1);
        plot(handles.axes4,x,y,'g');
        if savevar
            dlmwrite([filename,'_CH4.txt'],[x',y']);
        end
    end 
    
drawnow;

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in getsequence_button.
function getsequence_button_Callback(hObject, eventdata, handles)
% hObject    handle to getsequence_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global deviceObj;
global mstop;

mstop = 0;
set(deviceObj.Acquisition(1), 'State', 'stop');
set(deviceObj.Acquisition(1), 'Control', 'single');
set(deviceObj.Acquisition(1), 'State', 'run')
set(deviceObj.Acquisition(1), 'State', 'stop');

oldn = get(deviceObj.Acquisition(1), 'AcquisitionCount')

set(deviceObj.Acquisition(1), 'Control', 'run-stop') %%%% AcquisitionCount =0
set(deviceObj.Acquisition(1), 'State', 'run');
filename = fullfile(get(handles.savefolder_button,'String'),...
    get(handles.filename_edit,'String'));
while (~mstop)
    n = get(deviceObj.Acquisition(1), 'AcquisitionCount');
    
    if n > oldn
        get_data(handles,n, filename)
        oldn = n
        set(handles.count_text,'String',num2str(n));
    end
    pause(0.05);
end


% --- Executes on button press in stopsequence_button.
function stopsequence_button_Callback(hObject, eventdata, handles)
% hObject    handle to stopsequence_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mstop

mstop = 1;


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in saveas_button.
function saveas_button_Callback(hObject, eventdata, handles)
% hObject    handle to saveas_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in savefolder_button.
function savefolder_button_Callback(hObject, eventdata, handles)
% hObject    handle to savefolder_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir;
set(handles.savefolder_button,'String',folder);



function filename_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_edit as text
%        str2double(get(hObject,'String')) returns contents of filename_edit as a double


% --- Executes during object creation, after setting all properties.
function filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_checkbox.
function save_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to save_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_checkbox



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


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mstop
global deviceObj;
                   
    savefolder= get(handles.savefolder_button,'String');
    tt=ftp(get(handles.edit1,'String'));
    if(strcmp(class(tt),'ftp')==0)
        msgbox('Could not establish connection to ftp server..');
        return;
    end
    
    mstop=0;
    change_enable(handles,'off');
    ascii(tt);
    drawnow;
    while(mstop==0)
        dirlisting=dir(tt)
        for(i=1:size(dirlisting,1))
            if(strcmp(dirlisting(i).name,'oszi_prepare'))
                  
               %pause(0.200);
               mget(tt,'oszi_prepare');
               aa=dlmread('oszi_prepare');   
               
               oszi_file=sprintf('%06d\\%s%03d\\%s%04d%s',aa(1),'Run',aa(2),'Shot',aa(3),'_oszi');
               mkdir([savefolder,sprintf('%06d\\%s%03d\\',aa(1),'Run',aa(2))]);
               filename = [savefolder,oszi_file];
               retrieve_trace(handles,filename);
               %%%% %nshots=nshots+1;
               set(handles.shotinfo,'String',sprintf('%06d  %s %03d  %s% 04d',aa(1),'Run',aa(2),'Shot',aa(3)));

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
    

    
    change_enable(handles,'on');

% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mstop
mstop=1;
