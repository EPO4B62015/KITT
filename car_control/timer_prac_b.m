function t = timer_prac_b %Timer functie met een acceleratie tijd en een remtijd
global time
clear distances_data
distances_data1(1:2) = 999;
distances_data2(1:2) = 999;

i = 1; %TEST variable

t = timer;
t.TimerFcn = @timer_getFirstValues;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = 0;
t.Period = 0.01;
t.ExecutionMode = 'fixedRate';
t_start = 0;

function timer_startFcn
disp('Start');
t_start = tic %Tijd start.
end


function timer_getFirstValues(timerObj, timerEvent)
    %De snelheid bepalen van de auto aan de hand van twee meetpunten
    
    distances_data1 = datavoer(i)%data_distance(t_start);
    i = i+1 
    if(distances_data1(1) ~= 999 && distances_data1(2) ~= 999)
        %Tweede meting, als deze niet goed is. Opnieuw 2 metingen doen (dus Timer_getFirstValues wordt opnieuw aangeroepen).
        
        distances_data2 = datavoer(i)%data_distance(t_start);
        i = i+1
        if(distances_data2(1) ~= 999 && distances_data2(2) ~= 999)
            timerObj.TimerFcn = @timer_updateSpeed;
        end    
    end
end
    
function timer_updateSpeed(timerObj, timerEvent)
    %Afstanden die de twee sensoren detecteren
    distance_l = distances_data1(1)-distances_data2(1)
    distance_r = distances_data1(2)-distances_data2(2)
    
    %De tijd bepalen waarin die afstand wordt afgelegd
    tijd_metingen = distances_data2(3)-distances_data1(3);
    
    %De snelheid berekenen van de 2 metingen in m/s 
    v_l = (distance_l/100) / tijd_metingen
    v_r = (distance_r/100) / tijd_metingen
    
    stop(timerObj);
%     %v doorpassen naar de goede fuctie
%     %terug krijgen van een remtijd en remweg
%     %mogelijk nog wat anders.
%     %tijd berekenen tot starten remmen
%     t_tot_remmen = (linker_afstand2 - afstand_muur) / v;
%     %als genoeg tijd voor nieuwe meting, die uitvoeren
%     %anders wachten tot remtijd
%     if(t_tot_remmen < 0.2)
%         %nieuwe timer aanmaken
%         %timerfuncties ombouwen
%         %nieuwe timer starten, deze stoppen
%         
%         stop(timerObj)
%     end
end
    
function timer_stopFcn(timerObj, timerEvent)
    disp('Timer is gestopt');
    delete(timerObj);
end
end
