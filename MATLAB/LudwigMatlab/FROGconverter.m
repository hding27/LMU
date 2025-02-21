clc
clear all

mpath=mfilename('fullpath');
mpath=mpath(1:find(mpath=='\',1,'last'));

mfiles=dir([mpath 'frog.bmp'])

ss='';
for ii=1:640
    ss=[ss '%5.3f\t'];
end
ss=ss(1:end-2);
ss=[ss '\n'];

for ii=1:length(mfiles)
    
%     fid = fopen([mpath mfiles(ii).name]);
%     mmat = (fread(fid, [768 576], 'uint32'))';
%     fclose(fid);
    mmat=imread([mpath mfiles(ii).name]);
    if(size(mmat,1)~=640)
        continue;
    end
    mmat=mmat';
    fid=fopen([mpath mfiles(ii).name(1:find(mfiles(ii).name=='.',1,'last')) 'txt'],'wt');
    fprintf(fid,'%d %d %5.3f %5.3f %5.3f\n',480,640,1.022, 0.124,400);
    for jj=1:480
        fprintf(fid,ss,mmat(jj,:));
    end
    fprintf(fid,'\n');
    fclose(fid);
    
    imagesc(mmat);
    title(ii);
    drawnow
    pause(1)
    
end
