function measure_voltage
%MEASURE_VOLTAGE Summary of this function goes here
%   Detailed explanation goes here
global voltage
test_count = 0;
while(1)
    status = EPOCommunications('transmit', 'S');
    raw = strsplit(status, {'D', 'U', 'A', 'udio ', '\n', ' '});
    voltage_str = raw(1,6);
    voltage.value = str2double(voltage_str)/1000;
    if(voltage.value > 17)
        test_count = test_count + 1;
    end
    if(test_count >= 5)
        voltage.done = true;
        break;
    end
end
end