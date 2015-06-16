clear;
close all;
load mic_positions
data = zeros(1, 414);
for i = 0:413
    tdoa = make_tdoa(x, [i 105 26]);
    pos = localize_5ch_test(tdoa);
    data(1,i+1) = pos(1) - i;
    %data(2,i+1) = pos(3) - 26;
end
plot(data);