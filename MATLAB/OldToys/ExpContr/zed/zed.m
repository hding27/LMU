function varargout = zed(varargin)
% ZED M-file for zed.fig
%      ZED, by itself, creates a new ZED or raises the existing
%      singleton*.
%
%      H = ZED returns the handle to a new ZED or the handle to
%      the existing singleton*.
%
%      ZED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZED.M with the given input arguments.
%
%      ZED('Property','Value',...) creates a new ZED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zed_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zed_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zed

% Last Modified by GUIDE v2.5 19-Jun-2011 15:39:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zed_OpeningFcn, ...
                   'gui_OutputFcn',  @zed_OutputFcn, ...
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


% --- Executes just before zed is made visible.
function zed_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zed (see VARARGIN)

% Choose default command line output for zed
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes zed wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clc

% --- Outputs from this function are returned to the command line.
function varargout = zed_OutputFcn(hObject, eventdata, handles) 
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
    openMot(handles);
    
function openMot(handles)

    global hMot;
    
    if(~libisloaded('motlib'))
        loadlibrary('pcism32.dll','sm32.h','alias','motlib');
    end
    hMot= libpointer('int32Ptr',-1313);
    hAns= libpointer('int32Ptr',0);
    hmpos= libpointer('int32Ptr',-1313);
    %str2num(get(handles.edit7,'String'))
    mres=calllib('motlib','SM32Init',hMot,3 , 1   );
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
    mVel=str2num(get(handles.edit1,'String'));
    mAcc=str2num(get(handles.edit4,'String'));
    
    calllib('motlib','SM32Write', hMot,1 , mVel );
    calllib('motlib','SM32Write',hMot,3,mAcc);
    
    %        /*-- general settings --*/
    %#define mcU           5    /* RW set nominal motor voltage         */
    %#define mcUhold      12    /* RW set standstill voltage in %       */
    %#define mcStepWidth  17    /* RW step width and direction          */
    %#define mcAmax        4    /* RW set maximum acceleration          */
    %#define mcFmax        2    /* RW set maximum speed                 */
    %#define mcSwitchMode 11    /* RW assign limit switches             */
    
    mU=str2num(get(handles.edit5,'String'));
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

    
    

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
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
   


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
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
    
    calllib('motlib','SM32Write', hMot,1 ,  str2num(get(handles.edit1,'String')));
    calllib('motlib','SM32Write', hMot,7 , str2num(get(handles.edit2,'String')) );
    
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
    



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
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
    
    calllib('motlib','SM32Write', hMot,1 ,  str2num(get(handles.edit1,'String')));
    calllib('motlib','SM32Write', hMot,7 , str2num(get(handles.edit3,'String')) );
    
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
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
    mVel=str2num(get(handles.edit1,'String'));
    mAcc=str2num(get(handles.edit4,'String'));
    
    calllib('motlib','SM32Write', hMot,1 , mVel );
    calllib('motlib','SM32Write',hMot,3,mAcc);
    
    %        /*-- general settings --*/
    %#define mcU           5    /* RW set nominal motor voltage         */
    %#define mcUhold      12    /* RW set standstill voltage in %       */
    %#define mcStepWidth  17    /* RW step width and direction          */
    %#define mcAmax        4    /* RW set maximum acceleration          */
    %#define mcFmax        2    /* RW set maximum speed                 */
    %#define mcSwitchMode 11    /* RW assign limit switches             */
    
    mU=str2num(get(handles.edit5,'String'));
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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hMot;
if(libisloaded('motlib'))
    calllib('motlib','SM32Done', hMot);
    unloadlibrary('motlib')
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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
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
    
    calllib('motlib','SM32Write', hMot,1 ,  str2num(get(handles.edit1,'String')));
    calllib('motlib','SM32Write', hMot,7 , -str2num(get(handles.edit2,'String')) );
    
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



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
%axes(hObject);
%mzed=imread('zed.png');
%image(mzed);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global mstop;
    mstop=0;
    set(handles.pushbutton9,'Enable','off');
    
    flag_name=get(handles.edit13,'String');
    
    tt=ftp(get(handles.edit12,'String'));
    if(strcmp(class(tt),'ftp')==0)
        msgbox('Could not establish ftp connection to the server...');
        mstop=1;
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
                set(handles.edit14,'String',aa(1));
                set(handles.edit15,'String',aa(2));
                set(handles.edit16,'String',aa(3));                
                
                %first - check whether the date dir exists. if not -
                %create:
                mpath=get(handles.edit10,'String');
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
                mpos=getPos(handles);
                set(handles.edit6,'String',mpos);                
                fprintf(fid,'%d\t%d\r\n',aa(3),mpos);
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
                
                set(handles.edit3,'String',aa(1));
                moveA(handles);
                %first - check whether the date dir exists. if not -
                %create:
                mpath=get(handles.edit10,'String');
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
                mpos=getPos(handles);
                set(handles.edit6,'String',mpos);
                fprintf (fid,'%d',mpos);
                fclose(fid);
                
                
                mput(tt,rep_file);
                
                break;

            end
            
        end
        
        %show that we're still alive:
        if(strcmp(get(handles.text8,'String'),'O')==0)
            set(handles.text8,'String','O');
        else
            set(handles.text8,'String','X');
        end
        
        drawnow;
        pause(0.5);
    end
    
    close(tt);
    
    set(handles.pushbutton9,'Enable','on');
    


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mstop;
mstop=1;


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



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
