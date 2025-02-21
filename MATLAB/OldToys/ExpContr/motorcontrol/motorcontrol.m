function varargout = motorcontrol(varargin)
% MOTORCONTROL M-file for motorcontrol.fig
%      MOTORCONTROL, by itself, creates a new MOTORCONTROL or raises the existing
%      singleton*.
%
%      H = MOTORCONTROL returns the handle to a new MOTORCONTROL or the handle to
%      the existing singleton*.
%
%      MOTORCONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORCONTROL.M with the given input arguments.
%
%      MOTORCONTROL('Property','Value',...) creates a new MOTORCONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before motorcontrol_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to motorcontrol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help motorcontrol

% Last Modified by GUIDE v2.5 28-Oct-2011 16:53:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motorcontrol_OpeningFcn, ...
                   'gui_OutputFcn',  @motorcontrol_OutputFcn, ...
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


% --- Executes just before motorcontrol is made visible.
function motorcontrol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motorcontrol (see VARARGIN)

% Choose default command line output for motorcontrol
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes motorcontrol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = motorcontrol_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function openMot(handles)

    global hMot;
    
    if(~libisloaded('motlib'))
        loadlibrary('pcism32.dll','sm32.h','alias','motlib');
    end
    hMot= libpointer('int32Ptr',-1313);
    hAns= libpointer('int32Ptr',0);
    hmpos= libpointer('int32Ptr',-1313);
    %str2num(get(handles.edit7,'String'))
    
    mnumb = str2num(get(handles.edit2,'String'));
    mboard = str2num(get(handles.edit1,'String'));
    
    mres=calllib('motlib','SM32Init',hMot, mnumb , mboard);
    msgbox(num2str(mres));
        %        /*-- switch on/off --*/
    %#define mcPower       6    /* RW (all off = clear error)           */
    %#define   mpOff         0  /*      Motor Power : Off               */
    %#define   mpOn          1  /*      Motor Power : On                */
    %#define   mpShutdown   -1  /*      Motor Power : Shutdown          */    
    calllib('motlib','SM32Write', hMot,6 , 1 );
            %/*-- move --*/
    %#define mcPosMode     8    /* RW set positioning mode              */
    %#define   mmMove  1        /*      move with given speed           */
    %#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
    %#define mcPosition    9    /* RW set position counter              */
    %#define mcA           3    /* RW set nominal acceleration          */
    %#define mcF           1    /* RW set nominal speed                 */
    %#define mcFact       26    /* R  read actual speed                 */
    %#define mcGo          7    /*  W go to destination                 */
    %#define mcGoHome     15    /*  W go home  
    mVel=str2num(get(handles.velo,'String'));
    mAcc=str2num(get(handles.acc,'String'));
    
    calllib('motlib','SM32Write', hMot,1 , mVel );
    calllib('motlib','SM32Write',hMot,3,mAcc);
    
    %        /*-- general settings --*/
    %#define mcU           5    /* RW set nominal motor voltage         */
    %#define mcUhold      12    /* RW set standstill voltage in %       */
    %#define mcStepWidth  17    /* RW step width and direction          */
    %#define mcAmax        4    /* RW set maximum acceleration          */
    %#define mcFmax        2    /* RW set maximum speed                 */
    %#define mcSwitchMode 11    /* RW assign limit switches             */
    
    mU=str2num(get(handles.volt,'String'));
    calllib('motlib','SM32Write',hMot,5,mU);
    
    %get position:
    %#define mcPosition    9    /* RW set position counter              */
    %#define mcA           3    /* RW set nominal acceleration          */
    %#define mcF           1    /* RW set nominal speed                 */
    %#define mcFact       26    /* R  read actual speed                 */
    %#define mcGo          7    /*  W go to destination                 */
    %#define mcGoHome     15    /*  W go home                           */    
    calllib('motlib','SM32Read', hMot,9 , hmpos );
    set(handles.edit6,'String',get(hmpos,'Value'));



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
openMot(handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hMot;
if(libisloaded('motlib'))
    calllib('motlib','SM32Done', hMot);
    unloadlibrary('motlib')
end




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



function velo_Callback(hObject, eventdata, handles)
% hObject    handle to velo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of velo as text
%        str2double(get(hObject,'String')) returns contents of velo as a double


% --- Executes during object creation, after setting all properties.
function velo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function acc_Callback(hObject, eventdata, handles)
% hObject    handle to acc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acc as text
%        str2double(get(hObject,'String')) returns contents of acc as a double


% --- Executes during object creation, after setting all properties.
function acc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function volt_Callback(hObject, eventdata, handles)
% hObject    handle to volt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volt as text
%        str2double(get(hObject,'String')) returns contents of volt as a double


% --- Executes during object creation, after setting all properties.
function volt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volt (see GCBO)
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

    global hMot;
    hAns= libpointer('int32Ptr',0);    
    if(~libisloaded('motlib'))
        openMot(handles);
        return;
    end
        %        /*-- switch on/off --*/
    %#define mcPower       6    /* RW (all off = clear error)           */
    %#define   mpOff         0  /*      Motor Power : Off               */
    %#define   mpOn          1  /*      Motor Power : On                */
    %#define   mpShutdown   -1  /*      Motor Power : Shutdown          */    
    calllib('motlib','SM32Write', hMot,6 , 1 );
            %/*-- move --*/
    %#define mcPosMode     8    /* RW set positioning mode              */
    %#define   mmMove  1        /*      move with given speed           */
    %#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
    %#define mcPosition    9    /* RW set position counter              */
    %#define mcA           3    /* RW set nominal acceleration          */
    %#define mcF           1    /* RW set nominal speed                 */
    %#define mcFact       26    /* R  read actual speed                 */
    %#define mcGo          7    /*  W go to destination                 */
    %#define mcGoHome     15    /*  W go home  
    mVel=str2num(get(handles.velo,'String'));
    mAcc=str2num(get(handles.acc,'String'));
    
    calllib('motlib','SM32Write', hMot,1 , mVel );
    calllib('motlib','SM32Write',hMot,3,mAcc);
    
    %        /*-- general settings --*/
    %#define mcU           5    /* RW set nominal motor voltage         */
    %#define mcUhold      12    /* RW set standstill voltage in %       */
    %#define mcStepWidth  17    /* RW step width and direction          */
    %#define mcAmax        4    /* RW set maximum acceleration          */
    %#define mcFmax        2    /* RW set maximum speed                 */
    %#define mcSwitchMode 11    /* RW assign limit switches             */
    
    mU=str2num(get(handles.volt,'String'));
    calllib('motlib','SM32Write',hMot,5,mU);
    
    %get position:
    %#define mcPosition    9    /* RW set position counter              */
    %#define mcA           3    /* RW set nominal acceleration          */
    %#define mcF           1    /* RW set nominal speed                 */
    %#define mcFact       26    /* R  read actual speed                 */
    %#define mcGo          7    /*  W go to destination                 */
    %#define mcGoHome     15    /*  W go home                           */    
%    calllib('motlib','SM32Read', hMot,9 , hmpos );
%    set(handles.edit6,'String',get(hmpos,'Value'));


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hMot;
    hAns= libpointer('int32Ptr',0);    
    if(~libisloaded('motlib'))
       openMot(handles);
    end
    
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 1 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home                           */    
    calllib('motlib','SM32Write', hMot,1 , -600 );
    calllib('motlib','SM32Write', hMot,15 , 600 );
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.1);
        if(get(hAns,'Value')==0)
            break;
        end
    end
    %set position to 0:
   calllib('motlib','SM32Write',hMot,9,0);
    hmpos= libpointer('int32Ptr',-1313);
    %get current position:
    calllib('motlib','SM32Read', hMot,9 , hmpos );
    set(handles.edit6,'String',get(hmpos,'Value'));



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


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.edit6,'String',getPos(handles));
    
