function [ TDOA_data ] = TDOA
%TDOA Summary of this function goes here
%   TDOA runs the tdoa and returns a column with distances differences
global test_data
global i_measured
Fs = 48000;
Trec = 0.25;
measured_data = pa_wavrecord(3, 7, Fs*Trec, Fs, 'asio');
disp('gfjuio');
[TDOA_matrix, TDOA_data] = ch5_tdoa_final(measured_data);
end

