function varargout = untitled(varargin)

    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)

    handles.output = hObject;
    guidata(hObject, handles);

    clc
    global mscriptpath;
    if(isdeployed)
        [bla mscriptpath]=dos('cd');
        mscriptpath=strcat(mscriptpath,'\\');
    else
        mscriptpath=mfilename('fullpath');
        lastslash=strfind(mscriptpath,'\');
        lastslash=lastslash(length(lastslash));
        mscriptpath=mscriptpath(1:lastslash);
    end
    
    if(exist(strcat(mscriptpath,'speccalibpath.txt'),'file')~=0)
        mf=fopen(strcat(mscriptpath,'speccalibpath.txt'),'r');
        mpt=fscanf(mf,'%c');
        set(handles.edit2,'String',mpt);
        fclose(mf);
    end
    if(exist(strcat(mscriptpath,'values.txt'),'file')~=0)
    
        load_settings(handles,strcat(mscriptpath,'values.txt'));
    end

    axes(handles.axes2);
    ylabel('Charge [a.u.]');
    xlabel('Energy [eV]');
    title('Energy spectrum integrated');
%    set(handles.uitable1,'Data',num2cell([1:10;1:10]'));
    
function load_settings(handles,mfile)

        mf=fopen(mfile,'r');

        if(strcmp(fgetl(mf),'v0.3')==0)
            fclose(mf);
            return;
        end
        mstr=fgetl(mf);
        mcell=textscan(mstr,'%s\t%f');
        set(handles.edit6,'String',mcell{2});            
        fgetl(mf);  %skip imaging calibration header
        mcellarr=[];
        for(i=1:10)
            mcellarr=[mcellarr;textscan(fgetl(mf),'%f\t%f')];
        end
        set(handles.uitable1,'Data',mcellarr);
        fgetl(mf);  %skip imaging calibration footer
        
        mcell=textscan(fgetl(mf),'%s\t%f');
        set(handles.ll,'String',mcell{2});
        mcell=textscan(fgetl(mf),'%s\t%f');
        set(handles.rr,'String',mcell{2});
        mcell=textscan(fgetl(mf),'%s\t%f');                    
        set(handles.tt,'String',mcell{2});
        mcell=textscan(fgetl(mf),'%s\t%f');                    
        set(handles.bb,'String',mcell{2});
        mcell=textscan(fgetl(mf),'%s\t%f');                    
        set(handles.background_left,'String',mcell{2});
        mcell=textscan(fgetl(mf),'%s\t%f');                    
        set(handles.background_right,'String',mcell{2});
        mcell=textscan(fgetl(mf),'%s\t%f');                    
        set(handles.background_top,'String',mcell{2});
        mcell=textscan(fgetl(mf),'%s\t%f');                    
        set(handles.background_bottom,'String',mcell{2});
                    
        fclose(mf);

 % --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% save values for ever!
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global mscriptpath;


    mf=fopen(strcat(mscriptpath,'values.txt'),'w');
    fprintf(mf,'v0.3\r\n');
    fprintf(mf,'charge_calib:\t%g\r\n',str2double(get(handles.edit6,'String')));
    imcal=cell2mat(get(handles.uitable1,'Data'));
    fprintf(mf,'-----------imaging calib:\r\n');
    for(i=1:10)
        fprintf(mf,'%g\t%g\r\n',imcal(i,1),imcal(i,2));
    end
    fprintf(mf,'-----------end imaging calib\r\n');
%    fprintf(mf,'tritium_length:\t%g\r\n',str2double(get(handles.edit7,'String')));
%    fprintf(mf,'tritium_offset:\t%g\r\n',str2double(get(handles.edit8,'String')));

    fprintf(mf,'roi_l:\t%g\r\n',str2double(get(handles.ll,'String')));
    fprintf(mf,'roi_r:\t%g\r\n',str2double(get(handles.rr,'String')));    
    fprintf(mf,'roi_t:\t%g\r\n',str2double(get(handles.tt,'String')));
    fprintf(mf,'roi_b:\t%g\r\n',str2double(get(handles.bb,'String')));    
    fprintf(mf,'ron_l:\t%g\r\n',str2double(get(handles.background_left,'String')));
    fprintf(mf,'ron_r:\t%g\r\n',str2double(get(handles.background_right,'String')));
    fprintf(mf,'ron_t:\t%g\r\n',str2double(get(handles.background_top,'String')));
    fprintf(mf,'ron_b:\t%g\r\n',str2double(get(handles.background_bottom,'String')));
%    fprintf(mf,'tri_l:\t%g\r\n',str2double(get(handles.tritium_left,'String')));
%    fprintf(mf,'tri_r:\t%g\r\n',str2double(get(handles.tritium_right,'String')));    
    fclose(mf);
   

% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles)
    varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

    [mfile mpath] = uigetfile('*.png','select shot file','d:\\data2');
    openShot(handles,mfile,mpath);

    
% --- Executes during object creation, after setting all properties.
function openShot(handles, mfile, mpath)
    set(handles.edit1,'String',mpath);
    aa=strfind(mfile,'shot');
    cc=mfile(aa(length(aa))+4:aa(length(aa))+7);
    set(handles.text32,'String',mfile(aa(length(aa))+8:length(mfile)));
    set(handles.cshot,'String',cc);
    %dofile(handles, lanex_file, spec_file, log_file, shot_no)
    dofile(handles,strcat(mpath,mfile),strcat(mpath,'shot','cc','_spec.txt'),strcat(mpath,'log.txt'), str2num(cc));


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

    global mstop;
    mstop=0;
    set(handles.pushbutton2,'Enable','off');
    mnextShot=str2num(get(handles.cshot,'String'))+1;
    mpath=get(handles.edit1,'String');
    mnextfile=sprintf('%04d',mnextShot);
    mnextfile=sprintf('%s%s%s%s',mpath,'shot',mnextfile,get(handles.text32,'String'));
    %shao-wei
    %sw=1 ;
    while(mstop==0)
           %shao-wei
            if (exist(mnextfile,'file')==0)%&& sw==1
                mnextShot=mnextShot+1;
            mnextfile=sprintf('%s%s%04d%s',mpath,'shot',mnextShot,get(handles.text32,'String'));
            end    
        if(exist(mnextfile,'file')~=0)
            pause(0.5);
            %dofile(handles, lanex_file, spec_file, log_file, shot_no)
            log_file=strcat(mpath,'log.txt');
            spec_file=sprintf('%s%s%04d%s',mpath,'shot',mnextShot,'_spec.txt');
            dofile(handles,mnextfile,spec_file,log_file,mnextShot);
            set(handles.cshot,'String',mnextShot);
            mnextShot=mnextShot+1;
            mnextfile=sprintf('%s%s%04d%s',mpath,'shot',mnextShot,get(handles.text32,'String'));          
        end
        pause(0.100);
        drawnow();
    end
    set(handles.pushbutton2,'Enable','on');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    global mstop;
    mstop=1;
    
    
function [spec_cal pp]=loadSpecCal(handles)
        mf=fopen(get(handles.edit2,'String'),'r');
        if(mf>0)
            

           %read the spectral calibration file
           a=cell2mat(textscan(mf,'%f%f','HeaderLines',2));
           pp=polyfit(a(:,2),a(:,1),10);
            %first - check redundancies in the table:
           numRedundand=1;
           nc=1;
           na=1;

           while(true)
                spec_cal(nc,2)=a(na,2);
                spec_cal(nc,1)=a(na,1);
                for(jj=na+1:size(a,1))
                    if((a(jj,2)==spec_cal(nc,2)))
                        numRedundand=numRedundand+1;
                        spec_cal(nc,1)=spec_cal(nc,1)+a(jj,1);
                        if(jj<size(a,1))
                            continue;
                        end
                    end
                    spec_cal(nc,1)=spec_cal(nc,1)/numRedundand;
                    numRedundand=1;
                    na=jj;
                    nc=nc+1;
                    break;
                end
                if(na==size(a,1))
                    break;
                end
           end
           
           spec_cal(:,2)=smooth(spec_cal(:,2),21,'sgolay',1);
        else
            spec_cal=[];
        end
        
        
        fclose(mf);
        
function [qp_en qp_ch]=dofile(handles, lanex_file, spec_file, log_file, shot_no)

    [spec_cal pp]=loadSpecCal(handles);
    xl=floor(str2double(get(handles.ll,'String')));
    xr=floor(str2double(get(handles.rr,'String')));
    yt=floor(str2double(get(handles.tt,'String')));
    yb=floor(str2double(get(handles.bb,'String')));

%    tri_l=floor(str2double(get(handles.tritium_left,'String')));
%    tri_r=floor(str2double(get(handles.tritium_right,'String')));
    
%    tri_length=str2double(get(handles.edit7,'String'));
%    tri_off=str2double(get(handles.edit8,'String'));
    
    bg_l=str2double(get(handles.background_left,'String'));
    bg_t=str2double(get(handles.background_top,'String'));
    bg_r=str2double(get(handles.background_right,'String'));
    bg_b=str2double(get(handles.background_bottom,'String'));
    
    charge_calib = str2double(get(handles.edit6,'String'));
    axes(handles.axes1);
    imim=double(imread(lanex_file));
    imim=imim./16;
    imim2=double(imim);
    %scale overall
    mmax=max(max(imim2));
    mmin=min(min(imim2));
    imim2=(imim2-mmin)/(mmax-mmin)*64;


    if((xl~=0)&&(xr~=0)&&(yt~=0)&&(yb~=0))    
        %scale to roi
        mmax=max(max(imim2(yt:yb,xl:xr)));
        mmin=min(min(imim2(yt:yb,xl:xr)));
        imim2(yt:yb,xl:xr)=(imim2(yt:yb,xl:xr)-mmin)/(mmax-mmin)*64;


    end    
%    colormap(jet(256));
    image(imim2);    
    axes(handles.axes1);
    bg_val=0;
    
    if((xl~=0)&&(xr~=0)&&(yt~=0)&&(yb~=0))
        line([xl-1 xr+1],[yt-1 yt-1],'Color','red');
        line([xl-1 xr+1],[yb+1 yb+1],'Color','red');
        line([xl-1 xl-1],[yt-1 yb+1],'Color','red');
        line([xr+1 xr+1],[yt-1 yb+1],'Color','red');
        
        mspec=zeros(xr-xl+1,2,'double');
        for(xx=xl:1:xr)
            for(yy=yt:1:yb)
                
                mspec(xx-xl+1,2)=mspec(xx-xl+1,2)+double(imim(yy,xx,1))*charge_calib;
            end
        end
        %if defined - subtract background:
        if((bg_l~=0)&&(bg_t~=0)&&(bg_r~=0)&&(bg_b~=0))
            
            line([bg_l-1 bg_r+1],[bg_t-1 bg_t-1],'Color',[0.8 0.8 0.8]);
            line([bg_l-1 bg_r+1],[bg_b+1 bg_b+1],'Color',[0.8 0.8 0.8]);
            line([bg_l-1 bg_l-1],[bg_t-1 bg_b+1],'Color',[0.8 0.8 0.8]);
            line([bg_r+1 bg_r+1],[bg_t-1 bg_b+1],'Color',[0.8 0.8 0.8]);
            
            bg_val=0;
            
            for(xx=round(bg_l):1:round(bg_r))
                for(yy=round(bg_t):1:round(bg_b))
                    
                    bg_val=bg_val+double(imim(yy,xx,1))/(bg_r-bg_l)/(bg_b-bg_t);
                    
                end
            end
            bg_val=bg_val*(yb-yt)*charge_calib;
            mspec(:,2)=mspec(:,2)-bg_val;
           
            
        end
        
        axes(handles.axes2);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%!!!!!!!!!!!!!!calibrate the spectrum
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        if(~isempty(spec_cal))
           
           
           quasipeak_st=-1313;
           quasipeak_en=-1313;
           quasipeak_charge=0;
           quasipeak_charge2=0;
           

           %ppder=polyder(pp);
           %now - scale the x-axis (from the table)
           xcal=cell2mat(get(handles.uitable1,'Data'));
           %here the first coloumn is the offset int meters, the second -
           %offset in pixels
           pp_x=polyfit(xcal(:,2),xcal(:,1),4);
           ppder_x=polyder(pp_x);
           
           
            %check whether roi is inside the measured region;
            if(polyval(pp_x,xr)<min(spec_cal(:,2)))
                msgbox('right side of roi outside spectrum calibration! please redefine!');
                return;
            end
            if(polyval(pp_x,xl)>max(spec_cal(:,2)))
                msgbox('left side of roi outside spectrum calibration! please redefine!');
                return;
            end
           
           
           for(xx=xl:1:xr)
%               xxx=-((xx-806)*0.01/(832-806)+0.14);
%               mspec2(xx-xl+1,1)= polyval(pp,xxx);
%               mspec2(xx-xl+1,2)=mspec(xx-xl+1,2)/polyval(ppder,xxx)/0.01*(832-806);
               cx_meters=polyval(pp_x,xx);
               %position derivative in m/pix
               d_cx_meters=-polyval(ppder_x,xx);
%               d_cx_meters=-(polyval(pp_x,xx+1,[],mu_x)-polyval(pp_x,xx-1,[],mu_x))/2;
               %x-value of the point - energy in eV
               ce_ev=linterp2(spec_cal(:,2),spec_cal(:,1),cx_meters);
               %energy derivative in eV/m
%               d_ce_ev_old=polyval(ppder,cx_meters);
               d_ce_ev=(linterp2(spec_cal(:,2),spec_cal(:,1),cx_meters+d_cx_meters/2)-linterp2(spec_cal(:,2),spec_cal(:,1),cx_meters-d_cx_meters/2))/d_cx_meters;
               %finaly save the values to the array:
               %energy: 
               mspec(xx-xl+1,1)= ce_ev;
               %dc/de: [q/pix]/[m/pix]/[ev/m]=[q/ev]
               mspec(xx-xl+1,2)=mspec(xx-xl+1,2)/d_cx_meters/d_ce_ev;
               
           end
           for(xx=1:length(mspec(:,2))-1)
               quasipeak_charge=quasipeak_charge+mspec(xx,2)*abs(mspec(xx,1)-mspec(xx+1,1));
%               quasipeak_charge_old=quasipeak_charge2+mspec2(xx,2)*abs(mspec2(xx,1)-mspec2(xx+1,1));
           end

           quasipeak_val=max(mspec(:,2));
           for(xx=1:length(mspec(:,1)))
               if((mspec(xx,2)>quasipeak_val/10)&&(quasipeak_st==-1313))
                   quasipeak_st=xx;
               elseif((mspec(xx,2)<quasipeak_val/10)&&(quasipeak_st~=-1313))
                   quasipeak_en=xx;
               end
            end
           if(quasipeak_st==-1313)
               quasipeak_st=1;
           end
           if(quasipeak_en==-1313)
               quasipeak_en=length(mspec(:,1));
           end
           
           quasipeak_pos=quasipeak_st;
           

           quasipeak_pos_mev=0.000001*mspec(quasipeak_st,1);
           quasipeak_spread=100*(mspec(quasipeak_st,1)-mspec(quasipeak_en,1))/mspec(quasipeak_pos,1);
           
           plot(mspec(:,1),mspec(:,2),'--rs','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','g','MarkerSize',2);
           mmax=max(mspec(:,2));
           if(mmax>0)
               ylim([0 max(mspec(:,2))]);
           else
               ylim([0 1]);
           end
           xlim([min(mspec(:,1)) max(mspec(:,1))]);
            title('Spectrum');
            ylabel('dq/dE [pC/eV]');
            xlabel('Energy[eV]');
           


           set(handles.edit3,'String',num2str(quasipeak_pos_mev));
           set(handles.edit4,'String',num2str(quasipeak_spread));
           set(handles.edit5,'String',num2str(quasipeak_charge));
           qp_en=quasipeak_pos_mev;
           qp_ch=quasipeak_charge;
           
           if(get(handles.checkbox2,'Value')==get(handles.checkbox2,'Max'))
                
               if(exist(log_file,'file')==0)
                    fid = fopen(log_file,'w');
                    mstr='Log ver 0.3';
                    fprintf(fid,'%s\r\n',mstr);
         %           mstr='Peak pos[MeV]\tFWHM Spread[%]\tCharge[pC]\tGas Pressure[mBar]\tGas Cell Length[mm]\tGas Cell pos[mm]\tDazzler\tComment\r\n';
                    fprintf(fid,'%s\t%s\t%s\t%s\r\n','Shot #','Peak pos[MeV]','FWHM Spread[%]','Charge[pC]');
                    fclose(fid);
               end
               fid = fopen(log_file,'a+');
               fseek(fid,0,'bof');
               mstr=fscanf(fid,'%s',3);
               if(strcmp(mstr,'Logver0.3')==0)
                   if(strcmp(questdlg('Found an existing log, but of wrong format.. REWRITE?','QUESTION!','Jawohl','Njiet','Njiet'),'Jawohl')~=0)
                       fclose(fid);
                        fid = fopen(log_file,'w');
                        mstr='Log ver 0.3';
                        fprintf(fid,'%s\r\n',mstr);
         %           mstr='Peak pos[MeV]\tFWHM Spread[%]\tCharge[pC]\tGas Pressure[mBar]\tGas Cell Length[mm]\tGas Cell pos[mm]\tDazzler\tComment\r\n';
                        fprintf(fid,'%s\t%s\t%s\t%s\r\n','Shot #','Peak pos[MeV]','FWHM Spread[%]','Charge[pC]');

                   else
                       fclose(fid);
                       set(handles.checkbox2,'Value',get(handles.checkbox2,'Value','Min'));
                       return;
                   end
               end
               fseek(fid,0,'eof');
               mstr=sprintf('%04d\t%f\t%f\t%f\r\n',shot_no,quasipeak_pos_mev,quasipeak_spread,quasipeak_charge);
               fprintf(fid,'%s',mstr);
               fclose(fid);
           end  
               %save spectrum
           if(get(handles.checkbox3,'Value')==get(handles.checkbox3,'Max'))
                   
                fid = fopen(spec_file,'w'); 
                fprintf(fid,'%s\t%s\r\n','Energy[MeV]','dq/dE[pC/MeV]');
                for(ii=1:size(mspec,1))
                    fprintf(fid,'%f\t%f\r\n',mspec(ii,1)*(1e-6),mspec(ii,2)*(1e6));
                end
                fclose(fid);
%                   dlmwrite(mstr,mspec,'-append','delimiter','\t','newline','pc');
                   
           end
           
           
        else
            qp_en=0;
            qp_ch=0;
            if(mf~=-1)
                fclose(mf);
            end
            get(handles.edit2,'String')
            plot(mspec(:,2));
        end
        
        
        fclose('all');
    end
function yy = linterp2(x,y,xx)
%LINTERP Linear interpolation.
%
% YY = LINTERP(X,Y,XX) does a linear interpolation for the given
%      data:
%
%           y: given Y-Axis data
%           x: given X-Axis data
%          xx: points on X-Axis to be interpolated
%
%      output:
%
%          yy: interpolated values at points "xx"

% R. Y. Chiang & M. G. Safonov 9/18/1988
% Copyright 1988-2004 The MathWorks, Inc.
%       $Revision: 1.1.6.1 $
% All Rights Reserved.
% ------------------------------------------------------------------

nx = max(size(x));
nxx = max(size(xx));
if xx(1) < x(1)
   error('You must have min(x) <= min(xx)..')
end
if xx(nxx) > x(nx)
   error('You must have max(xx) <= max(x)..')
end
%
j = 2;
for i = 1:nxx
   while x(j) < xx(i)
         j = j+1;
   end
   alfa = (xx(i)-x(j-1))/(x(j)-x(j-1));
   yy(i) = y(j-1)+alfa*(y(j)-y(j-1));
end
%
% ------ End of INTERP.M % RYC/MGS %    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
    
    set(handles.text3,'FontSize',14);
    set(handles.text3,'FontWeight','bold');

    set(handles.text3,'String','Click top-left corner..');
    [x y]=ginput(1);
    set(handles.ll,'String',num2str(x));
    set(handles.tt,'String',num2str(y));

    set(handles.text3,'String','Click bottom-right corner..');
    [x y]=ginput(1);
    set(handles.rr,'String',num2str(x));
    set(handles.bb,'String',num2str(y));

    set(handles.text3,'FontSize',8);
    set(handles.text3,'FontWeight','normal');
    set(handles.text3,'String','Search rectangle:');

    mnextfile=strcat('shot',sprintf('%04d',str2num(get(handles.cshot,'String'))),get(handles.text32,'String'));
    openShot(handles,mnextfile,get(handles.edit1,'String'));
%    dofile(handles,get(handles.edit1,'String'),mnextfile);


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)



function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    global mscriptpath;

    [mfile mpath] = uigetfile('*.*','choose spectrum calibration file','c:\\');
    if(mfile==0)
        return;
    end
    set(handles.edit2, 'String', strcat(mpath,mfile));

    mf=fopen(strcat(mscriptpath,'speccalibpath.txt'),'w');
    fprintf(mf,'%c',strcat(mpath,mfile));
    fclose(mf);




function edit3_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit5_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit6_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit7_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit8_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in pushbutton4.
function pushbutton7_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton6.
function pushbutton8_Callback(hObject, eventdata, handles)



function edit9_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit10_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit11_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit_gas_pressure_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_gas_pressure_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit_gas_cell_len_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_gas_cell_len_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit_gas_cell_pos_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_gas_cell_pos_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit_comment_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.

function edit_comment_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function text32_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)

    set(handles.text33,'FontSize',14);
    set(handles.text33,'FontWeight','bold');

    set(handles.text33,'String','Click top-left corner..');
    [x y]=ginput(1);
    set(handles.background_left,'String',num2str(x));
    set(handles.background_top,'String',num2str(y));

    set(handles.text33,'String','Click bottom-right corner..');
    [x y]=ginput(1);
    set(handles.background_right,'String',num2str(x));
    set(handles.background_bottom,'String',num2str(y));

    set(handles.text33,'FontSize',8);
    set(handles.text33,'FontWeight','normal');
    set(handles.text33,'String','Background sample:');

    mnextfile=strcat('shot',sprintf('%04d',str2num(get(handles.cshot,'String'))),get(handles.text32,'String'));
    %dofile(handles,get(handles.edit1,'String'),mnextfile);
    openShot(handles, mnextfile,get(handles.edit1,'String'));


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3





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


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- OPEN CAM
function pushbutton11_Callback(hObject, eventdata, handles)

    set(handles.pushbutton11,'Enable','off');
    drawnow
    openCam(hObject, eventdata,handles);
    set(handles.pushbutton11,'Enable','on');


