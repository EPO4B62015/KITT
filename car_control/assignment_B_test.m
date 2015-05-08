%Remstuk
%V is bekend, van te voren bepaald.

distances_data(1:2) = 999
i = 1
V_opsnelheid = 1.2;%Wat is V_max met speed setting 165 bijv.
%[info2, info] = intersect_time_velocity(V_opsnelheid);

rem_tijd = info(2);
rem_weg = info(3);

%De plek waarop te remmen berekenen
%Remmen op bijv 50 cm van de muur
Stop_afstand = 0.5;
Rem_afstand = Stop_afstand + rem_weg;

%%%%%Start met rijden
drive(158, 153)

while(1)
    %Distance op blijven vragen.
distances_data = data_distance(distances_data);
if(distances_data(i,2) <= Rem_afstand*100 + 30)
   drive(135,153);
   pause(rem_tijd);
   drive(150,153);
   break;
end
i = i+1;
end

%Zodra er een distance gevonden is. Bepalen wanneer te remmen.
