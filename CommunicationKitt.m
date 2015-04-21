

comport = '\\.\COM3'
EPOCommunications('close');
result = EPOCommunications('open', comport);
status = EPOCommunications('transmit', 'S');