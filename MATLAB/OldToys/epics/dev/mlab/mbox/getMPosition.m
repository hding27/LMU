function Pos = getMPosition(mc,motor)

% check if serial port exists
%if ~exist('mc','var')
%    disp('error: no connection to motor box');
%    return
%end

% check if serial port exists
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end

% see if motor is initialized
if motor.init
    
    % try to get motor position
    [P status]  = llget(mc,motor.N,'C');
    
    % if successfull
    if status
      Pos = P;
    else
        disp(strcat('failed to get motor position for motor ',...
            num2str(motor.N)));
    end
    
else
    disp(strcat('failed to get motor position for motor ',...
            num2str(motor.N),' (not initialized).'));
end

end