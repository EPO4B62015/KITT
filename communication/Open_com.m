comport = '\\.\COM9'; %Bluetooth Module: 3215 
EPOCommunications('close'); 
result = EPOCommunications('open', comport); 
status = EPOCommunications('transmit', 'S'); 
EPOCommunications('transmit','A1');