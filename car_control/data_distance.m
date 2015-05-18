%Data function to determine the distances only
function [distances_data] = data_distance(t_start) %De starttijd als input

inc_data = EPOCommunications('transmit', 'S');
tijd_verschil = toc(t_start);
raw = strsplit(inc_data, {'D', 'U', 'A', 'udio ', '\n', ' '});
datar = [raw(1,4), raw(1,5)];
distances = str2double(datar);
distances_data = [distances tijd_verschil];
end