function pos=getPos(handles)
    global hMot;
    hmpos= libpointer('int32Ptr',-1313);
    hAns= libpointer('int32Ptr',0);    
    if(~libisloaded('motlib'))
        openMot(handles);
    end
    
    %get position:
    %#define mcPosition    9    /* RW set position counter              */
    %#define mcA           3    /* RW set nominal acceleration          */
    %#define mcF           1    /* RW set nominal speed                 */
    %#define mcFact       26    /* R  read actual speed                 */
    %#define mcGo          7    /*  W go to destination                 */
    %#define mcGoHome     15    /*  W go home                           */    
    calllib('motlib','SM32Read', hMot,9 , hmpos );
    pos=get(hmpos,'Value');
    set(handles.edit6,'String',pos);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global hMot;
    hAns= libpointer('int32Ptr',0);    
    if(~libisloaded('motlib'))
        openMot(handles);
    end
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 1 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home  
    
    calllib('motlib','SM32Write', hMot,1 ,  str2num(get(handles.velo,'String')));
    calllib('motlib','SM32Write', hMot,7 , -str2num(get(handles.relsteps,'String')) );
    
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.05);
        if(get(hAns,'Value')==0)
            break;
        end
    end
    hmpos= libpointer('int32Ptr',-1313);
    %get current position:
    calllib('motlib','SM32Read', hMot,9 , hmpos );
    set(handles.edit6,'String',get(hmpos,'Value'));


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global hMot;
    hAns= libpointer('int32Ptr',0);    
    if(~libisloaded('motlib'))
        openMot(handles);
    end
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 1 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home  
    
    calllib('motlib','SM32Write', hMot,1 ,  str2num(get(handles.velo,'String')));
    calllib('motlib','SM32Write', hMot,7 , str2num(get(handles.relsteps,'String')) );
    
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.05);
        if(get(hAns,'Value')==0)
            break;
        end
    end
    hmpos= libpointer('int32Ptr',-1313);
    %get current position:
    calllib('motlib','SM32Read', hMot,9 , hmpos );
    set(handles.edit6,'String',get(hmpos,'Value'));



