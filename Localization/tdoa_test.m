clear
load audiodata.mat
load mic_positions.mat
metingen = [0;0;0]
for n = 1:10
    [tdoa, tdoa2] = ch5_tdoa_final(RXXr(n,:,:));
    metingen = [metingen, localize_5ch_test(x, tdoa2)];
end