spec1 = load('0.56mJ_before_fiber_Frequency_Axis.txt');
spec1_w(:,1) = spec1(:,1).*2*pi;
spec1_w(:,2) = spec1(:,2)./max(spec1(:,2));
Var = var(spec1_w);
m = moment(spec1_w(:,2),2);
delta_w2 = sum(spec1_w(:,1).^2.*spec1_w(:,2).^2)/sum(spec1_w(:,2).^2) - ( sum(spec1_w(:,1).*spec1_w(:,2).^2)/sum(spec1_w(:,2).^2))^2;

figure(1)
plot(spec1_w(:,1),spec1_w(:,2));
 
spec2 = load('200mbar_500mJ_Frequency_Axis.txt');
spec2_w(:,1) = spec2(:,1).*2*pi;
spec2_w(:,2) = spec2(:,2)./max(spec2(:,2));
m = moment(spec2_w(:,2),2);
delta2_w2 = sum(spec2_w(:,1).^2.*spec2_w(:,2).^2)/sum(spec2_w(:,2).^2) - ( sum(spec2_w(:,1).*spec2_w(:,2).^2)/sum(spec2_w(:,2).^2))^2;

figure(2)
plot(spec2_w(:,1),spec2_w(:,2));

spec3 = load('700mbar_580uJ_Frequency_Axis.txt');
spec3_w(:,1) = spec3(:,1).*2*pi;
spec3_w(:,2) = spec3(:,2)./max(spec3(:,2));
m = moment(spec3_w(:,2),2);
delta3_w2 = sum(spec3_w(:,1).^2.*spec3_w(:,2).^2)/sum(spec3_w(:,2).^2) - ( sum(spec3_w(:,1).*spec3_w(:,2).^2)/sum(spec3_w(:,2).^2))^2;

figure(3)
plot(spec3_w(:,1),spec3_w(:,2));


spec4 = load('500mbar_250uJ_Frequency_Axis.txt');
spec4_w(:,1) = spec4(:,1).*2*pi;
spec4_w(:,2) = spec4(:,2)./max(spec4(:,2));
m = moment(spec4_w(:,2),2);
delta4_w2 = sum(spec4_w(:,1).^2.*spec4_w(:,2).^2)/sum(spec4_w(:,2).^2) - ( sum(spec4_w(:,1).*spec4_w(:,2).^2)/sum(spec4_w(:,2).^2))^2;

figure(4)
plot(spec4_w(:,1),spec4_w(:,2));


spec5 = load('500mbar_500uJ_Frequency_Axis.txt');
spec5_w(:,1) = spec5(:,1).*2*pi;
spec5_w(:,2) = spec5(:,2)./max(spec5(:,2));
m = moment(spec5_w(:,2),2);
delta5_w2 = sum(spec5_w(:,1).^2.*spec5_w(:,2).^2)/sum(spec5_w(:,2).^2) - ( sum(spec5_w(:,1).*spec5_w(:,2).^2)/sum(spec5_w(:,2).^2))^2;

figure(5)
plot(spec5_w(:,1),spec5_w(:,2));
 F = sqrt(delta5_w2)/sqrt(delta_w2);