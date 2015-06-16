%Determines the location of the peak of h2 in comparison with loc_peak1
%TEST
function [ peak_position ] = distance_final(loc_peak1, h2)

%[peaks, peak_location] = findpeaks(h,'SortStr','descend');
%peak_location = sort(peak_location(1:7),'ascend')
%peak_position = peak_location(2);

Ts = 1200; %Search window
% 
 %plot(h2)
 %title('h2')
 %figure

loc_peak_1 = loc_peak1;

[peaks_2_f,locations_2_f] = findpeaks(h2([loc_peak_1-Ts:loc_peak_1+Ts]), 'MinpeakDistance', 2*Ts-1);

loc_peak_2_f = loc_peak1 + locations_2_f(1) - Ts;
%peaks_2_f


if(loc_peak_2_f - Ts < 2)
    start = 1;
else
    start = loc_peak_2_f - Ts;
end

[peaks_2,locations_2] = findpeaks(h2(start:loc_peak_2_f), 'MinPeakHeight',0.99*peaks_2_f(1));
%locations_2

%[peaks_2,locations_2] = findpeaks(h2([loc_peak_1-Ts:loc_peak_1+Ts]), 'SortStr', 'descend', 'NPeaks',5);

%Visualize the found peaks

%findpeaks(h2(start:loc_peak_2_f+200), 'MinPeakHeight', 0.8*peaks_2_f(1))
%findpeaks(h2(loc_peak_2_f - Ts:loc_peak_2_f+200), 'MinPeakHeight', 0.75*peaks_2_f(1))

%findpeaks(h2([loc_peak_1-Ts:loc_peak_1+Ts]), 'MinpeakDistance', 2*Ts-1)
%findpeaks(h2([loc_peak_1-Ts:loc_peak_1+Ts]), 'SortStr', 'descend', 'NPeaks',5);
%figure

%TODO kijken of deze 1 sample afwijkt ivm nummering matlab
peak_position = start + locations_2(1);

end

