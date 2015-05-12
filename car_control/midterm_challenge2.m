%Midterm_challenge2 voor de 5 meter afstand.
function t = midterm_challenge2(stop_afstand)
clear distances_data
distances_data1(1:2) = 999;
distances_data2(1:2) = 999;

i = 1; %TEST variable
t_delay = 0.120; %De delay is ongeveer 120 ms.

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
        drive(165, 153);
    end


    function timer_getFirstValues(timerObj, timerEvent)
        %De snelheid bepalen van de auto aan de hand van twee meetpunten
        
        distances_data1 = data_distance(t_start);
        
        if(distances_data1(1) ~= 999 && distances_data1(2) ~= 999)
            %Tweede meting, als deze niet goed is. Opnieuw 2 metingen doen 
            %(dus Timer_getFirstValues wordt opnieuw aangeroepen).
            
            distances_data2 = data_distance(t_start);
            
            if(distances_data2(1) ~= 999 && distances_data2(2) ~= 999)
                
                %Als een eerdere distance kleiner is is dit een foutieve meting
                if(distances_data1(1) > distances_data2(1) && distances_data1(2) > distances_data2(2))
                                        
                    %Afstanden die de twee sensoren detecteren
                    distance_l = distances_data1(1)-distances_data2(1);
                    distance_r = distances_data1(2)-distances_data2(2);
                    
                    %De tijd bepalen waarin die afstand wordt afgelegd
                    tijd_metingen = distances_data2(3)-distances_data1(3);
                    
                    %De snelheid berekenen van de 2 metingen in m/s
                    v_l = (distance_l/100) / tijd_metingen;
                    v_r = (distance_r/100) / tijd_metingen;
                    %Om uitschieters te beperken bepalen we de gemiddelde snelheid van
                    %de 2 sensoren.
                    v_gem = (v_r+v_l)/2;
                    
                    [data_uitrol, data_rem] = velocity_lookup(v_gem)
                    
                    rem_tijd = data_rem(2);
                    
                    %Afstand waarop geremd moet gaan worden
                    rem_afstand = stop_afstand + data_rem(3)
                    
                    %Afstand die het uitlezen maximaal duurt
                    read_distance = t_delay * v_gem;
                    
                    %Als de snelheid bepaald is de snelheid updaten en
                    %bijhouden wanneer er geremd gaat worden
                    timerObj.TimerFcn = @timer_remmen;
                end
            end
        end
    end

    function timer_remmen(timerObj, timerEvent)
        
        %Sensoren uitblijven lezen om te bepalen wanneer de auto moet gaan remmen
        %Als de sensoren een waarde zien die in de buurt van de remafstand
        %ligt moet er gestopt worden met uitlezen. Er zal dan een timer
        %worden gestart om het precieze rempunt te bepalen.
        
        %Als er een afstand gemeten wordt die binnen 2 delays ligt. Stoppen
        %met uitlezen en de timer starten voor het remmen.
        
        stop_reading_distance = rem_afstand + 1.5 * read_distance; %Op 1,5 delay in distance stoppen met lezen
        distances = data_distance;
        
        if(distances(1) < stop_reading_distance || distances(2) < stop_reading_distance)
            %Pauseren voor het remmen. Eventueel nog delays meenemen in
            %tijden
            time_till_break = (((distances(1)+distances(2))/2)-remafstand)/v_gem;
            pause(time_till_break) %Halve delay eraf halen om daadwerkelijk op tijd te remmen
            drive(135,153);
            pause(rem_tijd);
            drive(150,153);
            stop(timerObj);
        end
        
        if(distances(1) ~= 999 || distances(2) ~= 999)
            %Als de auto dus nog niet binnen range was om te gaan remmen.
            %De distances updaten en opnieuw de snelheid bepalen aan de
            %hand van de nieuwe meting en de vorige.
            
            distances_data1 = distances_data2;
            distances_data2 = distances;
            %Afstanden die de twee sensoren detecteren
            distance_l = distances_data1(1)-distances_data2(1);
            distance_r = distances_data1(2)-distances_data2(2);
            
            %De tijd bepalen waarin die afstand wordt afgelegd
            tijd_metingen = distances_data2(3)-distances_data1(3);
            
            %De snelheid berekenen van de 2 metingen in m/s
            v_l = (distance_l/100) / tijd_metingen;
            v_r = (distance_r/100) / tijd_metingen;
            %Om uitschieters te beperken bepalen we de gemiddelde snelheid van
            %de 2 sensoren.
            v_gem = (v_r+v_l)/2;
            
            [data_uitrol, data_rem] = velocity_lookup(v_gem);
            
            rem_tijd = data_rem(2);
            
            %Afstand waarop geremd moet gaan worden
            rem_afstand = stop_afstand + data_rem(3);%afstand tot muur
            
            %Afstand die het uitlezen maximaal duurt
            read_distance = t_delay * v_gem;
        end
        
    end

    function timer_stopFcn(timerObj, timerEvent)
        disp('Timer is gestopt');
        delete(timerObj);
    end
end
