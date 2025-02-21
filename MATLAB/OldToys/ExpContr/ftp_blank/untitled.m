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
    
    while(mstop==0)
        
        ftpdirlist=dir(tt);
        for(i=1:size(ftpdirlist,1))
            if(strcmp(ftpdirlist(i).name,'espec_prepare'))
                pause(0.100);
                
                ff=char(mget(tt,ftpdirlist(i).name));
                aa=dlmread(ff);
                delete(tt,ftpdirlist(i).name);
                
                %in aa first line - date, second - run number, third - shot number
                set(handles.cshot,'String',aa(3));
                
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
                
                %construct file names for lanes, log and spectrum:
                lanex_file=sprintf('%s%s%04d%s',pathWithRun,'shot',aa(3),'_lanex.png');
                spec_file=sprintf('%s%s%04d%s',pathWithRun,'shot',aa(3),'_spec.txt');
                log_file=sprintf('%s%s%',pathWithRun,'log.txt');
                
                %now - acquire image!
                mimage=uint16(grabSingle(hObject, eventdata, handles,0));
                mimage=mimage*16;
                imwrite(mimage,lanex_file,'png','bitdepth',16);
                
                %process spectrum picture:
                [qp_en qp_ch]=dofile(handles,lanex_file,spec_file,log_file,aa(3));
                
                %save results at the server
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
                
                %make a report file for the server:
                fid=fopen(strcat(mpath,'espec_report'),'w');
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
                mput(tt,strcat(mpath,'espec_report'));
                
                break;
            end
        end
        
        %show that we're still alive:
        if(strcmp(get(handles.text41,'String'),'O')==0)
            set(handles.text41,'String','O');
        else
            set(handles.text41,'String','X');
        end
        
        drawnow;
        pause(0.5);
    end
    
    close(tt);
    
    set(handles.pushbutton15,'Enable','on');
    


% --- STOP FTP DAEMON
function pushbutton16_Callback(hObject, eventdata, handles)

    global mstop;
    mstop=1;

