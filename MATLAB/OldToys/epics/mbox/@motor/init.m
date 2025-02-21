function status = init(obj)

status  = false;


if all([
    llcmd(obj,strcat('p',num2str(obj.p)))...    % relative positioning
    llcmd(obj,strcat('s',num2str(obj.s)))...    % step size
    llcmd(obj,strcat('d',num2str(obj.d)))...    % direction: left (0)
    llcmd(obj,strcat('u',num2str(obj.u)))...    % minimum frequency
    llcmd(obj,strcat('o',num2str(obj.o)))...    % maximum frequency
    llcmd(obj,strcat('i',num2str(obj.i)))...    % phase current 50 %
    llcmd(obj,strcat('r',num2str(obj.r)))...    % current when in hold
    llcmd(obj,':port_in_f7')...                 % input 6: end switch
    llcmd(obj,':port_out_a1')...                % out 1: status ready
    llcmd(obj,':port_out_b2')...                % out 2: status move
    llcmd(obj,'l5154')...                       % if endswitch: go back
    ])


    obj.P       = llget(obj,'C');
    obj.isinit  = true;
    obj.onoff   = 'on';
    
    
    % see of we reached endswitch
    stat = llget(obj,'$');
    
    % max endswitch
    if stat == 164 && obj.P > 0
        obj.max = true;
        obj.min = false;
    end
    
    if stat == 164 && obj.P <= 0
        obj.min = true;
        obj.max = false;
    end

    if stat == 161
        obj.min = false;
        obj.max = false;
    end
    
    
    fprintf('motor %i init OK.\n', obj.N);
    status = true;
    
else
    
    fprintf('Failed to init motor, channel %i.\n',obj.N);
    
end

end