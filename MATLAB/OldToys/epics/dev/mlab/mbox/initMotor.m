function motor = initMotor(mc,controller)

% check if serial port exists
if ~strcmp(mc.Status,'open')
    disp('error: serial connection closed');
    return
end


% init record
motor.init      = false;
motor.N         = controller;
motor.modus     = 1;
motor.s         = 100;
motor.d         = 0;
motor.status    = 'not defined';
motor.P         = llget(mc,controller,'C');


% see of we reached endswitch
stat = llget(mc,motor.N,'$');
    
% max endswitch
if stat == 164 && motor.P > 0
    motor.max = true;
    motor.min = false;
end
    
if stat == 164 && motor.P <= 0
    motor.min = true;
    motor.max = false;
end

if stat == 163
    motor.min = true;
    motor.max = false;
end

if stat == 161
    motor.min = false;
    motor.max = false;
end


% set default values
if all([...
    llcmd(mc,controller,'p1')...            % relative positioning
    llcmd(mc,controller,'s+100')...         % step size
    llcmd(mc,controller,'d+0')...           % direction: left (0)
    llcmd(mc,controller,'u50')...           % minimum frequency
    llcmd(mc,controller,'o300')...          % maximum frequency
    llcmd(mc,controller,'i50')...           % phase current 50 %
    llcmd(mc,controller,'r10')...           % current when in hold
    llcmd(mc,controller,':port_in_f7')...   % input 6: end switch
    llcmd(mc,controller,':port_out_a1')...  % out 1: status ready
    llcmd(mc,controller,':port_out_b2')...  % out 2: status move
    llcmd(mc,controller,'l5154')...         % if endswitch: go back
    ])
           
    motor.status    = 'on';
    motor.init      = true;
    fprintf('motor %i init OK.\n', controller);

else
    
    motor.max   = true;
    motor.min   = true;
    motor.P     = [];
    
end

end