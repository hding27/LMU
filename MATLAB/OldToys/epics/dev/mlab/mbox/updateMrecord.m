function motor = updateMrecord(mc,motor)

% check if serial port is open
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end


% see if motor is initialized
if motor.init
    
    % update position
    motor.P     = getMPosition(mc,motor);
    
    % update direction
    motor.d     = llget(mc,motor.N,'Zd');
    
    % see of we reached endswitch
    stat        = llget(mc,motor.N,'$');
    
    % max endswitch
    if stat == 164 && motor.P > 0
        motor.max = true;
        motor.min = false;
    end
    
    if stat == 164 && motor.P <= 0
        motor.max = false;
        motor.min = true;
    end
    
    if stat == 163
        motor.min = true;
        motor.max = false;
    end
    
    if stat == 161
        motor.max = false;
        motor.min = false;
    end

else
    
    % error message
    fprintf('error: motor %i not initialized.', motor.N);
end 

end