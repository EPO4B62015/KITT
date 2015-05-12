function [t_uit, t_rem] = velocity_lookup(velocity)
load data_velocity
find_v = velocity;
if(find_v < 1.32)
    find_v = 1.32;
    disp('Velocity too low - Velocity Lookup')
    t_uit = [0.55; 0.19; 0.47];
    t_rem = [0.576576576576577; 0.412312841500145; 0.128323616817358];
else
column = find(t1(1, 2:end) <= find_v);
t_uit = t1(2:end, column(1) + 1);
t_rem = t2(2:end, column(1) + 1);
end
end