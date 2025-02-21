function [E,varargout]=LANEX(Z, xP, yP, LANEX)
    ZZ = @(E) eTrajectory(E, xP, yP, LANEX) - Z;
    options=optimoptions('fsolve','Display','off');
    
    [E,fval,exitflag,output] = fsolve(ZZ,300,options);
    varargout(1)=output;
