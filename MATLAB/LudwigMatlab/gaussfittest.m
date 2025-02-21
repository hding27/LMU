x = [-3:.1:3];
norm = normpdf(x,0,1);

gfit = fittype('a.*exp(-(x^2)/(2*sig^2))','dependent',{'norm'},'independent',{'x'},'coefficients',{'a','sig'});
