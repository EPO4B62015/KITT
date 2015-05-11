%Challenge bestaat uit:
%Op een voor bepaalde afstand laten stoppen, deze afstand is tussen de 30
%en 50 cm van een muur.
%De auto start op een afstand tussen de 3 en 4 meter.
%Dit alles moet binnen 3 seconden gebeuren.

%TODO
%Timer initialiseren
%Auto laten rijden
%Status opvragen -> Snelheid bepalen
%Snelheid blijven updaten
%Als de auto op de juiste afstand van de muur is, de auto laten remmen en stoppen.



function t = midterm_challenge(stop_afstand) %Timer functie met een acceleratie tijd en een remtijd
global time
clear distances_data
distances_data1(1:2) = 999;
distances_data2(1:2) = 999;

t_delay = 0.180; %De maximale delay is 180 ms.

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
        %nader_te_bepalen_functie(tijd, nog_af_te_leggen_afstand);
        
        distances_data1 = datavoer(i)%data_distance(t_start);
        
        %Nieuwe meting, als deze niet goed is. 
        if(distances_data1(1) ~= 999 && distances_data1(2) ~= 999)
            %Als meting wel goed is dan:
            %Afgelegde afstand opvragen van afstand/tijd plot
            %Daarna de totale af te leggen afstand berekenen
            %Invoeren bij prac A, remtijd en acceleratie tijd terugkrijgen
            %Op basis daarvan tijd berekenen die je nog moet accelereren
            %Daarna rem commando sturen.
            
            Afstand_afgelegd = afstand_tijd(distances_data1(3));%Afstand_tijd functie moet nog komen
            tot_afstand = (distances_data1(1) + distances_data1(2))/2 - stop_afstand + Afstand_afgelegd; %Afgelegde weg + nog af te leggen weg
            %Deze invoeren in prac A
            %Intersect curves, of lookup daarvan aanroepen om de verwachte
            %acctijd emtijd te bepalen
            [acctijd, remtijd] = intersect_curves(tot_afstand);
            
            nog_te_accelereren_tijd = acctijd - distances_data1(3);
            
            %Als die klaar is met accelereren starten met remmen
            %Als de nog te accelereren tijd binnen een delay zou gaan
            %vallen. Dan stoppen met uitlezen van sensoren en timer starten voor het
            %remmen.
            
            
        end
    end

    function timer_remmen(timerObj, timerEvent)
        
        %Sensoren uitblijven lezen om te bepalen wanneer de auto moet gaan remmen
        %Als de sensoren een waarde zien die in de buurt van de remafstand
        %ligt moet er gestopt worden met uitlezen. Er zal dan een timer
        %worden gestart om het precieze rempunt te bepalen.
        
        %Als er een afstand gemeten wordt die binnen 2 delays ligt. Stoppen
        %met uitlezen en de timer starten voor het remmen.
        
        stop_reading_distance = rem_afstand + 2*read_distance;
        distances = data_distance;
        
        if(distances(1)<stop_reading_distance || distances(2)<stop_reading_distance)
            %Pauseren voor het remmen. Eventueel nog delays meenemen in
            %tijden.
            time_till_break = ((distances(1)+distances(2))/2)-remafstand)/v_gem;
            pause(time_till_break)
            drive(135,153);
            pause(rem_tijd);
            drive(150,153);
            stop(timerObj);
        end
        
        function timer_stopFcn(timerObj, timerEvent)
            disp('Timer is gestopt');
            delete(timerObj);
        end
    end
end