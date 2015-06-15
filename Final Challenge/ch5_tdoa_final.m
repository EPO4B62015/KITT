
function [TDOA, TDOA_2] = ch5_tdoa_final(input_matrix)
%Calculates the TDOA of the 5 channels
speed_of_sound = 340;

%Put the measurement data in seperate variables
data_mic_1 = input_matrix((1:length(input_matrix)),1);
data_mic_2 = input_matrix((1:length(input_matrix)),2);
data_mic_3 = input_matrix((1:length(input_matrix)),3);
data_mic_4 = input_matrix((1:length(input_matrix)),4);
data_mic_5 = input_matrix((1:length(input_matrix)),5);

%Calculate the channel estimates for all mics
[channel_fe_1, channel_mf_1] = channel_estimation_5ch(data_mic_1);
[channel_fe_2, channel_mf_2] = channel_estimation_5ch(data_mic_2);
[channel_fe_3, channel_mf_3] = channel_estimation_5ch(data_mic_3);
[channel_fe_4, channel_mf_4] = channel_estimation_5ch(data_mic_4);
[channel_fe_5, channel_mf_5] = channel_estimation_5ch(data_mic_5);

%detect position of the peak in each channel
position_mic(1) = loc_peak_1_final(channel_fe_1);
position_mic(2) = distance_final(position_mic(1), channel_fe_2);
position_mic(3) = distance_final(position_mic(1), channel_fe_3);
position_mic(4) = distance_final(position_mic(1), channel_fe_4);
position_mic(5) = distance_final(position_mic(1), channel_fe_5);

%Calculate all the differences in distances
TDOA = zeros(5);
for x = 1:5
    for y = 1:5
        TDOA(y,x) = position_mic(x) - position_mic(y);
    end
end
%Calculate the TDOA in centimers
TDOA = TDOA ./ 48000;
TDOA = TDOA .* speed_of_sound*100; 
%Make an array from the data for the function localize
TDOA_2 = [TDOA(2,1);TDOA(3,1);TDOA(4,1);TDOA(5,1);TDOA(3,2);TDOA(4,2);TDOA(5,2);TDOA(4,3);TDOA(5,3);TDOA(5,4)];
end