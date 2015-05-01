%%%% CLEAR AND LOAD MEASUREMENTS %%%%%
clear all;
load ('data_f_2.mat');

%%%% REMOVE INCORRECT AND/OR NOT NEEDED MEASUREMENTS %%%%%
i=2;j=2;k=2;
while(i<size(data_t_a,1)) % incorrecte metingen weggooien
    if(data_t_a(i,4)==999 && data_t_a(i,3) == 999)
        data_t_a = [data_t_a(1:i-1,1:end); data_t_a(i+1:end,1:end)];
    elseif(data_t_a(i,4)==999)
        data_t_a(i,4)=data_t_a(i,3);
    elseif(data_t_a(i,3)==999)
        data_t_a(i,3)=data_t_a(i,4);   
    else
        i=i+1;
    end
end

while(k<size(data_t_a,1))
    if (data_t_a(k,2) < 150)
        data_t_a = data_t_a(1:k-1,1:end);
        break;
    end
    k = k+1;  
end

while(j<size(data_t_d,1)) 
    if(data_t_d(j,4) == 999 && data_t_d(j,3) == 999)
        data_t_d = [data_t_d(1:j-1,1:end); data_t_d(j+1:end,1:end)];
        j= j-1;
    elseif(data_t_d(j,4) == 999)
        data_t_d(j,4) = data_t_d(j,3);
    elseif(data_t_d(j,3) == 999)
        data_t_d(j,3) = data_t_d(j,4);   
    end
j=j+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% DISTANCES, TIMES and VELOCITIES %%%%%
Afstand_links_a     = abs(data_t_a(2:end,3)-data_t_a(2,4)); %afstand van 0 laten lopen
Afstand_rechts_a    = abs(data_t_a(2:end,4)-data_t_a(2,3));
    
Afstand = (Afstand_rechts_a /100); %Afstand in meters
Time_a  = data_t_a(2:end,7); %tijd vanaf zelfde moment metingen
V       = diff(Afstand)./diff(Time_a);
V = [0;V]; % begin with zero and append last value
Afstand(end) = 20;


Time_a  = [0;Time_a];
data_t_d            = data_t_d(7:end,1:end);
distance_left_d     = abs(data_t_d(2:end,3)-data_t_d(2,4));
distance_right_d    = abs(data_t_d(2:end,4)-data_t_d(2,3));

distance_d  = (distance_right_d / 100);         % Distance in meters
time_d      = data_t_d(2:end,7);
velocity_d  = diff(distance_d)./diff(time_d);   % Derivative
velocity_d  = [velocity_d];
time_d      = [0;time_d];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% FIGURES %%%%%
figure
hold on
max_v = max(max(velocity_d), max(V));
ylim([0 max_v+0.5]);
xlim([0 3]);
plot(Afstand,V);
plot(distance_d(1:end-1),velocity_d);
legend('Acceleration','Deceleration');
xlabel('Distance in meters (m)');
ylabel('Velocity in meters per second (m/s)');

%%%%% CALCULATE INTERSECTION %%%%%

[i_d,i_v] = polyxpoly(Afstand,V,distance_d(1:end-1),velocity_d);
