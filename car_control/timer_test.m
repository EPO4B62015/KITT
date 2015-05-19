function t = timer_test() %Timer functie met een acceleratie tijd en een remtijd

t = timer;
t.TimerFcn = @timer_timerFcn;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.ErrorFcn = @(~,~)timer_timerFcn2
t.StartDelay = 0;
t.Period = 0.100;
t.ExecutionMode = 'fixedRate';
time = zeros(2,1);

    function timer_startFcn
        disp('Start');
        %drive start
        tic
    end

    function timer_timerFcn(timerObj, timerEvent)
        disp('Timer functie');
       
    end

    function timer_timerFcn2
        disp('Timer functie 2');
        disp('Error');
       
    end

    function timer_stopFcn(timerObj, timerEvent)
        disp('Timer is gestopt');
        delete(timerObj);
    end
end