%MINGERR Minimizes the G error.
%	MINGERR(ESIG, ASIG) minimizes the difference between ASIG^2 and |ESIG|^2,
%	by scaling |ESIG|^2.  This accounts for differences in scaling between
%	Asig and Esig.
%
%	[GMIN,U,G0]=MINGERR(...) returns the minimum G, GMIN, the scaling, U, and
%	the raw G, G0.  The raw G is the error without scaling.
%
%	This function ignores all values in Asig that are negative.

%	$Id: MinGerr.m,v 1.1 2006-11-11 00:15:29 pablo Exp $
