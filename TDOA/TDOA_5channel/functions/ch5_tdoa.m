<<<<<<< HEAD
function [TDOA, TDOA_2] = ch5_tdoa(input_matrix)
speed_of_sound = 340;

data_mic_1 = input_matrix(1,(1:length(input_matrix)),1)';
data_mic_2 = input_matrix(1,(1:length(input_matrix)),2)';
data_mic_3 = input_matrix(1,(1:length(input_matrix)),3)';
data_mic_4 = input_matrix(1,(1:length(input_matrix)),4)';
data_mic_5 = input_matrix(1,(1:length(input_matrix)),5)';

[channel_fe_1, channel_mf_1] = channel_estimation_5ch(data_mic_1);
[channel_fe_2, channel_mf_2] = channel_estimation_5ch(data_mic_2);
[channel_fe_3, channel_mf_3] = channel_estimation_5ch(data_mic_3);
[channel_fe_4, channel_mf_4] = channel_estimation_5ch(data_mic_4);
[channel_fe_5, channel_mf_5] = channel_estimation_5ch(data_mic_5);


% position_mic_mf(1) = distance(channel_mf_1, channel_mf_1);
% position_mic_mf(2) = distance(channel_mf_1, channel_mf_2);
% position_mic_mf(3) = distance(channel_mf_1, channel_mf_3);
% position_mic_mf(4) = distance(channel_mf_1, channel_mf_4);
% position_mic_mf(5) = distance(channel_mf_1, channel_mf_5);

position_mic_mf(1) = distance(channel_fe_1, channel_fe_1);
position_mic_mf(2) = distance(channel_fe_1, channel_fe_2);
position_mic_mf(3) = distance(channel_fe_1, channel_fe_3);
position_mic_mf(4) = distance(channel_fe_1, channel_fe_4);
position_mic_mf(5) = distance(channel_fe_1, channel_fe_5);

TDOA = zeros(5);
for x = 1:5
    for y = 1:5
        TDOA(y,x) = position_mic_mf(x) - position_mic_mf(y);
    end
end

TDOA = TDOA ./ 48000;
TDOA = TDOA .* speed_of_sound;

TDOA_2 = [TDOA(2,1);TDOA(3,1);TDOA(4,1);TDOA(5,1);TDOA(3,2);TDOA(4,2);TDOA(5,2);TDOA(4,3);TDOA(5,3);TDOA(5,4)];
=======
function [TDOA, TDOA_2] = ch5_tdoa(input_matrix)
speed_of_sound = 340;

data_mic_1 = input_matrix(1,(1:length(input_matrix)),1)';
data_mic_2 = input_matrix(1,(1:length(input_matrix)),2)';
data_mic_3 = input_matrix(1,(1:length(input_matrix)),3)';
data_mic_4 = input_matrix(1,(1:length(input_matrix)),4)';
data_mic_5 = input_matrix(1,(1:length(input_matrix)),5)';

[channel_fe_1, channel_mf_1] = channel_estimation_5ch(data_mic_1);
[channel_fe_2, channel_mf_2] = channel_estimation_5ch(data_mic_2);
[channel_fe_3, channel_mf_3] = channel_estimation_5ch(data_mic_3);
[channel_fe_4, channel_mf_4] = channel_estimation_5ch(data_mic_4);
[channel_fe_5, channel_mf_5] = channel_estimation_5ch(data_mic_5);


position_mic_mf(1) = distance(channel_mf_1, channel_mf_1);
position_mic_mf(2) = distance(channel_mf_1, channel_mf_2);
position_mic_mf(3) = distance(channel_mf_1, channel_mf_3);
position_mic_mf(4) = distance(channel_mf_1, channel_mf_4);
position_mic_mf(5) = distance(channel_mf_1, channel_mf_5);

TDOA = zeros(5);
for x = 1:5
    for y = 1:5
        TDOA(x,y) = position_mic_mf(x) - position_mic_mf(y);
    end
end

TDOA = TDOA ./ 48000;
TDOA = TDOA .* speed_of_sound;

TDOA_2 = [TDOA(2,1);TDOA(3,1);TDOA(4,1);TDOA(5,1);TDOA(3,2);TDOA(4,2);TDOA(5,2);TDOA(4,3);TDOA(5,3);TDOA(5,4)];
>>>>>>> origin/module_3
end