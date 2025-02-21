function status = llcmd(mc,motor,cmd)

status = false;

% check if com port is open
if ~strcmp(mc.Status,'open')
    fprintf('error: motor connection not initialized.');
    return;
end

% erase buffer
if mc.BytesAvailable ~= 0
    buffer = fscanf(mc,'%s',mc.BytesAvailable);
    fprintf('Buffer not empty: %s\n',buffer);
end

% send command
C = strcat('#',num2str(motor,'%i'),cmd);
fprintf(mc,C);


% wait & see if controller sends answer
ii = 0;
while ii < 50
    
    ii = ii + 1;
    pause(0.01);
    
    % answer from controller available
    if mc.BytesAvailable ~= 0
        
        A = fscanf(mc,'%s',mc.BytesAvailable);
        if strcmp(strcat(num2str(motor,'%i'),cmd),A)
            status = true;
        else
            fprintf('error with command\n');
            fprintf(strcat('request: ',C,'\n'));
            fprintf(strcat('response: ',A,'\n'));
        end
        break;
    end
    
    if ii == 50
        fprintf('error: communication timeout\n');
        break;
    end
    
end

end