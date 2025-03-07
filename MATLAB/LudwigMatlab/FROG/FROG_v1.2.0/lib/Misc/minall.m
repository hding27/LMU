function [ym, index] = minall(y)
%MINALL finds the minimum value in all elements.
%	MINALL(Y) Returns the minimum value of all the elements of Y.
%   [YM, INDEX] = MINALL(Y) returns the minimum value in YM, and its index
%   in INDEX.

%	$Revision: 1.1 $ $Date: 2006-11-11 00:15:35 $
%
%	$Log: minall.m,v $
%	Revision 1.1  2006-11-11 00:15:35  pablo
%	CVS server re-installation
%	
%	Revision 1.2  2003/02/28 20:21:08  xg
%	Index output added.
%	
%	Revision 1.1  2002/09/17 03:21:34  xg
%	created
%	

[ym, index1] = min(y(:));

index = avindex(index1, size(y));