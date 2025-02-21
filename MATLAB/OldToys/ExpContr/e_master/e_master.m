function e_master
clear all
clc
global mdate;
global mrun;
global mshot;
global tt;
    tt=ftp('130.183.92.172');
    if(strcmp(class(tt),'ftp')==0)
        error('could not connect to ftp server');
    end

%resetShotCo();;
mdate='110119';
mrun=33;
global numshots;
numshots=50;
%scanIt();
justShoot();

close(tt);
fprintf(1,'!!!!!!!!!!!!!!!!!!!!!!!!DONE!!!!!!!!!!!!!!!!!!!!!!!!\n');


function justShoot()
    global mshot;
    global mrun;
    global mdate;
    global numshots;
    global tt;

    aa=dlmread('c:\\app_junk\\shotco');

    if(aa(1)~=mrun)
        shotno=0;
    else
        shotno=aa(2);
    end

    i=0;
    h=waitbar(0,'process');
    for(ii=1:numshots)
        i=i+1
        shotno=shotno+1;
        mshot=shotno
    
        %%% change some hardware section --------------------%%%
    
    %    zed_move(-mod(ii,2)*100000-100000,100);
    
    %    oo_prepare();
    
        ep_prepare();   %raffi's shit (specie)
    %    zed_prepare();
    %    epo_prepare();
        raphaella_prepare();  %e-spectrum ("raphaella")
        ebljied_prepare();  %e-pointing
        edaq_prepare();
        oszi_prepare();
     %   gre_prepare();
        drawnow;
        pause(2);
    %    
    
        shoot();
        pause(2);
        drawnow;
        dlmwrite('c:\\app_junk\\shotco',[mrun shotno]);
        waitbar(i/numshots,h);
    end
    close(h);


function scanIt()

    global mshot;
    global tt;
    
    nshots_stat=2;
    d2_min=28800;
    d2_max=30800;
    d2_steps=5;
    zed_min=-2100000;
    zed_max=-2070000;
    zed_steps=5;
    global zeds;
    global d2s;
    nshot=1;
    for(d2=d2_min:(d2_max-d2_min)/d2_steps:d2_max)
        for(zed=zed_min:(zed_max-zed_min)/zed_steps:zed_max)
            for(ishot=1:nshots_stat)
                zeds(nshot)=zed;
                d2s(nshot)=d2;
                nshot=nshot+1;
                %fprintf(1,'%d\t%d\t%d\r\n',nshot,zed,d2);
            end
        end
    end
    d2_ax=d2_min:(d2_max-d2_min)/d2_steps:d2_max;
    %zed_ax=zed=zed_min:(zed_max-zed_min)/zed_steps:zed_max;
    zed_ax=zed_min:(zed_max-zed_min)/zed_steps:zed_max;
    
    nshots_tot=((d2_steps+1)*(zed_steps+1)*nshots_stat+1);
    shot_seq=randperm(nshots_tot-1);
   %shot_seq=1:nshots_tot;

    h=waitbar(0,'process');
    tic;
    for(ii=1:nshots_tot-1)
        

        mshot=ii;
    
        %%% change some hardware section --------------------%%%
        
        %zed_set(zeds(shot_seq(ii)));
        daisy_set(d2s(shot_seq(ii)),55000,-4300000);
        fprintf(1,'shot %d of %d; d2=%d; zed=%d\r\n',ii,nshots_tot,d2s(shot_seq(ii)),zeds(shot_seq(ii)));
        %if(~wait_for('zed_done',100))
        %    fprintf(1,'WARNING: ZED NOT RESPONDING!');
        %end
        if(~wait_for('daisy_done',100))
            fprintf(1,'WARNING: DAISY NOT RESPONDING!');
        end
        t=toc;
        
        if(t<4)
            pause(4-t);
        end
    %    oo_prepare();
    
       % ep_prepare();   %raffi's shit (specie)
        %zed_prepare();
        daisy_prepare();
        %epo_prepare();
        %raphaella_prepare();  %e-spectrum ("raphaella")
        %ebljied_prepare();  %e-pointing
    %    edaq_prepare();
    %    oszi_prepare();
    %    gre_prepare();
    %    drawnow;
        tic
        do_visualize(d2_ax,zed_ax);
        t=toc;
        if(t<4)
            pause(4-t);
        end
    %    

        %shoot();
        tic;
        drawnow;
        
        %dlmwrite('c:\\app_junk\\shotco',[mrun shotno]);
        waitbar(ii/nshots_tot,h);
    end
    close(tt);
    fprintf(1,'!!!!!!!!!!!!!!!!!!!!!!!!DONE!!!!!!!!!!!!!!!!!!!!!!!!\n');
    close(h);
        
function resetShotCo()
    dlmwrite('c:\\app_junk\\shotco',[0 0]);
    

function writeData(fname)
    global mdate;
    global mrun;
    global mshot;

    
    fid = fopen(fname,'w');
    fprintf(fid,'%s\r\n',mdate);
    fprintf(fid,'%i\r\n',mrun);
    fprintf(fid,'%i\r\n',mshot);
    fclose(fid);
    
function oo_prepare()
    global tt;
    mfile='c:\app_junk\spectrometer_prepare';    
    writeData(mfile);
    mput(tt,mfile);

function zed_prepare()
    global tt;
    mfile='c:\app_junk\zed_prepare';    
    writeData(mfile);
    mput(tt,mfile);

