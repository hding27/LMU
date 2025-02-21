function Prepare(name)

    global flags
    global udps
    
    if(flags.(name).enable)
        write(udps.(name),[mdate mrun mshot], 'uint16');
    else disp('enable = off')
    end