% --- CLOSE CAM
function pushbutton12_Callback(hObject, eventdata, handles)

    set(handles.pushbutton12,'Enable','off');
    drawnow;
    closeCam(hObject, eventdata,handles);
    set(handles.pushbutton12,'Enable','on');



% --- GRAB SW TRIGGERED
function pushbutton13_Callback(hObject, eventdata, handles)

    set(handles.pushbutton13,'Enable','off');
    drawnow;
    mimg=grabSingle(hObject, eventdata,handles,1);
    figure(2121);
    %axes(handles.axes1);
    imagesc(mimg);
    set(handles.pushbutton13,'Enable','on');


% --- GRAB HW TRIGGERED
function pushbutton14_Callback(hObject, eventdata, handles)

    set(handles.pushbutton14,'Enable','off');
    drawnow;
    mimg=grabSingle(hObject, eventdata,handles,0);
    if(isempty(find(mimg~=1,1)))
        axes(handles.axes1);
        imagesc(mimg);
        text(size(mimage,1)/2,size(mimage,2)/2,'no trigger?!?!','FontSize',18,'Color',[rand rand rand]);
    else
    
        figure(2121);
        %axes(handles.axes1);
        imagesc(mimg);
    end
    set(handles.pushbutton14,'Enable','on');

%%------------------------------------------------------
% --- OPEN CAMERA
    
