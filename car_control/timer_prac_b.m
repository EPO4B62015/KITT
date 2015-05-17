%Timer functie voor practical Assignment B

function t = timer_prac_b(stop_afstand) 

global time
global rem_afstand
global rem_tijd
global read_distance
global distances
global v_gem

clear distances_data
distances_data1(1:2) = 999;
distances_data2(1:2) = 999;

i = 1; %TEST variable
t_delay = 0.120; %De delay was gemiddeld 120 ms.

t = timer;
t.TimerFcn = @timer_getFirstValues;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = 0;
t.Period = 0.01;
t.ExecutionMode = 'fixedRate';
t_start = 0;
keeper = 1;

    function timer_startFcn
        disp('Start');
        t_start = tic; %Tijd start.
        drive(165,153);
    end


    function timer_getFirstValues(timerObj, timerEvent)
        %De snelheid bepalen van de auto aan de hand van twee meetpunten
        if(keeper == 1)
            distances_data1 = data_distance(t_start)%Timer_prac_b_testdata(i,1:end)
            i = i + 1;
            
            if(distances_data1(1) ~= 999 && distances_data1(2) ~= 999)
                %Tweede meting, als deze niet goed is. Opnieuw 2 metingen doen
                %(dus Timer_getFirstValues wordt opnieuw aangeroepen).
                
                distances_data2 = data_distance(t_start);%Timer_prac_b_testdata(i,1:end)%
                i = i + 1;
                
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
                        
                        [data_uitrol, data_rem] = velocity_lookup(v_gem);
                        
                        rem_tijd = data_rem(2)
                        
                        %Afstand waarop geremd moet gaan worden
                        rem_afstand = stop_afstand + data_rem(3)*100
                        
                        %Afstand die het uitlezen maximaal duurt
                        read_distance = t_delay * v_gem* 100;
                        
                        %Als de snelheid bepaald is de timer updaten en
                        %bijhouden wanneer er geremd gaat worden
                        keeper = 2;
                    end
                end
            end
        else if(keeper == 2)
                %Sensoren uitblijven lezen om te bepalen wanneer de auto moet gaan remmen
                %Als de sensoren een waarde zien die in de buurt van de remafstand
                %ligt moet er gestopt worden met uitlezen. Er zal dan een timer
                %worden gestart om het precieze rempunt te bepalen.
                
                %Als er een afstand gemeten wordt die binnen 2 delays ligt. Stoppen
                %met uitlezen en de timer starten voor het remmen.
                
                stop_reading_distance = rem_afstand + 2*read_distance
                distances = data_distance;%Timer_prac_b_testdata(i,1:end)
                i = i + 1;
                
                if(distances(1)<stop_reading_distance || distances(2)<stop_reading_distance)
                    %Pauseren voor het remmen. Eventueel nog delays meenemen in
                    %tijden
                    time_till_break = ((((distances(1)+distances(2))/2)-rem_afstand)/100)/v_gem-t_delay 
                    pause(time_till_break)
                    drive(135,153);
                    pause(rem_tijd);
                    drive(150,153);
                    stop(timerObj);
                    return;
                end   
            end     
        end
            
        function timer_stopFcn(timerObj, timerEvent)
            disp('Timer is gestopt');
            delete(timerObj);
        end
    end
end
