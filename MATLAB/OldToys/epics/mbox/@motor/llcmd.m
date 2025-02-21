function status = llcmd(obj,cmd)


global mc;          % COM port variable is global
status = false;     % default status


controller = obj.N;


% check if com port is open
if ~exist('mc','var')
    fprintf('ERROR: COM port not open. Do nothing.\n');
    return;
end

if ~strcmp(mc.Status,'open')
    fprintf('ERROR: motor connection not initialized. Do nothing.\n');
    return;
end


% erase buffer
if mc.BytesAvailable ~= 0
    buffer = fscanf(mc,'%s',mc.BytesAvailable);
    fprintf('WARNING: Buffer not empty: %s\n',buffer);
end


% send command to COM port
C = strcat('#',num2str(controller,'%i'),cmd);
fprintf(mc,C);


% wait & see if controller sends answer
ii = 0;
while ii < 20
    
    % wait 10 ms
    ii = ii + 1;
    pause(0.01);
    
    % answer from controller available
    if mc.BytesAvailable ~= 0
        
        A = fscanf(mc,'%s',mc.BytesAvailable);
        if strcmp(strcat(num2str(controller,'%i'),cmd),A)
            status = true;
        else
            fprintf('error with command\n');
            fprintf(strcat('request: ',C,'\n'));
            fprintf(strcat('response: ',A,'\n'));
        end
        break;
    end
    
    % timeout after 200 ms
    if ii == 20
        fprintf('error: communication timeout\n');
        break;
    end
    
end

end