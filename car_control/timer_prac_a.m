%Timer functies voor assignment A
function t = timer_functies(t_a, t_d) %Timer functie met een acceleratie tijd en een remtijd

t_delay = 0.150;
t = timer;
t.TimerFcn = @timer_timerFcn;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = t_a+t_delay;
t.Period = t_d;
t.TasksToExecute = 2;
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
    drive(150, 153)
    metingen(position, 6) = toc;
else
    disp('Error');
end

function timer_stopFcn(timerObj, timerEvent)
disp('Timer is gestopt.');
global metingen
global position
metingen(position, 7) = metingen(position, 5) - metingen(position, 3);
delete(timerObj);