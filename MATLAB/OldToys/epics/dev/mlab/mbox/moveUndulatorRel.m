function status = moveUndulatorRel(mc,motor1,motor2,s)

status  = false;
delta   = 100;


% check if serial port is open
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end

if all([motor1.init motor2.init]) == false
    disp('error: motors not ready');
    return
end


if s > 0
    s_rest  = mod(s,delta);
    step    = delta;
    N       = abs((s-s_rest) / delta);
else
    s_rest  = mod(s,-delta);
    step    = -delta;
    N       = abs((s-s_rest) / delta);
end
    
    
for ii=1:N
    moveMrel(mc,motor1,step);
    moveMrel(mc,motor2,step);
end

moveMrel(mc,motor1,s_rest);
moveMrel(mc,motor2,s_rest);

end