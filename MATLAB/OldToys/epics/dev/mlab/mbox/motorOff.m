function [motor status] = motorOff(mc,motor)

status  = false;

% check if serial port exists
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end

if motor.init
    
    if llcmd(mc,motor.N,'r0')
        motor.status    = 'off';
        status          = true;
    else
        fprintf('error while putting to sleep motor $i\n',motor.N);
        return
    end
else
    fprintf('error: motor $i not initialized.\n',motor.N);
    return;
end

end