%Timer functies voor midterm challende vanaf 3 meter
function t = timer_functies(t_a, t_d) %Timer functie met een acceleratie tijd en een remtijd

t_delay = 0.090;
t = timer;
t.TimerFcn = @timer_timerFcn;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = t_a+t_delay;
t.Period = t_d; %t_d is zo gekozen zodat de auto nog niet stilstaat
t.ExecutionMode = 'fixedRate';


function timer_startFcn
disp('Start');
tic;
drive(165,153)


function timer_timerFcn(timerObj, timerEvent)
global metingen
global position
if(timerObj.TasksExecuted == 1)
    disp('Drive D153 135');
    metingen(position, 3) = toc;
    drive(135, 153)
    metingen(position, 4) = toc;
    
elseif(timerObj.TasksExecuted == 2)
    disp('Drive D153 150');
    metingen(position, 5) = toc;
    drive(153, 153) %Na het remmen rustig verder rijden
    metingen(position, 6) = toc;
    timerObj.TimerFcn = @timer_read_distance;
    timerObj.Period = 0.01;
else
    disp('Error');
end

function timer_read_distance(timerObj, timerEvent)
    %De distances uitblijven lezen en bepalen wanneer helemaal stil te
    %staan
    distances = data_distance(toc)
    distance_gem = ((distances(1)+distances(2))/2)
    if(distance_gem)<= (stopafstand+5)
        drive(150,153) %Stoppen met rijden
        stop(timerObj);
    end
end

function timer_stopFcn(timerObj, timerEvent)
disp('Timer is gestopt.');
global metingen
global position
metingen(position, 7) = metingen(position, 5) - metingen(position, 3);
delete(timerObj);