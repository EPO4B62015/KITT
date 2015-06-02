%Calculate the peak locations based 
function [ peak_position ] = distance(h1, h2)
%DISTANCE Summary of this function goes here
%   Detailed explanation goes here

%[peaks, peak_location] = findpeaks(h,'SortStr','descend');
%peak_location = sort(peak_location(1:7),'ascend')
%peak_position = peak_location(2);

eps = 0.02;
Ts = 1000; %Search window


[peaks, locations] = findpeaks(h1, 'MinPeakDistance', 4000)

loc_peak_1 = locations([2]); %Get second peak

%findpeaks(h1, 'MinPeakDistance', 4000)

[peaks_2,locations_2] = findpeaks(h2([loc_peak_1-Ts:loc_peak_1+Ts]), 'MinpeakDistance', 2*Ts-1) ;
%findpeaks(h2([loc_peak_1-Ts:loc_peak_1+Ts]), 'MinpeakDistance', 2*Ts-1) 

peak_position = locations_2 + loc_peak_1 - Ts

end

