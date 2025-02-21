function varargout = mcam(varargin)
% MCAM M-file for mcam.fig
%      MCAM, by itself, creates a new MCAM or raises the existing
%      singleton*.
%
%      H = MCAM returns the handle to a new MCAM or the handle to
%      the existing singleton*.
%
%      MCAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MCAM.M with the given input arguments.
%
%      MCAM('Property','Value',...) creates a new MCAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mcam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mcam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mcam

% Last Modified by GUIDE v2.5 11-Jul-2010 17:42:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mcam_OpeningFcn, ...
                   'gui_OutputFcn',  @mcam_OutputFcn, ...
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


% --- Executes just before mcam is made visible.
function mcam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mcam (see VARARGIN)

% Choose default command line output for mcam
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mcam wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mcam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- OPEN CAMERA
function pushbutton1_Callback(hObject, eventdata, handles)
    set(handles.pushbutton1,'Enable','off');
    drawnow
    openCam(hObject, eventdata,handles);
    set(handles.pushbutton1,'Enable','on');
    
function openCam(hObject, eventdata,handles)
    if not(libisloaded('PCO_PF_SDK'))
         loadlibrary('pccamvb','pccamvb.h','alias','PCO_PF_SDK');
    end



    % default parameters for camera setmode
    handles.hbin = 0; % horizontal binning 1
    handles.vbin = 0; % vertical binning 1
    handles.exposure = 60; % exposure time in ms
    handles.gain = 0;

    %%MODE!!
    %                            0x10 d16 single asynchron shutter, hardware trigger
    %                            0x11 d17 single asynchron shutter, software trigger
    %                            0x20 d32 double asynchron shutter, hardware trigger
    %                            0x21 d33 double asynchron shutter, software trigger
    %                            0x30 d48 video mode, hardware trigger
    %                            0x31 d49 video, software trigger
    %                            0x40 d64 single auto exposure, hardware trigger
    %                            0x41 d65 single auto exposure, software trigger

    handles.mode = 49;	
    handles.bit_pix = 12;
    handles.color=0;
    board_number=0;


    [error_code,board_handle] = pfINITBOARD(board_number);
    if(error_code~=0) 
         error(['Could not initialize camera. Error is ',int2str(error_code)]);
         return;
    end 
    handles.board_handle=board_handle;

 
    error_code = pfSETMODE(handles.board_handle, handles.mode, 0, handles.exposure,	handles.hbin,handles.vbin,handles.gain, 0,handles.bit_pix,0);

    if error_code ~= 0
        error('....initial setmode failed!');
    end

    [error_code,ccd_width,ccd_height,image_width,image_height,bit_pix]=pfGETSIZES(handles.board_handle);
    handles.ccd_width = ccd_width;
    handles.ccd_height = ccd_height;
    handles.image_width = image_width;
    handles.image_height = image_height;
    handles.imagesize=image_width*image_height*floor((bit_pix+7)/8);
    handles.bit_pix=bit_pix;

    handles.depth=2; 

    %we start with bw image also for color cameras
    handles.color=0;
    handles.image = zeros(double(handles.image_height), double(handles.image_width),3,'uint8');
    handles.image_buffer_map = imagesc(handles.image);
    handles.rgb_image = zeros(handles.image_width*3,handles.image_height,'uint8');

    handles.gamma=1.0; 
    handles.dgain=75;

    if not(libisloaded('PCO_CNV_SDK'))
        loadlibrary('pcocnv','pcocnv.h','alias','PCO_CNV_SDK');
    end 

    handles.bwlutptr=libpointer('voidPtr');
    handles.bwlutptr=calllib('PCO_CNV_SDK', 'CREATE_BWLUT_EX', handles.bit_pix,0,255,0);
    handles.minbw=20;
    handles.maxbw=3072;
    calllib('PCO_CNV_SDK', 'CONVERT_SET_EX',handles.bwlutptr,handles.minbw,handles.maxbw,0,handles.gamma);

    handles.colorlutptr=libpointer('voidPtr');
    handles.colorlutptr=calllib('PCO_CNV_SDK', 'CREATE_COLORLUT_EX', handles.bit_pix,0,255,0);
    handles.maxred=3072;
    handles.maxgreen=3072;
    handles.maxblue=3072;
 
    calllib('PCO_CNV_SDK', 'CONVERT_SET_COL_EX',handles.colorlutptr,100,100,100,handles.maxred,handles.maxgreen,handles.maxblue,0,handles.gamma,50);

    [error_code, value] = pfGETBOARDVAL(handles.board_handle,'PCC_VAL_EXTMODE');
    

    bufnr=-1;
    bufsize=ccd_width*ccd_height*2;
    [error_code,bufnr] = pfALLOCATE_BUFFER(handles.board_handle,bufnr,bufsize);
    if error_code ~= 0
        error('....memory allocation failed!');
    end
    handles.bufnr=bufnr;

    [error_code,bufaddress] = pfMAP_BUFFER_EX(handles.board_handle,bufnr,bufsize);
    if error_code ~= 0
        error('....map buffer error!');
    end
    handles.bufaddress = bufaddress; 

    bufnr1=-1;
    [error_code,bufnr1] = pfALLOCATE_BUFFER(handles.board_handle,bufnr1,bufsize);
    handles.bufnr1=bufnr1;
    [error_code,bufaddress] = pfMAP_BUFFER_EX(handles.board_handle,bufnr1,bufsize);
    if error_code ~= 0
        error('....map buffer error!');
    end
    handles.bufaddress1 = bufaddress; 



    maxlut=(2^handles.bit_pix)-1;







    % Update handles structure
    guidata(hObject, handles);







