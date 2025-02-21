function e_master
clear all
clc
global mdate;
global mrun;
global mshot
global tt;
global ftp_addr;

ftp_addr='130.183.92.172';

mdate='110918';
mrun=6;

open_ftp_connection(ftp_addr);  %connect to ftp server


%%%%justShoot(numshots) - just shoot numshots times
justShoot(3);


%%%%scanIt() - scan something... under developement
%scanIt();
%%%%%%%%%tomato(nshots, threshold,numshots_av);
%tomato(3600,8e9,1);

close(tt);    %close ftp connection
fprintf(1,'!!!!!!!!!!!!!!!!!!!!!!!!DONE!!!!!!!!!!!!!!!!!!!!!!!!\n');


function justShoot(numshots)
    global mshot;
    global mrun;
    global tt;
    
    %%%%%% check whether the run is still the same - then continue shot
    %%%%%% number incrementation
    aa=dlmread('c:\\app_junk\\shotco');
    if(aa(1)~=mrun)
        first_shot_no=0;
    else
        first_shot_no=aa(2)+1;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %first_shot_no=1;
    %numshots=300;
    
    h=waitbar(0,'justShooting..CLOSE THIS WINDOW TO STOP! NO CTRL-C!');
    
    for mshot=first_shot_no:first_shot_no+numshots
        
        mshot
        writeflag('andorra_prepare');     %xrayspec spectrometer
        %writeflag('spectrometer_prepare');     %ocean optics spectrometer
        %writeflag('edaq');     %ocean optics spectrometer
        %writeflag('espec_prepare');            %specie
        %writeflag('zed_prepare');              %z-position (log current pos)
        %writeflag('daisy_prepare');            %dazzler orders (log current)
        %writeflag('epo_prepare');              %electron pointing
        %writeflag('grenouille_prepare');       %grenouille
        %writeflag('oszi_prepare');             %oscilloscope
        %writeflag('arm_spec.txt');      %avantes spectrometer for optical THZ
        %writeflag('ebljied_prepare');          %ebljied
        writeflag('raphaella_prepare');        %raphaella (electron spectrometer)
        %writeflag('tapedrive_prepare');
        %writeflag('rottenBljiedTomato_doit');
        drawnow;
        pause(5);

        %check for interlocks before shot:
        if(checkInterlocks()==0)
            break;
        end
        
        writeflag('shooter_doit');             %SHOOOOOT NOOOOOW!!
        pause(5);
        drawnow;
        
        %remember current shot incase the execution will be interrupted
        dlmwrite('c:\\app_junk\\shotco',[mrun mshot]);
        
        
        %%%%%%%%%% stop shooting if the waitbar window is closed
        if(ishandle(h)==1)
            waitbar((mshot-first_shot_no)/numshots,h);
        else
            break;
        end
        %%%%%%%%%%%%%%%%%%%%
        
    end
    %%%%close waitbar window
    if(ishandle(h)==1)
        close(h);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    


