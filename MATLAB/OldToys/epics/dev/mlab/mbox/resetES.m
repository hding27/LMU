function status = resetES(mc,motor)

% check if serial port is open
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end

P       = llget(mc,motor.N,'C');
status  = llcmd(mc,motor.N,strcat('D',num2str(P)));

end