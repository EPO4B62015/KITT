function status_update
global car;
inc_data = EPOCommunications('transmit', 'S');
raw = strsplit(inc_data, {'D', 'U', 'A', 'udio ', '\n', ' '});
data = str2double(raw);
car.LeftSensor = data(4);
car.RightSensor = data(5);
car.Voltage = data(6) / 1000;
car.AudioStatus = data(7);
end