Velocity = simout.signals.values;
Time = simout1.time;
Distance = simout1.signals.values;
plot(Distance,Velocity);
title('Time-velocity plot KITT acceleration')
xlabel('Distance [m]')
ylabel('Velocity [m/s]')