function openCam(hObject, eventdata,handles)
    if not(libisloaded('PCO_PF_SDK'))
         loadlibrary('pccamvb',@mpccamvb,'alias','PCO_PF_SDK');
    end



    % default parameters for camera setmode
    handles.hbin = 0; % horizontal binning 1
    handles.vbin = 0; % vertical binning 1
    handles.exposure = 100; % exposure time in ms
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
    board_number=1;


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
        loadlibrary('pcocnv',@mpcocnv,'alias','PCO_CNV_SDK');
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

    % Update handles structure
    guidata(hObject, handles);


   
function closeCam(hObject,eventdata,handles)

    if(libisloaded('PCO_PF_SDK'))
        error_code = pfSTOP_CAMERA(handles.board_handle);
        if error_code ~= 0
             msgbox('....quit_Callback: pfSTOP_CAMERA error!')
        end

        error_code = pfUNMAP_BUFFER(handles.board_handle,handles.bufnr1);
        if error_code ~= 0
            msgbox('....unmap buffer error!')
        end
        error_code = pfFREE_BUFFER(handles.board_handle,handles.bufnr1);
        if error_code ~= 0
            msgbox('....unmap buffer error!')
        end

        error_code = pfUNMAP_BUFFER(handles.board_handle,handles.bufnr);
        if error_code ~= 0
            msgbox('....unmap buffer error!')
        end
        error_code = pfFREE_BUFFER(handles.board_handle,handles.bufnr);
        if error_code ~= 0
            msgbox('....unmap buffer error!')
        end
        error_code = pfCLOSEBOARD(handles.board_handle);
        if error_code ~= 0
            msgbox('....disconnected error!');
        end

        if (libisloaded('PCO_PF_SDK'))
            unloadlibrary('PCO_PF_SDK');
        end

        if (libisloaded('PCO_CNV_SDK'))
    
            calllib('PCO_CNV_SDK','DELETE_COLORLUT_EX',handles.colorlutptr);
            calllib('PCO_CNV_SDK','DELETE_BWLUT_EX',handles.bwlutptr);
    
            unloadlibrary('PCO_CNV_SDK');
        end
    end

  

