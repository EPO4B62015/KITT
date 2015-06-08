%Challenge 5 meter
function t = control_loop() %Timer functie met een acceleratie tijd en een remtijd

global position
global voltage
position = [0; 0; 0];%start position

state = States.Straight;
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
                disp('Measuring Voltage')
                measure_voltage;
                if(voltage.done == true)
                    state = States.Straight;
                end
            case States.Straight%Example, states and flow can be altered.
                disp('Driving straight');
                %Planner
                %drive car
                state = States.Sample_straight;
                
            case States.Corner
                disp('Cornering')
            case States.Sample_straight
                disp('Sampleing after straight');
                %Sample
                %TDOA
                TDOA_data = TDOA;
                %Localize
                pass = localize_5ch(TDOA_data);
                if(pass == 1)
                    state = States.Straight;
                else
                    state = States.Sample_straight;
                end
                
            case States.Sample_corner
                disp('Sampleing after corner');
        end
    end

    function timer_stopFcn(timerObj, timerEvent)
        disp('Timer is gestopt');
        delete(timerObj);
    end
    function timer_error
        disp('Error');
        %drive(150, 150);
    end
end

