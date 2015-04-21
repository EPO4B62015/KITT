function status = drive(speed, dir)
d = int2str(dir);
s = int2str(speed);
signal = ['D',d,' ',s];
status = EPOCommunications('transmit',signal);