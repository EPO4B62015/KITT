test_clock = clock;
test_clock = test_clock(6);
if (test_clock < 58)
statusd = [0 0 0 0 0 0];
time_d = clock;
time_d = time_d(6);
t = clock;
t = t(6);
drive(165,152);
while(1)
t3 = clock;
t3 = t3(6);
[statusd, time_d] = data(statusd,time_d,t3);
if (size(statusd,1)==14)
    break
end
end
t2 = clock;
t2 = t2(6);
time = t2 - t;
while(1);
    t4 = clock;
    t4 = t4(6);
    if time<=1.5
        time = t4-t;
    else
     drive(140,152)
     break;
    end
end
time_end = clock;
time_end = time_end(6);
while(1)
t5 = clock;
t5 = t5(6);
[statusd, time_d] = data(statusd,time_d,t5);
if (size(statusd,1)==20)
    drive(150,152);
    break
end
end
end
data_t = [statusd time_d];
