function status = update(obj)

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


% see if motor is initialized
if obj.isinit
    
    % update position
    obj.P   = llget(obj,'C');
    
    % update direction
    obj.d   = llget(obj,'Zd');
    
    % see of we reached endswitch
    stat    = llget(obj,'$');
    
    % max endswitch
    if stat == 164 && obj.P > 0
        obj.max = true;
        obj.min = false;
    end
    
    if stat == 164 && obj.P <= 0
        obj.max = false;
        obj.min = true;
    end
    
    if stat == 161
        obj.max = false;
        obj.min = false;
    end
    
    status = true;

else
    
    % error message
    fprintf('error: motor %i not initialized.', obj.N);
end 


end