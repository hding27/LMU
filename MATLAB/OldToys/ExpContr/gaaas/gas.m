function varargout = gas(varargin)
% GAS M-file for gas.fig
%      GAS, by itself, creates a new GAS or raises the existing
%      singleton*.
%
%      H = GAS returns the handle to a new GAS or the handle to
%      the existing singleton*.
%
%      GAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GAS.M with the given input arguments.
%
%      GAS('Property','Value',...) creates a new GAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gas

% Last Modified by GUIDE v2.5 22-Jan-2012 00:12:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gas_OpeningFcn, ...
                   'gui_OutputFcn',  @gas_OutputFcn, ...
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


% --- Executes just before gas is made visible.
function gas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gas (see VARARGIN)

% Choose default command line output for gas
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gas wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global cset;
cset=0;

% --- Outputs from this function are returned to the command line.
function varargout = gas_OutputFcn(hObject, eventdata, handles) 
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
global mrunning;
global cset;
if(mrunning==0)
    msgbox('First open regulator!!');
    return;
end
cset=str2num(get(handles.edit1,'String'));
calllib('tescom','WriteNetVar',250,37,cset*3.3+400);

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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global mstop;
    global mrunning;
    global cset;
    
    if(mrunning==0)
        msgbox('first open device!');
        return;
    end
    
    mstop=0;
    set(handles.pushbutton2,'Enable','off');
    
    flag_name=get(handles.edit2,'String');
    
    tt=ftp(get(handles.edit3,'String'));
    if(strcmp(class(tt),'ftp')==0)
        msgbox('Could not establish ftp connection to the server...');
        mstop=1;
    end
    
    
    puint= libpointer('uint16Ptr',0);


    ftpdirlist=dir(tt);
    for(i=1:size(ftpdirlist,1))
       if(strcmp(ftpdirlist(i).name,strcat(flag_name,'_prepare')))
            delete(tt,ftpdirlist(i).name);
       elseif(strcmp(ftpdirlist(i).name,strcat(flag_name,'_doit')))
            delete(tt,ftpdirlist(i).name);
       end
    end
    
    while(mstop==0)
        
        ftpdirlist=dir(tt);
        for(i=1:size(ftpdirlist,1))
            if(strcmp(ftpdirlist(i).name,strcat(flag_name,'_prepare')))
                %get actual position and report it
                pause(0.100);
                
                ff=char(mget(tt,ftpdirlist(i).name));
                aa=dlmread(ff);
                delete(tt,ftpdirlist(i).name);
                
                %in aa first line - date, second - run number, third - shot number
                set(handles.edit5,'String',aa(1));
                set(handles.edit6,'String',aa(2));
                set(handles.edit7,'String',aa(3));                
                
                %first - check whether the date dir exists. if not -
                %create:
                mpath=get(handles.edit9,'String');
                if(mpath(length(mpath))~='\')
                    mpath=strcat(mpath,'\');
                end
                mpath=strcat(mpath,num2str(aa(1),'%06d'),'\');
                if(exist(mpath,'dir')==0)
                    mkdir(mpath);
                end

                %second - check whether the run dir exists. if not - create
                pathWithRun=sprintf('%s%s%03d%s',mpath,'Run',aa(2),'\');
                if(exist(pathWithRun,'dir')==0)
                    mkdir(pathWithRun);
                end
                
                %construct file names for lanes, log and spectrum:


                log_file=sprintf('%s%s%s',pathWithRun,flag_name,'_log.txt');
                
                %now - acquire image!
                fid=fopen(log_file,'a');

                %process spectrum picture:
                calllib('tescom','ReadNetVar',250,44,puint);
                mv=get(puint,'Value');
                
                fprintf(fid,'%d\t%d\r\n',aa(3),mv);
                fclose(fid);
                
                %save results at the server
                mkdir(tt,sprintf('%06d',aa(1)));
                mkdir(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
                cd(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
                
                mput(tt,log_file);
                
                cd(tt,'/');
                
                break;
            elseif(strcmp(ftpdirlist(i).name,strcat(flag_name,'_doit')))
                %move the stage:
                pause(0.100);
                
                ff=char(mget(tt,ftpdirlist(i).name));
                aa=dlmread(ff);
                delete(tt,ftpdirlist(i).name);
                cset=aa;
                set(handles.edit1,'String',cset);
                calllib('tescom','WriteNetVar',250,37,cset);
                %first - check whether the date dir exists. if not -
                %create:
                mpath=get(handles.edit9,'String');
                if(mpath(length(mpath))~='\')
                    mpath=strcat(mpath,'\');
                end
                mpath=strcat(mpath,num2str(aa(1),'%06d'),'\');
                if(exist(mpath,'dir')==0)
                    mkdir(mpath);
                end

                
                %construct file names for lanes, log and spectrum:


                rep_file=sprintf('%s%s%s',mpath,flag_name,'_done');
                
                %now - acquire image!
                fid=fopen(rep_file,'w');
                %process spectrum picture:
                
                
                fprintf (fid,'%d',cset);
                fclose(fid);
                
                
                mput(tt,rep_file);
                
                break;

            end
            
        end
        
        %show that we're still alive:
         if(strcmp(get(handles.edit13,'String'),'O')==0)
             set(handles.edit13,'String','O');
         else
             set(handles.edit13,'String','X');
         end
        updateplot(handles);
        drawnow;
        pause(0.5);
    end
    
    close(tt);
    
    set(handles.pushbutton2,'Enable','on');



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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global mrunning;
    mrunning=0;
    drawnow;
    pause(0.5);
    drawnow;
    calllib('tescom','Shutdown');
    unloadlibrary('tescom');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mrunning;
global cset;
global press;
global ci;
press=zeros(100,1);
ci=1;

if(mrunning==1)
    return;
end
loadlibrary('tescom',@tescommex);
aa=calllib('tescom','Startup')
if(aa==1);
    mrunning=1;
else
    return;
end

while(mrunning==1)
    updateplot(handles);
    pause(0.5);
    drawnow;
end

function updateplot(handles)
global press;
global ci;
global mrunning;
global cset;
puint= libpointer('uint16Ptr',0);
if(isempty(ci))
    ci=1;
end
if(mrunning==0)
    return;
end
    calllib('tescom','ReadNetVar',250,44,puint);
    aa=((get(puint,'Value')-400)/3.3);    
    press(ci)=aa;
    ci=ci+1;
    if(ci>100)
        ci=1;
    end
    axes(handles.axes1);
    yl=get(gca,'YLim');
    
    plot(1:100,press);
    line([1,100],[cset cset]);
    line([ci-1 ci-1],yl);
    set(handles.axes1,'YLim',yl);


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mmin=str2double(get(handles.edit12,'String'));
mmax=str2double(get(handles.edit10,'String'));
set(handles.axes1,'YLim',[mmin mmax]);



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global mrunning;
if(mrunning==1)
    pushbutton3_Callback(hObject, eventdata, handles);
end
delete(hObject);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mstop;
mstop=1;


function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
