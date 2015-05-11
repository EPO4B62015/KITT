function [t_uit, t_rem] = velocity_lookup(velocity)
load data_velocity;
find_v = round(velocity, 2);
if(find_v > 2.39)
    find_v = 2.39;
end
if(find_v < 1.32)
    find_v = 1.32;
    disp('Velocity too low - Velocity Lookup')
end
column = find(t1(1, 1:end) == find_v);
t_uit = t1(2:end, column);
t_rem = t2(2:end, column);