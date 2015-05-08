Velocity = simout.signals.values;
Time = simout.time;
%plot(Time,Velocity);
%title('Time-velocity plot KITT acceleration')
%xlabel('Time [s]')
%ylabel('Velocity [m/s]')

%vlim = 60/3.6;
%T = find(Velocity >= vlim);
%vlim_time = Time(T(1));