function daisy_prepare()
    global tt;
    mfile='c:\app_junk\daisy_prepare';    
    writeData(mfile);
    mput(tt,mfile);


function epo_prepare()
    global tt;
    mfile='c:\app_junk\epo_prepare';    
    writeData(mfile);
    mput(tt,mfile);
    
function zed_set(pos,max_retr)
    global tt;
        ftpdirlist=dir(tt);        
        for(i=1:size(ftpdirlist,1))
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
        for(i=1:size(ftpdirlist,1))
            if(strcmp(ftpdirlist(i).name,'daisy_done'))
                delete(tt,'daisy_done');
            end
            
        end
    
    mfile='c:\app_junk\daisy_doit';    
    dlmwrite(mfile,[d2;d3;d4]);
    mput(tt,mfile);
    

 function succeeded=wait_for(mfile, max_retr)
        
     global tt;
     for(nretr=1:max_retr)
        ftpdirlist=dir(tt);        
        for(i=1:size(ftpdirlist,1))
            if(strcmp(ftpdirlist(i).name,mfile))
                mget(tt,mfile,'c:\app_junk');
%                aaa=dlmread(strcat('c:\app_junk\',mfile));
%                fprintf(1,'current motor pos: %i',aaa(1));
                delete(tt,mfile);
                succeeded = true;
                return
            end
            
        end
        pause(0.1);
        drawnow;
     end
    succeeded=false;
        
function do_visualize(d2_ax,zed_ax)
     global tt;
    global mdate;
    global mrun;
    global mshot;
     
     mget(tt,sprintf('ftp://130.183.92.172/%6d/Run%3d/%s',mdate,mrun,'raphaella_log.txt'),'c:\app_junk');
     fid = fopen('c:\app_junk\raphaella_log.txt','r');
     raphaella=cell2mat(textscan(fid,'%d\t%f\t%f\t%f\r\n'));
     fclose(fid);

     mget(tt,sprintf('ftp://130.183.92.172/%6d/Run%3d/%s',mdate,mrun,'daisy_log.txt'),'c:\app_junk');
     fid = fopen('c:\app_junk\daisy_log.txt','r');
     daisy=cell2mat(textscan(fid,'%d\t%d\t%d\t%d\r\n'));
     fclose(fid);

     mget(tt,sprintf('ftp://130.183.92.172/%6d/Run%3d/%s',mdate,mrun,'zed_log.txt'),'c:\app_junk');     
     fid = fopen('c:\app_junk\zed_log.txt','r');
     zed=cell2mat(textscan(fid,'%d\t%d\r\n'));
     fclose(fid);

     meas_en=zeros(length(zed_ax),length(d2_ax));
     meas_ch=zeros(length(zed_ax),length(d2_ax));
     
     for(ii=1:length(raphaella(:,1)))
         mshot=raphaella(ii,1);
         cd2=find(daisy(:,1)==mshot,1,'first');
         if(isempty(cd2))
             fprtinf(1,'WARNING: MISSING DAISY SHOTS!');
             continue;
         else
             cd2=daisy(cd2,2);
             cd2=find(d2_ax==cd2,1,'first');
             if(isempty(cd2))
                 fprintf(1,'SOMETHING STRANGE IS HAPPENING: CANNNOT FIND AXIS POINT..');
                 continue;
             end
         end
         czed=find(zed(:,1)==mshot,1,'first');
         if(isempty(czed))
             fprtinf(1,'WARNING: MISSING ZED SHOTS!');
             continue;
         else
             czed=zed(czed,2);
             czed=find(zed_ax==czed,1,'first');
             if(isempty(czed))
                 fprintf(1,'SOMETHING STRANGE IS HAPPENING: CANNNOT FIND AXIS POINT..');
                 continue;
             end
         end
         if((raphaella(ii,2)>meas_en(czed,cd2))&&(raphaella(ii,4)>2))
             meas_en(czed,cd2)=raphaella(ii,2);
         end
         if(raphaella(ii,4)>meas_ch(czed,cd2))
             meas_ch(czed,cd2)=raphaella(ii,4);
         end
         
            
     end

    figure(28);
    imagesc(zed_ax,d2_ax,meas_en);
    xlabel('Z-position int cnts');
    ylabel('D2 values in fs2');
    title('energy cutoff');

    figure(28);
    imagesc(zed_ax,d2_ax,meas_en);
    xlabel('Z-position int cnts');
    ylabel('D2 values in fs2');
    title('max charge');
    
    
    
function edaq_prepare()
    global tt;
    mfile='c:\app_junk\edaq';    
    writeData(mfile);
    mput(tt,mfile);
    
function shoot()
    global tt;
    mfile='c:\app_junk\shooter_doit';
    writeData(mfile);
    mput(tt,mfile);
        
function ep_prepare()
    global tt;
    mfile='c:\app_junk\espec_prepare';    
    writeData(mfile);
    mput(tt,mfile);

function raphaella_prepare()
    global tt;
    mfile='c:\app_junk\raphaella_prepare';    
    writeData(mfile);
    mput(tt,mfile);

function ebljied_prepare()
    global tt;
    mfile='c:\app_junk\ebljied_prepare';    
    writeData(mfile);
    mput(tt,mfile);
    
function gre_prepare()
    global tt;
    mfile='c:\app_junk\grenouille_prepare';    
    writeData(mfile);
    mput(tt,mfile);
      
    
function oszi_prepare()
    global tt;
    mfile='c:\app_junk\oszi_prepare';    
    writeData(mfile);
    mput(tt,mfile);
      