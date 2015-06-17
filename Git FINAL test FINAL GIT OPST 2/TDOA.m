function [ TDOA_data ] = TDOA
%TDOA runs the tdoa and returns a column with distances differences
Fs = 48000;
Trec = 0.25;
disp('Sampling');
measured_data = pa_wavrecord(3, 7, Fs*Trec, Fs, 'asio');
disp('TDOA calculating');
[TDOA_matrix, TDOA_data] = ch5_tdoa_final(measured_data);
end

