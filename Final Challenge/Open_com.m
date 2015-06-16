%EPOCommunications.mexw64 in the same folder 
comport = '\\.\COM5'; %Com poort verschilt Bluetooth Module: 3215 %Com poort 22 op test pc
EPOCommunications('close'); 
result = EPOCommunications('open', comport); 
status = EPOCommunications('transmit', 'S'); 
EPOCommunications('transmit','A1') ;

%result = EPOCommunications('close');