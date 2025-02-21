function [A status] = llget(mc,motor,cmd)


% defaults
status  = false;
A       = [];


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
while ii < 20
    
    ii = ii + 1;
    pause(0.01);
    
    % answer from controller available
    if mc.BytesAvailable ~= 0
        
        A = fscanf(mc,'%s',mc.BytesAvailable);
        
        if strcmp(A,'?')
            fprintf('wrong command: %s\n',C);
            break;
        else
            
            % kill trailing zeros
            if A(1) == '0', A = A(2:end); end
            if A(1) == '0', A = A(2:end); end
            
            % kill motor number
            A = A(length(num2str(motor))+1:end);
            
            % get response
            A = textscan(A,strcat(cmd,'%d'));
            A = cell2mat(A);
            
            status = true;
            break;
        end  
    end
    
    % timeout after 200 ms
    if ii == 20
        fprintf('error: communication timeout\n');
        break;
    end

end

end