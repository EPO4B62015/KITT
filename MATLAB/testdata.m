statusd = [0 0 0 0 0 0];
t = clock;
t = t(6);
while(1)
drive(150,150);
statusd = data(statusd);
if (size(statusd,1)==101)
    break
end
end
t2 = clock;
t2 = t2(6);
time = t2 - t;