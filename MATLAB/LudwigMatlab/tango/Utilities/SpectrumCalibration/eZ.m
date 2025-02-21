function z = eZ( E, y )
%EZ Summary of this function goes here
%   Detailed explanation goes here


%clear
%E = [100:10:700];
%y = [-30:2:30];



    z = zeros(length(E), length(y));

    for ei = 1:length(E)
        for yi = 1:length(y)
            z(ei, yi) = eTrajectory(E(ei),0,y(yi),'LE');
        end
    end

end