function mimage=grabSingle(hObject, eventdata, handles, swtriggered)
    dispon=0;
    mimage=ones(handles.image_height,handles.image_width);
    if(libisloaded('PCO_PF_SDK')==0)
        msgbox('Please first open the cam!');
        return
    end
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
           % msgbox(['WAIT_FOR_BUFFER failed. Error is ',int2str(error_code)]);
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


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
closeCam(hObject, eventdata,handles);
delete(hObject);



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- START FTP DAEMON
function pushbutton15_Callback(hObject, eventdata, handles)

    global mstop;
    mstop=0;
    set(handles.pushbutton15,'Enable','off');
    
    tt=ftp(get(handles.edit17,'String'));
    if(strcmp(class(tt),'ftp')==0)
        msgbox('Could not establish ftp connection to the server...');
        mstop=1;
    end
    
    %first - delete old flags (if any)
    ftpdirlist=dir(tt);
    for(i=1:size(ftpdirlist,1))
        if(strcmp(ftpdirlist(i).name,'raphaella_prepare'))
            delete(tt,ftpdirlist(i).name);
        end
    end
    
    prctime=0;
    
    %enter main loop
    while(mstop==0)
        
        ftpdirlist=dir(tt);
        for(i=1:size(ftpdirlist,1))
            if(strcmp(ftpdirlist(i).name,'raphaella_prepare'))
                tic
                pause(0.100);
                
                ff=char(mget(tt,ftpdirlist(i).name));
                aa=dlmread(ff);
                delete(tt,ftpdirlist(i).name);
                
                %in aa first line - date, second - run number, third - shot number
                set(handles.cshot,'String',aa(3));
                set(handles.text46,'String',aa(1));
                set(handles.text44,'String',aa(2));
                
                %first - check whether the date dir exists. if not -
                %create:
                mpath=strcat(get(handles.edit18,'String'),num2str(aa(1),'%06d'),'\');
                if(exist(mpath,'dir')==0)
                    mkdir(mpath);
                end

                %second - check whether the run dir exists. if not - create
                pathWithRun=sprintf('%s%s%03d%s',mpath,'Run',aa(2),'\');
                if(exist(pathWithRun,'dir')==0)
                    mkdir(pathWithRun);
                end
                set(handles.edit1,'String',pathWithRun);
                %construct file names for lanes, log and spectrum:
                lanex_file=sprintf('%s%s%04d%s',pathWithRun,'shot',aa(3),'_raphaella.png');
                spec_file=sprintf('%s%s%04d%s',pathWithRun,'shot',aa(3),'_raphaella_spec.txt');
                log_file=sprintf('%s%s%',pathWithRun,'raphaella_log.txt');
                
                %now - acquire image!
                mimage=uint16(grabSingle(hObject, eventdata, handles,0));
                if(isempty(find(mimage~=1,1))==1)
                    axes(handles.axes1);
                    image(mimage);
                    text(size(mimage,1)/2,size(mimage,2)/2,'no trigger?!?!','FontSize',18,'Color',[rand rand rand]);
                else
                    mimage=mimage*16;
                    imwrite(mimage,lanex_file,'png','bitdepth',16);
                
                    %process spectrum picture:
                    [qp_en qp_ch]=dofile(handles,lanex_file,spec_file,log_file,aa(3));
                
                    %save results at the server
                    if(get(handles.checkbox6,'Value')==1)
                        mkdir(tt,sprintf('%06d',aa(1)));
                        mkdir(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
                        cd(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
                
                        mput(tt,lanex_file);
                        if(get(handles.checkbox3,'Value')==1)
                            mput(tt,spec_file);
                        end
                        if(get(handles.checkbox2,'Value')==1)
                            mput(tt,log_file);
                        end
                
                        cd(tt,'/');
                    end
                
                    %make a report file for the server:
                    fid=fopen(strcat(mpath,'raphaella_report'),'w');
                    %run and shot:
                    fprintf(fid,'%d\r\n',aa(1));
                    fprintf(fid,'%d\r\n',aa(2));
                    %energy and charge values:
                    fprintf(fid,'%f\r\n',qp_en);
                    fprintf(fid,'%f\r\n',qp_ch);
                    %paths for files:
                    fprintf(fid,'%06d\\%s%03d%s',aa(1),'Run',aa(2),lanex_file);
                    if(get(handles.checkbox3,'Value')==1)
                        fprintf(fid,'%06d\\%s%03d%s',aa(1),'Run',aa(2),spec_file);
                    end
                    if(get(handles.checkbox2,'Value')==1)
                        fprintf(fid,'%06d\\%s%03d%s',aa(1),'Run',aa(2),log_file); 
                    end
                    fclose(fid);
                    mput(tt,strcat(mpath,'raphaella_report'));
                end
                prctime=toc;
                break;
                
            end
            
        end
        
        %show that we're still alive:
        if(strcmp(get(handles.text41,'String'),'O')==0)
            set(handles.text41,'String','O');
        else
            set(handles.text41,'String','X');
        end
        set(handles.text51,'String',sprintf('%3.1f',prctime));
        drawnow;
        pause(0.5);
    end
    
    close(tt);
    
    set(handles.pushbutton15,'Enable','on');
    


% --- STOP FTP DAEMON
function pushbutton16_Callback(hObject, eventdata, handles)

    global mstop;
    mstop=1;


function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mdir=uigetdir('d:\');
    if(mdir~=0)
        set(handles.edit18,'String',strcat(mdir,'\'));
    end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%SHOW SPATIAL FIT:
% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
            xl=str2double(get(handles.ll,'String'));
            xr=str2double(get(handles.rr,'String'));
            xx_mesh=xl:(xr-xl)/10:xr;
           xcal=cell2mat(get(handles.uitable1,'Data'));
           %here the first coloumn is the offset int meters, the second -
           %offset in pixels
           pp_x=polyfit(xcal(:,2),xcal(:,1),4);

           figure(2121);
           set(gcf,'Name','Spatial fit');
           plot(xcal(:,2),xcal(:,1),'-or',xx_mesh,polyval(pp_x,xx_mesh),'-dk');
           legend('Table data','fit of along roi');


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
