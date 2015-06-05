function t = steering_timer(t_a) %Timer functie met speed, direction en tijden

t = timer;
t.TimerFcn = @timer_timerFcn;
t.StartFcn = @(~,~)timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.StartDelay = t_a;
t.TasksToExecute = 1;
t.ExecutionMode = 'fixedRate';
t.ErrorFcn = @(~,~)timer_error;

    function timer_startFcn
        disp('Start');
        tic;
        drive(155,100);
    end

    function timer_timerFcn(timerObj, timerEvent)
        global metingen
        global position
            disp('stop');
            metingen(position, 3) = toc;
            drive(150, 153)
            metingen(position, 4) = toc;
    end
    function timer_error
        disp('Error');
        drive(150, 153);
    end

    function timer_stopFcn(timerObj, timerEvent)
        disp('Timer is gestopt.');
        global metingen
        global position
        metingen(position, 7) = metingen(position, 5) - metingen(position, 3);
        delete(timerObj);
    end
end