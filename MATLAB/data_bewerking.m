clear all;
load ('data_f_2.mat') %inladen data meting acceleratie

%TODO
%Tijden van de testresultaten in de data matrix zetten, tijd vanaf 0 laten beginnen

%Acceleratie data
i=2;
while(i<size(data_t_a,1)) % incorrecte metingen weggooien
if(data_t_a(i,4)==999 && data_t_a(i,3) == 999)
data_t_a = [data_t_a(1:n-1,1:end); data_t_a(n+1:end,1:end)];
elseif(data_t_a(i,4)==999)
    data_t_a(i,4)=data_t_a(i,3);
elseif(data_t_a(i,3)==999)
    data_t_a(i,3)=data_t_a(i,4);   
end
i=i+1;
end

Afstand_links_a = abs(data_t_a(2:end,3)-data_t_a(2,4));%afstand van 0 laten lopen
Afstand_rechts_a = abs(data_t_a(2:end,4)-data_t_a(2,3));
    
Afstand = (Afstand_rechts_a /10);%Afstand in meters

Time_a = data_t_a(2:end,7); %tijd vanaf zelfde moment metingen

V = diff(Afstand)./diff(Time_a); %afgeleide
V = [0;V];
Time_a = [0;Time_a];
plot(Time_a(1:end-1),V)%velocity plot.

%TODO
%Deceleratie moet er nog bij
%Aan de hand van de acceleratie en deceleratie curves intersect punt
%bepalen en de tijd van dit punt teruggeven

