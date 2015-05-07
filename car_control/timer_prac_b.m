function t = timer_test %Timer functie met een acceleratie tijd en een remtijd
global time

t = timer;
t.TimerFcn = @timer_timerFcn;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = 0;
t.Period = 0;

t.ExecutionMode = 'fixedRate';
time = zeros(2,1);
linker_afstand1 = 999
rechter_afstand1 = 999
linker_afstand2 = 999
rechter_afstand2 = 999


function timer_startFcn
disp('Start');
%drive start
tic


function timer_timerFcn(timerObj, timerEvent)
        %De afstand blijven bepalen zolang er geen enkele waarde gevonden is
     
        %Eventueel nog filteren op rare waardes, je verwacht dat de
        %sensoren rond 3 meter iets gaan detecteren.
        while(linker_afstand1 == 999 && rechter_afstand1 == 999)
        t_eerste_meetpunt = tic %Kan dit? is niet echt van belang
        %status = EPOCommunications('transmit', 'S');
        
        linker_afstand1 = status%(....)
        rechter_afstand1 = status%(....) %Hoe uit status te lezen?
        end
 
        %Tweede meetpunt bepalen. Als dit niet goed is weer helemaal
        %opnieuw
        status = EPOCommunications('transmit', 'S');
        t_tweede_meetpunt = toc
        linker_afstand2 = status%uitlezen uit status
        rechter_afstand2 = status%uitlezen uit status
        
        %Als ook van deze meting een geldige waarde gevonden is snelheid
        %bepalen en while loop afbreken, anders opnieuw beginnen
        if(linker_afstand2 ~= 999 || rechter_afstand2 ~= 999)
            %Afhankelijk van welke sensoren een juiste afstand hebben de
            %snelheid bepalen
            
            if (linker_afstand1 ~= 999 && rechter_afstand1 ~= 999 && linker_afstand2 ~= 999 && rechter_afstand2 ~= 999 ) 
                v = (((linker_afstand1 + rechter_afstand1)/2) -  ((linker_afstand2 +_rechter_afstand2)/2))/t_tweede_meetpunt
            %Handige manier bedenken om die snelheid te bepalen. 
            
            break; %While loop afsluiten.
            end

            
        end
end

function timer_getFirstValues(timerObj, timerEvent)
    t_eerste_meetpunt = tic %Kan dit? is niet echt van belang
    %status = EPOCommunications('transmit', 'S');
    linker_afstand1 = 0;%status%(....)
    rechter_afstand1 = 0;%status%(....) %Hoe uit status te lezen?
    if(linker_afstand1 ~= 999 && rechter_afstand1 ~= 999)
        %get second Values
        t_tweede_meting = toc;%dit kan denk ik niet zo
        %status = EPOCommunications('transmit', 'S');
        linker_afstand2 = 0;%status%(....)
        rechter_afstand2 = 0;%status%(....) %Hoe uit status te lezen?
        timerObj.TimerFcn = @timer_updateSpeed;
    end
    
function timer_updateSpeed(timerObj, timerEvent)
    distance_l = linker_afstand1 - linker_afstand2
    distance_r = rechter_afstand1 - rechter_afstand2
    %Tijd berekenen tussen 2 metingen
    
    v_l = distance_l / tijd;
    v_r = distance_r / tijd;
    
    %v doorpassen naar de goede fuctie
    %terug krijgen van een remtijd en remweg
    %mogelijk nog wat anders.
    %tijd berekenen tot starten remmen
    t_tot_remmen = (linker_afstand2 - afstand_muur) / v;
    %als genoeg tijd voor nieuwe meting, die uitvoeren
    %anders wachten tot remtijd
    if(t_tot_remmen < 0.2)
        %nieuwe timer aanmaken
        %timerfuncties ombouwen
        %nieuwe timer starten, deze stoppen
        
        stop(timerObj)
    end
    
function timer_stopFcn(timerObj, timerEvent)
disp('Timer is gestopt');
delete(timerObj);