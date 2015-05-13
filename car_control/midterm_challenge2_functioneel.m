%Deze is getest op dinsdag 12-5
%En werk redelijk
%Challenge 5 meter
function t = midterm_challenge2(stop_afstand) %Timer functie met een acceleratie tijd en een remtijd

clear distances_data
distances_data1(1:2) = 999;
distances_data2(1:2) = 999;
rem_afstand = 0;
v_l = 0;
v_r = 0;
v_gem = 0;
data_rem(1) = 0;
data_rem(2) = 0;
data_rem(3) = 0;
rem_afstand = 0;
read_distance = 0;
rem_tijd = 0;
global metingen
metingen = zeros(100, 17);
global keeper;
keeper = 1;
keeper2 = 1;

i = 1; %TEST variable
t_delay = 0.120; %De delay is ongeveer 120 ms.

t = timer;
t.TimerFcn = @timer_getFirstValues;
t.StartFcn = @timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.ErrorFcn = @(~,~)timer_error;
t.StartDelay = 0;
t.Period = 0.01;
t.ExecutionMode = 'fixedRate';
t_start = 0;

    function timer_startFcn(timerObj, timerEvent)
        disp('Start');
        t_start = tic %Tijd start.
        status = drive(165, 153);
        if(strcmp(status, ''))
            stop(timerObj);
        end
        
    end


    function timer_getFirstValues(timerObj, timerEvent)
        if(keeper2 == 1)
            %De snelheid bepalen van de auto aan de hand van twee meetpunten
            distances_data1 = data_distance(t_start);
            metingen(keeper, 1) = distances_data1(1);
            metingen(keeper, 2) = distances_data1(2);
            metingen(keeper, 3) = distances_data1(3);
            if(distances_data1(1) ~= 999 && distances_data1(2) ~= 999)
                %Tweede meting, als deze niet goed is. Opnieuw 2 metingen doen
                %(dus Timer_getFirstValues wordt opnieuw aangeroepen).
                
                distances_data2 = data_distance(t_start);
                
                if(distances_data2(1) ~= 999 && distances_data2(2) ~= 999)
                    
                    %Als een eerdere distance kleiner is is dit een foutieve meting
                    if(distances_data1(1) > distances_data2(1) && distances_data1(2) > distances_data2(2))
                        
                        metingen(keeper, 4) = distances_data2(1);
                        metingen(keeper, 5) = distances_data2(2);
                        metingen(keeper, 6) = distances_data2(3);
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
                        rem_afstand = stop_afstand + data_rem(3) * 100;
                        
                        %Afstand die het uitlezen maximaal duurt
                        read_distance = t_delay * v_gem * 100;
                        metingen(keeper, 7) = v_l;
                        metingen(keeper, 8) = v_r;
                        metingen(keeper, 9) = v_gem;
                        metingen(keeper, 10) = data_rem(1);
                        metingen(keeper, 11) = data_rem(2);
                        metingen(keeper, 12) = data_rem(3);
                        metingen(keeper, 13) = rem_afstand;
                        metingen(keeper, 14) = read_distance;
                        %Als de snelheid bepaald is de snelheid updaten en
                        %bijhouden wanneer er geremd gaat worden
                        disp('TimerFcn aanpassen');
                        %timerObj.TimerFcn = @timer_remmen;
                        keeper2 = 2;
                        disp('TimerFcn aangepast');
                    end
                end
            end
            keeper = keeper + 1;
        else
            disp('Timer_remmen gestart');
            %Sensoren uitblijven lezen om te bepalen wanneer de auto moet gaan remmen
            %Als de sensoren een waarde zien die in de buurt van de remafstand
            %ligt moet er gestopt worden met uitlezen. Er zal dan een timer
            %worden gestart om het precieze rempunt te bepalen.
            
            %Als er een afstand gemeten wordt die binnen 2 delays ligt. Stoppen
            %met uitlezen en de timer starten voor het remmen.
            
            stop_reading_distance = rem_afstand + 4 * read_distance; %Op 1,5 delay in distance stoppen met lezen
            metingen(keeper, 15) = stop_reading_distance;
            distances = data_distance(t_start);
            
            if(distances(1) < stop_reading_distance || distances(2) < stop_reading_distance)
                %Pauseren voor het remmen. Eventueel nog delays meenemen in
                %tijden
                
                time_till_break = ((((distances(1)+distances(2))/2)-rem_afstand)/100)/v_gem - 0.45;
                metingen(keeper, 16) = time_till_break;
                t_tic = tic;
                pause(time_till_break) %Halve delay eraf halen om daadwerkelijk op tijd te remmen
                metingen(keeper - 1, 17) = toc(t_tic);
                drive(135,153);
                metingen(keeper, 17) = toc(t_tic);
                pause(rem_tijd);
                drive(150,153);
                
                metingen(keeper+1, 6) = toc(t_start);
                distances = data_distance(t_start);
                metingen(keeper + 3, 1) = distances(1);
                metingen(keeper + 3, 2) = distances(2);
                metingen(keeper + 3, 3) = distances(3);
                stop(timerObj);
                return;
            end
            
            if(distances(1) ~= 999 && distances(2) ~= 999)
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
                rem_afstand = stop_afstand + data_rem(3) * 100;%afstand tot muur
                
                %Afstand die het uitlezen maximaal duurt
                read_distance = t_delay * v_gem * 100;
                metingen(keeper, 1) = distances_data1(1);
                metingen(keeper, 2) = distances_data1(2);
                metingen(keeper, 3) = distances_data1(3);
                metingen(keeper, 4) = distances_data2(1);
                metingen(keeper, 5) = distances_data2(2);
                metingen(keeper, 6) = distances_data2(3);
                metingen(keeper, 7) = v_l;
                metingen(keeper, 8) = v_r;
                metingen(keeper, 9) = v_gem;
                metingen(keeper, 10) = data_rem(1);
                metingen(keeper, 11) = data_rem(2);
                metingen(keeper, 12) = data_rem(3);
                metingen(keeper, 13) = rem_afstand;
                metingen(keeper, 14) = read_distance;
                keeper = keeper + 1;
            end
        end
    end

    function timer_remmen(timerObj, timerEvent)
        disp('Timer_remmen gestart');
        %Sensoren uitblijven lezen om te bepalen wanneer de auto moet gaan remmen
        %Als de sensoren een waarde zien die in de buurt van de remafstand
        %ligt moet er gestopt worden met uitlezen. Er zal dan een timer
        %worden gestart om het precieze rempunt te bepalen.
        
        %Als er een afstand gemeten wordt die binnen 2 delays ligt. Stoppen
        %met uitlezen en de timer starten voor het remmen.
        
        stop_reading_distance = rem_afstand + 1.5 * read_distance; %Op 1,5 delay in distance stoppen met lezen
        metingen(keeper, 15) = stop_reading_distance;
        distances = data_distance(t_start);
        
        if(distances(1) < stop_reading_distance || distances(2) < stop_reading_distance)
            %Pauseren voor het remmen. Eventueel nog delays meenemen in
            %tijden
            time_till_break = (((distances(1)+distances(2))/2)-rem_afstand)/v_gem;
            metingen(keeper, 16) = time_till_break;
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
            rem_afstand = stop_afstand + data_rem(3) * 100;%afstand tot muur
            
            %Afstand die het uitlezen maximaal duurt
            read_distance = t_delay * v_gem * 100;
            metingen(keeper, 1) = distances_data1(1);
            metingen(keeper, 2) = distances_data1(2);
            metingen(keeper, 3) = distances_data1(3);
            metingen(keeper, 4) = distances_data2(1);
            metingen(keeper, 5) = distances_data2(2);
            metingen(keeper, 6) = distances_data2(3);
            metingen(keeper, 7) = v_l;
            metingen(keeper, 8) = v_r;
            metingen(keeper, 9) = v_gem;
            metingen(keeper, 10) = data_rem(1);
            metingen(keeper, 11) = data_rem(2);
            metingen(keeper, 12) = data_rem(3);
            metingen(keeper, 13) = rem_afstand;
            metingen(keeper, 14) = read_distance;
            keeper = keeper + 1;
        end
        
    end

    function timer_stopFcn(timerObj, timerEvent)
        disp('Timer is gestopt');
        delete(timerObj);
    end
    function timer_error
        disp('Error');
        drive(150, 150);
    end
end
