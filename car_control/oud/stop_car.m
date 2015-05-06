function status = stop_car
d = int2str(150);
s = int2str(150);
signal = ['D',d,' ',s];
status = EPOCommunications('transmit',signal);
status = EPOCommunications('transmit','S');