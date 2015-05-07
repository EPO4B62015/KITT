function t = timer_test(parent1) %Timer functie met een acceleratie tijd en een remtijd
global time
abort = parent1
t = timer;
t.TimerFcn = @timer_timerFcn;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = 0;

t.ExecutionMode = 'fixedRate';
time = zeros(2,1);

function timer_startFcn
disp('Start');
%drive start
tic
end

function timer_timerFcn(timerObj, timerEvent)
toc
pause(2);
if(abort.Value == 1)
    stop(timerObj)
end
end

function timer_stopFcn(timerObj, timerEvent)
disp('Timer is gestopt');
delete(timerObj);
end
end