% --- CLOSE CAMERA!!!
function pushbutton3_Callback(hObject, eventdata, handles)

    set(handles.pushbutton3,'Enable','off');
    drawnow;
    closeCam(hObject, eventdata,handles);
    set(handles.pushbutton3,'Enable','on');
    
function closeCam(hObject,eventdata,handles)
    error_code = pfSTOP_CAMERA(handles.board_handle);
    if error_code ~= 0
         error('....quit_Callback: pfSTOP_CAMERA error!')
    end

    error_code = pfUNMAP_BUFFER(handles.board_handle,handles.bufnr1);
    if error_code ~= 0
        error('....unmap buffer error!')
    end
    error_code = pfFREE_BUFFER(handles.board_handle,handles.bufnr1);
    if error_code ~= 0
        error('....unmap buffer error!')
    end

    error_code = pfUNMAP_BUFFER(handles.board_handle,handles.bufnr);
    if error_code ~= 0
        error('....unmap buffer error!')
    end
    error_code = pfFREE_BUFFER(handles.board_handle,handles.bufnr);
    if error_code ~= 0
        error('....unmap buffer error!')
    end
    error_code = pfCLOSEBOARD(handles.board_handle);
    if error_code ~= 0
        error('....disconnected error!');
    end

    if (libisloaded('PCO_PF_SDK'))
        unloadlibrary('PCO_PF_SDK');
    end

    if (libisloaded('PCO_CNV_SDK'))
    
        calllib('PCO_CNV_SDK','DELETE_COLORLUT_EX',handles.colorlutptr);
        calllib('PCO_CNV_SDK','DELETE_BWLUT_EX',handles.bwlutptr);
    
        unloadlibrary('PCO_CNV_SDK');
    end


% --- GRAB SINGLE IMAGE SOFTWARE TRIGGER
function pushbutton2_Callback(hObject, eventdata, handles)

    set(handles.pushbutton2,'Enable','off');
    drawnow;
    mimg=grabSingle(hObject, eventdata,handles,1);
    axes(handles.axes1);
    imagesc(mimg);
    set(handles.pushbutton2,'Enable','on');
    
% --- GRAB SINGLE IMAGE HARDWARE TRIGGER
function pushbutton5_Callback(hObject, eventdata, handles)

    set(handles.pushbutton5,'Enable','off');
    drawnow;
    mimg=grabSingle(hObject, eventdata,handles,0);
    axes(handles.axes1);
    imagesc(mimg);
    set(handles.pushbutton5,'Enable','on');


function mimage=grabSingle(hObject, eventdata, handles, swtriggered)
    dispon=0;
    mimage=zeros(handles.image_height,handles.image_width);
    mStop=0;
    %%MODE!!
    %                            0x10 d16 single asynchron shutter, hardware trigger
    %                            0x11 d17 single asynchron shutter, software trigger
    %                            0x20 d32 double asynchron shutter, hardware trigger
    %                            0x21 d33 double asynchron shutter, software trigger
    %                            0x30 d48 video mode, hardware trigger
    %                            0x31 d49 video, software trigger
    %                            0x40 d64 single auto exposure, hardware trigger
    %                            0x41 d65 single auto exposure, software trigger

    if(swtriggered==1)
        handles.mode = 49;	
    else
        handles.mode= 48;
    end

    error_code = pfSETMODE(handles.board_handle, handles.mode, 0, handles.exposure,	handles.hbin,handles.vbin,handles.gain, 0,handles.bit_pix,0);

    if error_code ~= 0
        msgbox('....initial setmode failed!');
        return
    end


    error_code = pfSTART_CAMERA(handles.board_handle);
    if error_code ~= 0
        msgbox(['....grab_Callback: START_CAMERA error!',int2str(error_code)]);
        return
    end

    error_code =pfADD_BUFFER_TO_LIST(handles.board_handle,handles.bufnr, handles.imagesize,0,0);
    if error_code ~= 0
       msgbox('....takeimage_pushbutton_Callback: add buffer error!')
       mStop=1;
    end

    if(mStop==0)
        error_code = pfTRIGGER_CAMERA(handles.board_handle);
        if error_code ~= 0
            msgbox('....takeimage_pushbutton_Callback: pfTRIGGER_CAMERA error!')
            mStop=1;
        end
    end

    if(mStop==0)
        % wait for buffer
        [error_code,ima_bufnr]=pfWAIT_FOR_BUFFER(handles.board_handle,handles.exposure+10000,handles.bufnr);
        if(error_code~=0) 
            msgbox(['WAIT_FOR_BUFFER failed. Error is ',int2str(error_code)]);
            mStop=1;
        end

        if(ima_bufnr<0)
            error_code=1;    
        end

        if(error_code==0)

            result_image_ptr = libpointer('uint8Ptr',handles.rgb_image);

            calllib('PCO_CNV_SDK','CONV_BUF_12TO24',0,handles.image_width,handles.image_height,handles.bufaddress,result_image_ptr,handles.bwlutptr);
    
            rgb_image=get(result_image_ptr,'Value'); 
            for(yy=1:handles.image_height)
                for(xx=1:handles.image_width)
                    mimage(yy,xx)=rgb_image(xx*3-1,yy);
                end
            end
        
        
        elseif(mStop==0)
            error_code =pfREMOVE_BUFFER_FROM_LIST(handles.board_handle,handles.bufnr);
            if error_code ~= 0
                msgbox(['....grab_Callback: REMOVE_BUFFER_FROM_LIST error!',int2str(error_code)]) 
            end
        end
    end
    
    error_code = pfSTOP_CAMERA(handles.board_handle);
    if error_code ~= 0
        error(['....grab_Callback:  STOP_CAMERA error!',int2str(error_code)]);
    end
    handles.image_in_buffer='yes';
    guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagesc(zeros(100,100));




