%Controle loop voor assigment B
%2 loops: 1 met snelheid on the flow, de ander met constante snelheid
%deceleratie curves

succesen = 0;
linker_afstand1 = 999
rechter_afstand1 = 999
linker_afstand2 = 999
rechter_afstand2 = 999
%Snelheid bepalen aan de hand van 2 metingen

    while(1)
        %De afstand blijven bepalen zolang er geen enkele waarde gevonden is
        while(linker_afstand1 == 999 && rechter_afstand1 == 999)
        t_eerste_meetpunt = tic %Kan dit? is niet echt van belang
        status = EPOCommunications('transmit', 'S');
        
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
             break;
        end

    end

%Gevonden snelheid doorgeven aan intersect curves.
%Aan de hand van die remweg/tijd bepalen waar te remmen. Dan timer laten
%lopen en op tijd stoppen.

%intersect_curves