function scanIt()

    global mshot;
    global tt;
    
    
    nshots_stat=10;
    d2_min=26600;
    d2_max=30600;
    d2_steps=5;
    zed_min=50000;
    zed_max=50000;
    zed_steps=1;
    global zeds;
    global d2s;
    nshot=1;
    for d2=d2_min:(d2_max-d2_min)/d2_steps:d2_max 
        %for zed=zed_min:(zed_max-zed_min)/zed_steps:zed_max 
            for ishot=1:nshots_stat 
                %zeds(nshot)=zed;
                d2s(nshot)=d2;
                nshot=nshot+1;
                %fprintf(1,'%d\t%d\t%d\r\n',nshot,zed,d2);
            end
        %end
    end
    
    %nshots_tot=((d2_steps+1)*(zed_steps+1)*nshots_stat+1);
    nshots_tot=((d2_steps+1)*nshots_stat+1);
    shot_seq=randperm(nshots_tot-1);

    h=waitbar(0,'process');
    tic;
    for ii=1:nshots_tot-1
        

        mshot=ii;
    
        %%% change some hardware section --------------------%%%
        
        %zed_set(zeds(shot_seq(ii)));
        daisy_set(d2s(shot_seq(ii)),65000,-4000000);
        %fprintf(1,'shot %d of %d; d2=%d; zed=%d\r\n',ii,nshots_tot,d2s(shot_seq(ii)),zeds(shot_seq(ii)));
        fprintf(1,'shot %d of %d; d2=%d;\r\n',ii,nshots_tot,d2s(shot_seq(ii)));
        %if(~wait_for('zed_done',100))
            %fprintf(1,'WARNING: ZED NOT RESPONDING!');
        %end
        if(~wait_for('daisy_done',100))
            fprintf(1,'WARNING: DAISY NOT RESPONDING!');
        end
        t=toc;
        
        if(t<4)
            pause(4-t);
        end
        
        tic
        writeflag('edaq');     %ocean optics spectrometer
        %writeflag('spectrometer_prepare'); 
        %writeflag('espec_prepare');
        %writeflag('zed_prepare');
        writeflag('daisy_prepare');
        %writeflag('epo_prepare');
        writeflag('grenouille_prepare');
        %writeflag('oszi_prepare');
        %writeflag('THZ_opt_spec_prepare');
        %writeflag('ebljied_prepare');
        writeflag('raphaella_prepare');
        %writeflag('raphaella_prepare');
        t=toc;
        if(t<4)
            pause(4-t);
        end
    %    
        writeflag('shooter_doit');
        
        tic;
        drawnow;
        
        %dlmwrite('c:\\app_junk\\shotco',[mrun shotno]);
        waitbar(ii/nshots_tot,h);
    end
    
    close(h);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tomato(tomato_nsteps,bri_thr,shots_per_step)

    global mshot;
    global tt;
    
    
    tomato_step=200;
    %tomato_nsteps=360;
    %bri_thr=7e9;
    %shots_per_step=2;

    h=waitbar(0,'process');
    tic;
    go_further=1;
    mfinished=0;
    mshot=0;
    ii=0;
    cshot=0;
    tStart=tic;
    while(mfinished==0)
    
        

        
    
        %%% change some hardware section --------------------%%%
        
        %zed_set(zeds(shot_seq(ii)));
        
        if(go_further==1)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%% auskommentieren! bljied!
            rottenTomato_set(tomato_step);
        %fprintf(1,'shot %d of %d; d2=%d; zed=%d\r\n',ii,nshots_tot,d2s(shot_seq(ii)),zeds(shot_seq(ii)));
            fprintf(1,'shot %d of %d;\r\n',ii,tomato_nsteps);
%             [succeeded cnts]=wait_for('rottenBljiedTomato_done',100); %rottenBljiedTomato_done
%             if(~succeeded)
%                 fprintf(1,'WARNING: ROTTEN TOMATO NOT RESPONDING!');
%             end
         end
         t=toc;
        
        if(t<3)
            pause(3-t);
        end
        
        tic
        %writeflag('edaq');     %ocean optics spectrometer
        %writeflag('spectrometer_prepare'); 
        %writeflag('espec_prepare');
        %writeflag('zed_prepare');
        %writeflag('daisy_prepare');
        writeflag('rottenBljiedTomato_prepare');
        writeflag('rottenTomato_prepare');
        %writeflag('epo_prepare');
        %writeflag('grenouille_prepare');
        %writeflag('oszi_prepare');
        %writeflag('THZ_opt_spec_prepare');
        %writeflag('ebljied_prepare');
        writeflag('raphaella_prepare');
        %writeflag('raphaella_prepare');
        writeflag('andorra_prepare');
        t=toc;
        if(t<3)
            pause(3-t);
        end
        writeflag('shooter_doit');
        
