%EPOCommunications.mexw64 in the same folder 
comport = '\\.\COM3'; %Com poort verschilt Bluetooth Module: 3215 
EPOCommunications('close'); 
result = EPOCommunications('open', comport); 
status = EPOCommunications('transmit', 'S'); 
EPOCommunications('transmit','A1');

%result = EPOCommunications('close');