function relsteps_Callback(hObject, eventdata, handles)
% hObject    handle to relsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of relsteps as text
%        str2double(get(hObject,'String')) returns contents of relsteps as a double


% --- Executes during object creation, after setting all properties.
function relsteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to relsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    moveA(handles);
    set(handles.edit6,'String',getPos(handles));
    
    
    
function moveA(handles)
    global hMot;
    hAns= libpointer('int32Ptr',0);    
    if(~libisloaded('motlib'))
        openMot(handles);
    end
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 0 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home  
    
    calllib('motlib','SM32Write', hMot,1 ,  str2num(get(handles.velo,'String')));
    calllib('motlib','SM32Write', hMot,7 , str2num(get(handles.abssteps,'String')) );
    
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.05);
        if(get(hAns,'Value')==0)
            break;
        end
    end

function moveA2(handles)
    global hMot;
    hAns= libpointer('int32Ptr',0);    
    if(~libisloaded('motlib'))
        openMot(handles);
    end
            %/*-- move --*/
%#define mcPosMode     8    /* RW set positioning mode              */
%#define   mmMove  1        /*      move with given speed           */
%#define   mmPos   3        /*      move to given position          */
    calllib('motlib','SM32Write', hMot,8 , 3 );
    
%#define mcAbsRel     28    /* RW set absolute/relative mode        */
%#define   mmAbs   0        /*      absolute positioning            */
%#define   mmRel   1        /*      relative positioning            */    
    calllib('motlib','SM32Write', hMot,28 , 0 );
    
%#define mcPosition    9    /* RW set position counter              */
%#define mcA           3    /* RW set nominal acceleration          */
%#define mcF           1    /* RW set nominal speed                 */
%#define mcFact       26    /* R  read actual speed                 */
%#define mcGo          7    /*  W go to destination                 */
%#define mcGoHome     15    /*  W go home  
    
    calllib('motlib','SM32Write', hMot,1 ,  str2num(get(handles.velo,'String')));
    calllib('motlib','SM32Write', hMot,7 , str2num(get(handles.edit9,'String')) );
    
%#define mcState      29    /* R  stands : 0                        */
%#define   mstNone    0     /*      motor stands                    */
%#define   mstMove    1     /*      motor runs (in mode mmMove)     */
%#define   mstPos     3     /*      motor runs (in mode mmPos)      */
%#define   mstHome    8     /*      motor performs homing           */
%#define   mstBreak   9     /*      motor performs fast break       */    
    while(1)
        calllib('motlib','SM32Read', hMot,29 , hAns );
        drawnow;
        pause(0.05);
        if(get(hAns,'Value')==0)
            break;
        end
    end

function abssteps_Callback(hObject, eventdata, handles)
% hObject    handle to abssteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of abssteps as text
%        str2double(get(hObject,'String')) returns contents of abssteps as a double


% --- Executes during object creation, after setting all properties.
function abssteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to abssteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    moveA2(handles);
    set(handles.edit6,'String',getPos(handles));


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
