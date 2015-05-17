%Controle loop voor assigment B
%2 loops: 1 met snelheid on the flow, de ander met constante snelheid
%deceleratie curves

%Snelheid bepalen aan de hand van 2 metingen

    while(1)
        %De afstand blijven bepalen zolang er geen enkele waarde gevonden is
        linker_afstand1 = 999
        rechter_afstand1 = 999
        linker_afstand2 = 999
        rechter_afstand2 = 999
        
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

%Gevonden snelheid doorgeven aan intersect curves.
%Aan de hand van die remweg/tijd bepalen waar te remmen. Dan timer laten
%lopen en op tijd stoppen.

%intersect_curves
