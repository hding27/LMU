addpath(genpath('O:\Ludwig\Matlab'))

comb = zeros(400,450);
left = load('20161202_006_1939_14bar_shockfront_leftsidet_upper_channel_phase_noNAN.asc');
right = load('20161202_006_1939_14bar_shockfront_rightsidet_upper_channel_phase_noNAN.asc');
for i = 1:380
cut_left(i,:) = left(440+i,504:803);
cut_right(i,:) = right(440+i,710:1015);

left_test = cut_left(i,:);
left_test(find(isnan(left_test))) = [];

right_test = cut_right(i,:);
right_test(find(isnan(right_test))) = [];

comb(i,1:(length(right_test)+length(left_test))) = [left_test, right_test];
    end
    




