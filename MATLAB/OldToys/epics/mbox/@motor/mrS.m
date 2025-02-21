function status = mrS(obj,s)


global mc;          % COM port variable is global
status = false;     % default status


% check if com port is open
if ~exist('mc','var')
    fprintf('ERROR: COM port not open. Do nothing.\n');
    return;
end

if ~strcmp(mc.Status,'open')
    fprintf('ERROR: motor connection not initialized. Do nothing.\n');
    return;
end


% check for valid argument
if ~isnumeric(s)
    disp('error: wrong argument');
    return
end

update(obj);

if obj.min
    fprintf('endswitch reached (min). will not move\n');
    return
end

if obj.max
    fprintf('endswitch reached (max). will not move\n');
    return
end


% see if motor is initialized
if obj.isinit == true && strcmp(obj.onoff,'on')
    
    
    % adjust motor direction
    if s < 0
        llcmd(obj,'d0');
    else
        llcmd(obj,'d1');
    end
        
    
    % set stepsize
    llcmd(obj,strcat('s',num2str(abs(s))));
    
    % move motor
    llcmd(obj,'A');
    
    update(obj);
    
    ii = 0;
    fprintf('move motor %i\n\t', obj.N);

    % wait while motor is moving
    while llget(obj,'$') == 160

        % wait
        pause(0.05);

        % status update
        ii = ii + 1;
        if mod(ii,10) == 0, fprintf('.'); end
        if mod(ii,100) == 0, fprintf('\n\t'); end
    end

    fprintf(' done.\n');
    
    status = true;
    
else
    
    % error message
    fprintf('error moving motor %i\n\tmotor.init: %i\n\tmotor.onoff: %s\n',...
        obj.N, obj.isinit, obj.onoff);
end


update(obj);

if obj.min
    fprintf('endswitch reached (min).\n');
    return
end

if obj.max
    fprintf('endswitch reached (max).\n');
    return
end

end