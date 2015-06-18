%TEST 
function [location_peak1] = loc_peak_1_final(h1)

Ts = 1200; %Search window

%Determine the location of the largest peak after a silence period
[peaks_f, locations_f] = findpeaks(h1(Ts:end), 'MinPeakDistance', 6000);
%peaks_f

%plot(h1)
%title('h1')
%figure

%Check if there is another peak
%loc_peak_f = locations_f(1)+Ts

%[peaks, locations] = findpeaks(h1(loc_peak_f-Ts:loc_peak_f), 'MinPeakHeight', 0.99*peaks_f(1));
%locations;

%findpeaks(h1(loc_peak_f-Ts:loc_peak_f+200), 'MinPeakHeight', 0.80*peaks_f(1))
%figure

%location_peak1 = loc_peak_f + locations(1) - Ts; %Location of first peak
location_peak1 = locations_f(1)+Ts
end