function status = motorON(obj)

status  = false;

if all([
    llcmd(obj,strcat('o',num2str(obj.o)))...    % maximum frequency
    llcmd(obj,strcat('i',num2str(obj.i)))...    % phase current 50 %
    ])

    obj.onoff = 'on';

    status = true;
else
    fprintf('failed to turn motor %i ON.\n',obj.N);
end


end