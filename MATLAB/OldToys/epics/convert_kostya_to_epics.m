
%    global mstop;
%    global nshot;
%    global nrun;

    mstop=0;

    mca;
    
    handle_nrun     = mcaopen('EDAQ:NRUN');
    handle_nshot    = mcaopen('EDAQ:NSHOT');
    
    if exist('tt','var')
        close(tt);
    end;
    
    while(mstop==0)
        
        tt=ftp('130.183.92.172');
        if(strcmp(class(tt),'ftp')==0)
            disp('shitstorm')
            mstop = 1;
        end
     
        
        ftpdirlist=dir(tt);
        for i=1:size(ftpdirlist,1)
            if(strcmp(ftpdirlist(i).name,'edaq'))
                
                pause(1);
                
                ff=char(mget(tt,ftpdirlist(i).name));
                aa=dlmread(ff);
                delete(tt,ftpdirlist(i).name);
                
                %in aa first line - date, second - run number, third - shot number
                nshot   = aa(3);
                nrun    = aa(2);
                
                %if ((nshot > mcaget(handle_nshot)) || (nrun > mcaget(handle_nrun)))
                    mcaput(handle_nshot,nshot);
                    mcaput(handle_nrun,nrun);
                    disp(nrun);
                    disp(nshot);
                %end
                
                %mcaput(handle_nshot,nshot);
                %mcaput(handle_nrun,nrun);
                %disp(nrun);
                %disp(nshot);

                
                %construct file names for lanes, log and spectrum:
%                lanex_file=sprintf('%s%s%04d%s',pathWithRun,'shot',aa(3),'_lanex.png');
%                spec_file=sprintf('%s%s%04d%s',pathWithRun,'shot',aa(3),'_spec.txt');
%                log_file=sprintf('%s%s%',pathWithRun,'log.txt');
                break;
            end
        end
        %disp('.');
        %drawnow;
        disp(strcat('still alive: ',datestr(now)));
        close(tt);
        pause(2);
    end
    
    close(tt);
    
    mcaclose(handle_nshot);
    mcaclose(handle_nrun);