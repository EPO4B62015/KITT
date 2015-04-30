clear all;
load ('data_f_2.mat') %inladen data meting acceleratie

%Acceleratie data
i=2;
while(i<size(data_t_a,1)) % incorrecte metingen weggooien
if(data_t_a(i,4)==999 && data_t_a(i,3) == 999)
data_t_a = [data_t_a(1:i-1,1:end); data_t_a(i+1:end,1:end)];
elseif(data_t_a(i,4)==999)
    data_t_a(i,4)=data_t_a(i,3);
elseif(data_t_a(i,3)==999)
    data_t_a(i,3)=data_t_a(i,4);   
end
i=i+1;
end

Afstand_links_a     = abs(data_t_a(2:end,3)-data_t_a(2,4));%afstand van 0 laten lopen
Afstand_rechts_a    = abs(data_t_a(2:end,4)-data_t_a(2,3));
    
Afstand = (Afstand_rechts_a /10);%Afstand in meters

Time_a = data_t_a(2:end,7); %tijd vanaf zelfde moment metingen

V = diff(Afstand)./diff(Time_a); %afgeleide
V = [0;V];
Time_a = [0;Time_a];
hold on
%plot(Time_a(1:end-1),V)%velocity plot.
plot(Afstand,V);


%Deceleration
j=2;
while(j<size(data_t_d,1)) % remove incorrect measurements
    
    if(data_t_d(j,4) == 999 && data_t_d(j,3) == 999)
        data_t_d = [data_t_d(1:j-1,1:end); data_t_d(j+1:end,1:end)];
    elseif(data_t_d(j,4) == 999)
        data_t_d(j,4) = data_t_d(j,3);
    elseif(data_t_d(j,3) == 999)
        data_t_d(j,3) = data_t_d(j,4);   
    end
j=j+1;
end

distance_left_d = abs(data_t_d(2:end,3)-data_t_d(2,4));
distance_right_d = abs(data_t_d(2:end,4)-data_t_d(2,3));

distance_d = (distance_right_d / 10); % Distance in meters
time_d = data_t_d(2:end,7);
velocity_d = diff(distance_d)./diff(time_d); % Derivative
velocity_d = [0;velocity_d];
time_d = [0;time_d];

plot(distance_d,velocity_d);
%TODO
%Aan de hand van de acceleratie en deceleratie curves intersect punt
%bepalen en de tijd van dit punt teruggeven

