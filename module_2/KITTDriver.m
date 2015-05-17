clear all;
close all;
d = 6;

run KITTParameters.m

Fa = Fa_max;
Fb = 0;
V_ini = 0;
sim KITTDynamics
Velocity = simout.signals.values;
Distance = simout1.signals.values;
T2 = Distance;
Y2 = Velocity;
V_ini = 60/3.6;
T1 = 0;

while((max(T1) <= d-d*0.01) || (max(T1) >= d+d*0.01))
Fa = 0;
Fb = Fb_max;
sim KITTDynamics
Velocity = simout.signals.values;
Distance = simout1.signals.values;
T1 = Distance;
Y1 = Velocity;
D_intersect = polyxpoly(T1,Y1,T2,Y2);
if(max(T1) > d + d*0.01)
    
    V_ini = V_ini - 0.1;
end
if(max(T1) < d - d*0.01)
    V_ini = V_ini  + 0.1;
end
end

plot(T1,Y1,T2,Y2);
xlim([0 8]);
title('Velocity-Distance plot')
xlabel('Distance[m]');
ylabel('Velocity [m/s]');