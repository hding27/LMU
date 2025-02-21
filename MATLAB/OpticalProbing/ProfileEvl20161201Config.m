%% load Max's Tango class
myDir = 'o:/electrons/20161201/';
prob = Probe(myDir);
prX = ProbeX(myDir);
hex = Hexapod(myDir);
er5 = ER5000(myDir);
%% generate an overview of the day
figure(71), title('overview'); hold on
plot(prX.No, prX.Position,'-r')
plot(hex.No, hex.X,'-g')
plot(er5.No, er5.SetPoint,'-k')
%% available data fufilling the conditions below
shotSet = 4765:5020;
condHexX = hex.No(ismember(hex.No,shotSet));
condProbeX = prX.No(ismember(prX.No,shotSet));
condPressure = er5.No(ismember(er5.No,shotSet));
shotSet = intersect(intersect(condProbeX,condHexX),condPressure);
positionSet = prX.Position(ismember(prX.No,shotSet));
figure(72),plot(shotSet, positionSet);
positions = unique(positionSet);