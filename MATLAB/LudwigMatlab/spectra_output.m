clear all
addpath(genpath('O:\Ludwig\Matlab'))
spec = load('before_fiber.txt');
norm_spec(:,1)=spec(:,1);
norm_spec(:,2)=spec(:,2)./max(spec(:,2));