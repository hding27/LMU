function e_master
clear all
clc

tt=ftp('130.183.92.172');
if(strcmp(class(tt),'ftp')==0)
    error('could not connect to ftp server');
end

ep_loc_file='c:\app_junk\espec_prepare';
oo_loc_file='c:\app_junk\spectrometer_prepare';
gre_loc_file='c:\app_junk\grenouille_prepare';
sh_loc_file='c:\app_junk\shooter_doit';

mdata(1)=100905;
mdata(2)=01;


for(i=23:24)
    %create a spectrometer prepare file
    mdata(3)=i;
    
    %dlmwrite(ep_loc_file,mdata');
    dlmwrite(oo_loc_file,mdata');
    dlmwrite(sh_loc_file,zeros(1,1));
    
    %mput(tt,ep_loc_file);
    mput(tt,oo_loc_file);
    drawnow;
    pause(3);
    mput(tt,sh_loc_file);
    pause(3);
    drawnow;
end
close(tt);
    
    