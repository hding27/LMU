function e_master
clear all
clc
global mdate;
global mrun;
global mshot;
global tt;

%resetShotCo();
mdate='111';
mrun=15
numshots=2000;

%aa=dlmread('c:\\app_junk\\shotco');

% if(aa(1)~=mrun)
%     shotno=0;
% else
%     shotno=aa(2);
% end
tt=ftp('130.183.92.172');
if(strcmp(class(tt),'ftp')==0)
    error('could not connect to ftp server');
end



shotno=0;
i=0;
h=waitbar(0,'process');
for(ii=1:numshots)
    i=i+1
    shotno=shotno+1;
    mshot=shotno
    
%    oo_prepare();
    
%    ep_prepare();
%     raphaella_prepare();
%     ebljied_prepare();
    tapedrive_prepare();
%    edaq_prepare();
%    gre_prepare();
    drawnow;
    pause(1);
%    

     shoot();
    pause(1);
    drawnow;
    %dlmwrite('c:\\app_junk\\shotco',[mrun shotno]);
    waitbar(i/numshots,h);
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
    
function edaq_prepare()
    global tt;
    mfile='c:\app_junk\edaq';    
    writeData(mfile);
    mput(tt,mfile);
    
function tapedrive_prepare()
    global tt;
    mfile='c:\app_junk\tapedrive_prepare';
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
        