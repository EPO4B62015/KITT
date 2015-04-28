function status = data(statusdata)
%DATA Summary of this function goes here
%   Detailed explanation goes here 
inc_data = EPOCommunications('transmit', 'S');
raw = strsplit(inc_data, {'D', 'U', 'A', 'udio ', '\n', ' '});
datar = [raw(1,2), raw(1,3), raw(1,4), raw(1,5), raw(1,6), raw(1,7)];
datarr = str2double(datar);
status = [statusdata; datarr];
end

