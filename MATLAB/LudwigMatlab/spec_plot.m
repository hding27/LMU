clear all
addpath(genpath('D:\Uni\Masterarbeit'))

spec = load('before_fiber_Mean.txt');
spec_norm(:,1) = spec(:,1);
spec_norm(:,2) = spec(:,2)./max(spec(:,2));