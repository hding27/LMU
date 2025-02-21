function [motor status] = motorOn(mc,motor)

status  = false;

% check if serial port exists
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end

if motor.init
    
    if llcmd(mc,motor.N,'r50')
        motor.status    = 'on';
        status          = true;
        fprintf('motor %i on.\n',motor.N);
    else
        fprintf('error while turning on motor $i\n',motor.N);
        return
    end
else
    fprintf('error: motor $i not initialized.\n',motor.N);
    return;
end

end