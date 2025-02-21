close all
clear all
% close all com ports
if ~isempty(instrfind)
    fclose(instrfind);
end

% configure new serial connection
% to connect motorbox
mc = serial('/dev/ttyS1',...
    'BaudRate',115200,...
    'Terminator','CR/LF',...
    'TimeOut',2);

% open comport
fopen(mc);
m4 = initMotor(mc,4);
resetES(mc,m4);
m4 = initMotor(mc,4);
%m2 = initMotor(mc,7);

%disable endswitch for normal drive
%llcmd(mc,4,'l17442');
llcmd(mc,4,'l16929');


%reference drive - gohome
%m4=moveMrel(mc,m4,5000);
%llcmd(mc,4,'p4');
%m4=moveMrel(mc,m4,-100000);
%llcmd(mc,4,'p1');

%motorOn(mc,m1);
%motorOn(mc,m2);
fprintf(1,'init ready');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    flag_name='rottenTomato';    
    mpath='/home/edaq/kostya/';
    tt=ftp('130.183.92.172');
    
    if(strcmp(class(tt),'ftp')==0)
        fprintf(1,'Could not establish ftp connection to the server...');
        mstop=1;
    end
    stillAlive=0;
    hh=waitbar(stillAlive,'stillAlive');
    while(1)
        try
            ftpdirlist=dir(tt);
        catch exception
            close(tt);
            tt=ftp('130.183.92.172');
            continue;
        end
        if(numel(ftpdirlist)==0)
            close(tt);
            tt=ftp('130.183.92.172');
            continue;
        end
        for(i=1:size(ftpdirlist,1))
            if(strcmp(ftpdirlist(i).name,strcat(flag_name,'_prepare')))
                fprintf(1,'prepare\r\n');
                
                %get actual position and report it
                pause(0.100);
                
                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        ff=char(mget(tt,ftpdirlist(i).name));
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end
                aa=dlmread(ff)
                

                

                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        delete(tt,ftpdirlist(i).name);
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end
                
                
                %in aa first line - date, second - run number, third - shot number
                fprintf(1,'date: %d\trun: %d\tshot: %d\r\n',aa(1),aa(2),aa(3));
                %set(handles.edit14,'String',aa(1));
                %set(handles.edit15,'String',aa(2));
                %set(handles.edit16,'String',aa(3));                
                
                %first - check whether the date dir exists. if not -
                %create:
                mpathWithDate=strcat(mpath,num2str(aa(1),'%06d'),'/');
                if(exist(mpathWithDate,'dir')==0)
                    mkdir(mpathWithDate);
                end

                %second - check whether the run dir exists. if not - create
                pathWithRun=sprintf('%s%s%03d%s',mpathWithDate,'Run',aa(2),'/');
                if(exist(pathWithRun,'dir')==0)
                    mkdir(pathWithRun);
                end
                
                %construct file names for lanes, log and spectrum:


                log_file=sprintf('%s%s%s',pathWithRun,flag_name,'_log.txt');
                report_file=sprintf('%s%s%s',pathWithRun,flag_name,'_report');
                %now - acquire image!
                fid=fopen(log_file,'a');
                fseek(fid,0,'eof');
                %process spectrum picture:
%                mpos=getMPosition(mc,m4);
                mtr=0;
                while mtr<100
                    [mpos status]  = llget(mc,4,'C');
                    if(status==1 && isempty(mpos)==0)
                        break;
                    end
                    mtr=mtr+1;
                    pause(0.01);
                end
                if(status==0)
                    fprintf(1,'SERIOUS ERROR!\r\n');
                    return;
                end
                
                
                
                fprintf(1,'current pos: %d',mpos);
                fprintf(fid,'%d\t%d\r\n',aa(3),mpos);
                fclose(fid);

                fid=fopen(report_file,'w');
                %process spectrum picture:
                mpos=getMPosition(mc,m4);
                fprintf(fid,'%d\t%d\r\n',aa(3),mpos);
                fclose(fid);
                
                %save results at the server
                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        mkdir(tt,sprintf('%06d',aa(1)));
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end
                


                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        mkdir(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end


                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        cd(tt,sprintf('%06d\\%s%03d',aa(1),'Run',aa(2)));
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end
                

                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        mput(tt,log_file);
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end
                
                

                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        cd(tt,'/');
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end


                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        mput(tt,report_file);
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end

                
                break;
            elseif(strcmp(ftpdirlist(i).name,strcat(flag_name,'_doit')))
                
                %move the stage:
                pause(0.100);
                

                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        ff=char(mget(tt,ftpdirlist(i).name));
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end
                
                aa=dlmread(ff);
                

                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        delete(tt,ftpdirlist(i).name);
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end

                                
                %set(handles.edit3,'String',aa(1));
                %m4=moveMrel(mc,m4,aa(1));
%%%%%%%
                if aa(1) < 0
                    llcmd(mc,4,'d0');
                else
                    llcmd(mc,4,'d1');
                end
        
                llcmd(mc,4,strcat('s',num2str(abs(aa(1)))));
                llcmd(mc,4,'A');
    
                fprintf('move motor %i', 4);
                mtr=0;
                while llget(mc,4,'$') == 160
    
                    % wait
                    pause(0.01);
    
                    % statu update
                    if(mtr>10000)
                        fprintf(1,'CANNOT REPOSITION!\r\n');
                        return;
                    end
                    mtr=mtr+1;
                end

%%%%%%%%%%%%
                
                %first - check whether the date dir exists. if not -
                %create:
                
                if(mpath(length(mpath))~='/')
                    mpath=strcat(mpath,'/');
                end
                mpathWithDate=strcat(mpath,num2str(aa(1),'%06d'),'/');
                if(exist(mpathWithDate,'dir')==0)
                    mkdir(mpathWithDate);
                end

                
                %construct file names for lanes, log and spectrum:


                rep_file=sprintf('%s%s%s',mpath,flag_name,'_done');
                
                %now - acquire image!
                fid=fopen(rep_file,'w');
                %process spectrum picture:
                %mpos=getMPosition(mc,m4);
                mtr=0;
                while mtr<200
                    [mpos status]  = llget(mc,4,'C');
                    if(status==1 && isempty(mpos)==0)
                        break;
                    end
                    mtr=mtr+1;
                    pause(0.01);
                end
                if(status==0)
                    fprintf(1,'SERIOUS ERROR!\r\n');
                    return;
                end
                
                fprintf(1,'curr pos: %d\r\n',mpos);
                fprintf (fid,'%d',mpos);
                fclose(fid);
                
                

                mexc=1;
                while(mexc)
                    try
                        mexc=0;
                        mput(tt,rep_file);
                    catch exc
                        mexc=1;
                        close(tt);
                        tt=ftp('130.183.92.172');
                    end
                end
                
                break;

            end
            
        end
        
        %show that we're still alive:
        stillAlive=stillAlive+0.1;
        if(stillAlive>1)
            stillAlive=0;
        end
        waitbar(stillAlive,hh);
        
        drawnow;
        pause(0.5);
    end
    
    close(tt);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fclose(mc);
