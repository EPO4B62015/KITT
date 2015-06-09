%Challenge 5 meter
function t = control_loop() %Timer functie met een acceleratie tijd en een remtijd

global position
global voltage
global car  % need this don't delete
global static_positions
global test_data

static_positions.origin = [0;0;0];
static_positions.destination = [0;0;0];
static_positions.waypoint = [0;0;0];

position = static_positions.origin;%start position

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
        EPO4figure; %Load the figure
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
                [car.time, car.steer, car.speed] = planner(static_positions.destination);
                
                drive_car(car.speed, car.steer, car.time);
                state = States.Sample_straight;
                
            case States.Corner
                disp('Cornering')
                drive_car(car.speed, car.steer, car.time);
                
            case States.Sample_straight
                disp('Sampling after straight');
                %Sample
                %TDOA
                TDOA_data = TDOA;
                %Localize
                pass = localize_5ch(TDOA_data, expected_distance, expected_angle);
                EPO4figure.settKITT([position(1,end) position(2,end)]);
                if(pass == 1)
                    state = States.Straight;
                else
                    state = States.Sample_straight;
                end
                
            case States.Sample_corner
                disp('Sampling after corner');
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

