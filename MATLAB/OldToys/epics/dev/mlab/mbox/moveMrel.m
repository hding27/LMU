function motor = moveMrel(mc,motor,s)

% check if serial port is open
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end

% check for valid argument
if ~isnumeric(s)
    disp('error: wrong argument');
    return
end


% update motor info
motor = updateMrecord(mc,motor);

if motor.min && (s > 0) && (llget(mc,motor.N,'$') == 163)
    motor.min = false;
end

if motor.min
    fprintf('endswitch reached (min). will not move\n');
    return
end

if motor.max
    fprintf('endswitch reached (max). will not move\n');
    return
end


% see if motor is initialized
if motor.init == true && strcmp(motor.status,'on')
    
    
    % adjust motor direction
    if s < 0
        llcmd(mc,motor.N,'d0');
    else
        llcmd(mc,motor.N,'d1');
    end
        
    
    % set stepsize
    llcmd(mc,motor.N,strcat('s',num2str(abs(s))));
    
    % move motor
    llcmd(mc,motor.N,'A');
    
else
    
    % error message
    fprintf('error moving motor %i\nmotor.init: %i\nmotor.status: %s\n',...
        motor.N, motor.init, motor.status);
end


ii = 0;
fprintf('move motor %i', motor.N);

% wait while motor is moving
while llget(mc,motor.N,'$') == 160
    
    % wait
    pause(0.01);
    
    % statu update
    ii = ii + 1;
    if mod(ii,10) == 0, fprintf('.'); end
end

fprintf(' done.\n');

% update motor info
motor = updateMrecord(mc,motor);

if motor.min
    fprintf('endswitch reached (min).\n');
    return
end

if motor.max
    fprintf('endswitch reached (max).\n');
    return
end
      
end