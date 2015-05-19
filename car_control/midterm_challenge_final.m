%Midterm Challenge
function t = midterm_challenge(stop_afstand) %Timer function for midterm challenge

SPEED_SETTING = 165; %Speed setting at which to drive
STEER_SETTING = 153; %Steering correction to drive straight
T_TILL_BRAKE_DELAY = 0.45; %Time correction for braking
READ_DISTANCE_MULTIPLIER = 4; %Multiplier to stop requesting updates.
Shorten_brake = 0.08; %Correction for the lookup

%Initialisation and debug variables
distances_data1(1:2) = 999;
distances_data2(1:2) = 999;
distances(1:2) = 999;
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
        status = drive(SPEED_SETTING, STEER_SETTING);
        if(strcmp(status, ''))
            stop(timerObj);
        end
        
    end


    function timer_getFirstValues(timerObj, timerEvent)
        %Zolang de auto nog buiten bereik is de sensoren uit blijven lezen.
        if(keeper2 == 1)
            %De snelheid bepalen van de auto aan de hand van twee meetpunten
            distances_data2 = data_distance(t_start);
            metingen(keeper, 1) = distances_data2(1);
            metingen(keeper, 2) = distances_data2(2);
            metingen(keeper, 3) = distances_data2(3);
            if(distances_data2(1) ~= 999 && distances_data2(2) ~= 999)
                %Tweede meting, als deze niet goed is. Opnieuw 2 metingen doen
                %(dus Timer_getFirstValues wordt opnieuw aangeroepen).
                
                distances = data_distance(t_start);
                
                if(distances(1) ~= 999 && distances(2) ~= 999)
                    
                    %Als een eerdere distance kleiner is is dit een foutieve meting
                    if(distances_data2(1) > distances(1) && distances_data2(2) > distances(2))
                        %Als er 2 succesvolle metingen gedaan zijn doorgaan
                        %met het bepalen van de snelheid
                        keeper2 = 2;
                    end
                end
            end
            keeper = keeper + 1;
        else
            %Sensoren uitblijven lezen om te bepalen wanneer de auto moet gaan remmen
            %Als de sensoren een waarde zien die in de buurt van de remafstand
            %ligt moet er gestopt worden met uitlezen. Er zal dan een timer
            %worden gestart om het precieze rempunt te bepalen.
            
            %Als er een afstand gemeten wordt die binnen 2 delays ligt. Stoppen
            %met uitlezen en de timer starten voor het remmen.
            
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
                if(v_l > 3)
                    v_l = 3;
                elseif(v_l < 0)
                    v_l = 1.800003;
                end
                v_r = (distance_r/100) / tijd_metingen;
                if(v_r > 3)
                    v_r = 3;
                elseif(v_r < 0)
                    v_r = 1.800003;
                end
                
                %Om uitschieters te beperken bepalen we de gemiddelde snelheid van
                %de 2 sensoren.
                v_gem = (v_r+v_l)/2;
                
                if(v_l - v_r > 0.5 || v_r - v_l > 0.5)
                    if(v_l == 3 || v_l == 1.800003)
                        v_gem = v_r;
                    elseif(v_r == 3 || v_r == 1.800003)
                        v_gem = v_l;
                    end
                end
                
                [data_uitrol, data_rem] = velocity_lookup(v_gem);
                
                rem_tijd = data_rem(2) - Shorten_brake ;
                
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
                
                
                stop_reading_distance = rem_afstand + READ_DISTANCE_MULTIPLIER * read_distance; %Op 1,5 delay in distance stoppen met lezen
                metingen(keeper, 15) = stop_reading_distance;
                
                if(distances(1) < stop_reading_distance || distances(2) < stop_reading_distance)
                    %Pauseren voor het remmen. Eventueel nog delays meenemen in
                    %tijden
                    
                    time_till_break = ((((min(distances(1:2)))-rem_afstand)/100)/v_gem) - T_TILL_BRAKE_DELAY;
                    metingen(keeper, 16) = time_till_break;
                    t_tic = tic;
                    pause(time_till_break) %Halve delay eraf halen om daadwerkelijk op tijd te remmen
                    metingen(keeper - 1, 17) = toc(t_tic);
                    drive(135,STEER_SETTING);
                    metingen(keeper, 17) = toc(t_tic);
                    pause(rem_tijd);
                    drive(150,STEER_SETTING);
                    
                    metingen(keeper+1, 6) = toc(t_start);
                    distances = data_distance(t_start);
                    metingen(keeper + 3, 1) = distances(1);
                    metingen(keeper + 3, 2) = distances(2);
                    metingen(keeper + 3, 3) = distances(3);
                    stop(timerObj);
                    return;
                end
            end
            distances = data_distance(t_start);
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

% read_distance = t_delay * v_gem * 100;
% metingen(keeper, 1) = distances_data1(1);
% metingen(keeper, 2) = distances_data1(2);
% metingen(keeper, 3) = distances_data1(3);
% metingen(keeper, 4) = distances_data2(1);
% metingen(keeper, 5) = distances_data2(2);
% metingen(keeper, 6) = distances_data2(3);
% metingen(keeper, 7) = v_l;
% metingen(keeper, 8) = v_r;
% metingen(keeper, 9) = v_gem;
% metingen(keeper, 10) = data_rem(1);
% metingen(keeper, 11) = data_rem(2);
% metingen(keeper, 12) = data_rem(3);
% metingen(keeper, 13) = rem_afstand;
% metingen(keeper, 14) = read_distance;
% metingen(keeper, 15) = stop_reading_distance;
% metingen(keeper, 16) = time_till_break;
% metingen(keeper - 1, 17) = toc(t_tic); t_tic is voor time till break pause
% metingen(keeper, 17) = toc(t_tic);
% metingen(keeper + 3, 1) = distances(1); Op moment van stilstaan gemeten
% metingen(keeper + 3, 2) = distances(2);
% metingen(keeper + 3, 3) = distances(3);
