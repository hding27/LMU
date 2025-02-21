function archiver_update_v1
% version 2011-05-14

%mcamontimer('stop');

beep();

% wait for all data to be uploaded
pause(1);

% get gui handles
handles = guidata(findall(0,'Tag','archiver_main_fig'));



% if we should save data...
if get(handles.dosave,'Value')

    
    % get data
    try
        
        nshot   = mcacache(handles.nshot);      % shot number
        nrun    = mcacache(handles.nrun);       % run number
        
        % capillary pressure, t and p axis
        cap_press_t     = mcacache(handles.cap_press_t);
        cap_press_p     = mcacache(handles.cap_press_p);
        
        % cindy pressure
        cdy_press       = mcacache(handles.cdy_press);
        
        % laser pointing image
        %lpointing   = mcacache(handles.lpointing);
        
    catch err
        msgbox('error caching data');
    end

    
    
    
    % update display
    try

        set(handles.show_nshot,'String',num2str(nshot));
        set(handles.show_nrun,'String',num2str(nrun));

    catch err
        msgbox('error updating display');
    end

    
    
    
    % saving data
    try
    
        oldpath = cd(strcat(pwd,'/data'));

        % check if folder exists
        % otherwise create folder
        foldername = datestr(today,'yyyymmdd');
        if isempty(dir(foldername))
            mkdir(foldername)
        end
        cd(foldername);
        
        
        data = [];
        data.nrun   = nrun;
        data.nshot  = nshot;
        data.time   = datestr(now,'yyyy/mm/dd HH:MM:SS');
        
        
        % see which data to safe
        if get(handles.dosave_EDAQ_CAP_PRESS,'Value')
            %data.cap_press_t = cap_press_t;
            data.cap_press_p = cap_press_p;
        end
        
        if get(handles.dosave_EDAQ_CDY_PRESS,'Value')
            data.cdy_press = cdy_press;
        end

        if get(handles.dosave_EDAQ_CAM_LPOINTING,'Value')
            data.lpointing = reshape(lpointing,640,480)';
        end
        
        if get(handles.dosave_EDAQ_CAM_EPOINTING,'Value')
            img1 = mcacache(handles.epointing1);
            img2 = mcacache(handles.epointing2);
            img3 = mcacache(handles.epointing3);
            img4 = mcacache(handles.epointing4);
            img = [img1 img2 img3 img4];
            %img = double(img + 128);
            %img = uint8(img);
            data.epointing = reshape(img,1280,960)';
        end
        
        if get(handles.dosave_EDAQ_CAM_BEAST_FRONT,'Value')
            img1 = mcacache(handles.frontmark1);
            img2 = mcacache(handles.frontmark2);
            img3 = mcacache(handles.frontmark3);
            img4 = mcacache(handles.frontmark4);
            img = [img1 img2 img3 img4];
            %img = double(img + 128);
            %img = uint8(img);
            data.frontmark = reshape(img,1280,960)';
        end
        
        if get(handles.dosave_EDAQ_CAM_BEAST_REAR,'Value')
            img1 = mcacache(handles.rearmark1);
            img2 = mcacache(handles.rearmark2);
            img3 = mcacache(handles.rearmark3);
            img4 = mcacache(handles.rearmark4);
            img = [img1 img2 img3 img4];
            img = uint8(img);
            data.rearmark = reshape(img,1280,960)';          
            
        end       
        
        data.comment = get(handles.edit_comment,'String');
        
        % create file name
        filename = strcat(foldername,'-',num2str(nrun),...
            '-',num2str(nshot),'.mat');
        
        % try to save file
        if isempty(dir(filename))
            save(filename,'-struct','data');
        else
            msgbox(strcat('error: run and shot number already exist.\n',...
            'will NOT overwrite file'));
        end
        
        % tidy up
        set(handles.show_filename,'String',filename);
        cd(oldpath);


    catch err
        msgbox('error: saving file');
    end

end
%mcamontimer('start');
end