%         mans='yes';
%         while strcmp(mans,'yes')==1
%             [succeeded cnts]=wait_for('rottenTomato_report',50); 
%             if(~succeeded)
%                 mans=questdlg('no report.. wait again?','ROTTEN TOMATO','yes','no','yes');
%             else
%                 break;
%             end
%                 
%         end


        tic;
        pause(4);
        
        

        drawnow;
        mshot=mshot+1;
        [succeeded cnts]=wait_for('andorra_report',100);
        if(~succeeded)
            fprintf(1,'WARNING: andorra out!');
            go_further=0;
            mshot=mshot-1;
            drawnow;
            continue;
        elseif(cnts(3)<bri_thr)
            go_further=0;
            
            drawnow;
            continue;
        end
        ii=ii+1;
        cshot=cshot+1;
        if(cshot>=shots_per_step)
            go_further=1;
            cshot=0;
        else
            go_further=0;
        end
        
        
        %dlmwrite('c:\\app_junk\\shotco',[mrun shotno]);
        if(ii>tomato_nsteps*shots_per_step)
            fprintf(1,'DONE!!!!!!!!!!!!!!');
            
            break
        end
        waitbar(ii/(tomato_nsteps*shots_per_step),h,sprintf('shot %d of %d. Estimated time left: %f h',ii,tomato_nsteps*shots_per_step, toc(tStart)/3600*tomato_nsteps*shots_per_step/ii));
        
    end
    
    close(h);

function open_ftp_connection(ftp_addr)
    global tt;
    tt=ftp(ftp_addr);
    if(strcmp(class(tt),'ftp')==0)
        error('could not connect to ftp server');
    end
        

function writeflag(flagname)

    global mdate;
    global mrun;
    global mshot;
    global tt;
    mfile=strcat('c:\\app_junk\\',flagname);
    fid = fopen(mfile,'w');
    fprintf(fid,'%s\r\n',mdate);
    fprintf(fid,'%i\r\n',mrun);
    fprintf(fid,'%i\r\n',mshot);
    fclose(fid);
    mput(tt,mfile);

function okay=checkInterlocks()
    
    global tt;
    ftpdirlist=dir(tt);        
    for i=1:size(ftpdirlist,1)
        if(strncmp(ftpdirlist(i).name,'interlock',9))
            mget(tt,ftpdirlist(i).name,'c:\app_junk');
            fid=fopen(strcat('c:\app_junk\',ftpdirlist(i).name));
            msg=fgetl(fid);
            fclose(fid);
            msgbox(msg,strcat('INTERLOCK: ',ftpdirlist(i).name(11:end)));
            okay=0;
            return;
        end
            
    end
    okay=1;
    
    
function zed_set(pos)
    global tt;
        ftpdirlist=dir(tt);        
        for i=1:size(ftpdirlist,1)
            if(strcmp(ftpdirlist(i).name,'zed_done'))
                delete(tt,'zed_done');
            end
            
        end
    
    mfile='c:\app_junk\zed_doit';    
    dlmwrite(mfile,pos);
    mput(tt,mfile);

function daisy_set(d2,d3,d4)
    global tt;
        ftpdirlist=dir(tt);        
        for i=1:size(ftpdirlist,1)
            if(strcmp(ftpdirlist(i).name,'daisy_done'))
                delete(tt,'daisy_done');
            end
            
        end
    
    mfile='c:\app_junk\daisy_doit';    
    dlmwrite(mfile,[d2;d3;d4]);
    mput(tt,mfile);
    
function rottenTomato_set(relPos)
    global tt;
        ftpdirlist=dir(tt);        
        for i=1:size(ftpdirlist,1)
            if(strcmp(ftpdirlist(i).name,'rottenBljiedTomato_done'))
                delete(tt,'rottenBljiedTomato_done');
            end
            
        end
    
    mfile='c:\app_junk\rottenBljiedTomato_doit';    
    dlmwrite(mfile,relPos);
    mput(tt,mfile);
    

 function [succeeded mfileContents]=wait_for(mfile, max_retr)
        
     global tt;
     for nretr=1:max_retr
        ftpdirlist=dir(tt);        
        for i=1:size(ftpdirlist,1)
            if(strcmp(ftpdirlist(i).name,mfile))
                mget(tt,mfile,'c:\app_junk');
                mfileContents=dlmread(strcat('c:\app_junk\',mfile));
                delete(tt,mfile);
                succeeded = true;
                return
            end
            
        end
        pause(0.5);
        drawnow;
     end
    succeeded=false;
    mfileContents=zeros(1);        
      