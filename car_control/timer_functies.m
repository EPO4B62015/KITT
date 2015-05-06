function t = timer_functies(t_a, t_d)
global time

t = timer;
t.TimerFcn = @timer_timerFcn;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = t_a;
t.Period = t_d;
t.TasksToExecute = 2;
t.ExecutionMode = 'fixedRate';
time = zeros(2,1);

function timer_startFcn
disp('Start');
%drive start
tic


function timer_timerFcn(timerObj, timerEvent)
global time
if(timerObj.TasksExecuted == 1)
    disp('Eerste keer');
    %drive rem
    time(1) = toc
elseif(timerObj.TasksExecuted == 2)
    disp('Tweede keer');
    %drive stilstaan
    disp(timerEvent.Data);
    time(2) = toc
else
    disp('Error');
end

function timer_stopFcn(timerObj, timerEvent)
disp('Timer is gestopt');
delete(timerObj);