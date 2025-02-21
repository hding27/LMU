function status = motorOFF(obj)

status  = false;

if all([
    llcmd(obj,'i0')...    % phase current: off
    llcmd(obj,'r0')...    % current when in hold: off
    ])

    obj.onoff = 'off';

    status = true;
else
    fprintf('failed to turn motor %i OFF.\n',obj.N);
end


end