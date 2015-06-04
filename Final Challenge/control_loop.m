%Challenge 5 meter
function t = midterm_challenge2(stop_afstand) %Timer functie met een acceleratie tijd en een remtijd


state = States.VoltageMeasure;
t = timer;
t.TimerFcn = @timer_loop;
t.StartFcn = @timer_startFcn;
t.StopFcn = @timer_stopFcn;
t.ErrorFcn = @(~,~)timer_error;
t.StartDelay = 0;
t.Period = 0.01;
t.ExecutionMode = 'fixedRate';


    function timer_startFcn(timerObj, timerEvent)
        disp('Started');
    end


    function timer_loop(timerObj, timerEvent)
        switch(state)
            case States.VoltageMeasure
                disp('Voltage measuring')
                if(voltage > 17)%Example
                    state = States.Straight;
                end
            case States.Straight%Example, states and flow can be altered.
                disp('Immer gerade aus');
            case States.Corner
                disp('Cornering')
        end
    end

    function timer_stopFcn(timerObj, timerEvent)
        disp('Timer is gestopt');
        delete(timerObj);
    end
    function timer_error
        disp('Error');
        drive(150, 150);
    end
end

