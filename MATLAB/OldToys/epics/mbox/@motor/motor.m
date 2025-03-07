classdef motor < handle
        
    properties (SetAccess = private)
        
        isinit  = false;        % true if properly initialized
        N       = [];           % motor controller
        p       = 1;            % controller modus: 1 = relative pos.
        s       = 100;          % steps to move
        d       = 0;            % direction: d = 0 = left = towards motor
        P       = [];           % Position
        onoff   = [];           % phase current set on/off
        i       = 50;           % phase current when moving
        r       = 10;           % phase current when on hold
        u       = 50;           % initial motor frequency
        o       = 300;          % target motor frequency
        min     = [];           % MIN endswitch
        max     = [];           % MAX endswitch
        
    end
    
    methods
        
        % constructor
        function obj = motor(controller)
            
            global mc;
            
            % if no connection to com port
            % configure new serial connection
            % to motorbox
            if isempty(mc) || strcmp(mc.Status,'closed')
                mc = serial('/dev/ttyS1',...
                    'BaudRate',115200,...
                    'Terminator','CR/LF',...
                    'TimeOut',2);
                fopen(mc);
                fprintf('Connection to COM port established.\n');
            end

            % motor controller ID
            obj.N = controller;
            
            init(obj);
            
        end
        
        status      = llcmd(obj,cmd);       % low level command
        status      = init(obj);            % init motor
        [A status]  = llget(obj,cmd);       % low level get
        status      = mrS(obj,s);           % move relative - steps
        status      = maS(obj,s);           % move absolute - steps
        status      = update(obj);
        status      = motorOFF(obj);        % set phase currents to zero
        status      = motorON(obj);         % resets phase current

    end
    
end
 