%Data function to determine the distances only
function [distances_data1] = data_distance(distances_data)
%DATA Summary of this function goes here
%   Detailed explanation goes here 
inc_data = EPOCommunications('transmit', 'S');
raw = strsplit(inc_data, {'D', 'U', 'A', 'udio ', '\n', ' '});
datar = [raw(1,4), raw(1,5)];
distances = str2double(datar);
distances_data1 = [distances_data; distances]
end

