%Challenge 5 meter
function t = control_loop() %Timer functie met een acceleratie tijd en een remtijd

global position
global voltage
global car  % need this don't delete
global static_positions
global test_data

pass_factor = 0;

test_data.pass = 0;
test_data.TDOA = [0;0;0;0;0;0;0;0;0;0];
test_data.measured = zeros(1,12000,5);
test_data.dtheta = 0;
test_data.cartime = 0;
static_positions.origin = [0;0;0]; %start position
static_positions.destination = [0;0;0];
static_positions.waypoint = [0;0;0];
static_positions.mic_positions = [0 0 30; 413 0 30; 413 210 30; 0 210 30; 173 0 77];

position = static_positions.origin; %Postion in centimeters

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
        disp('Started - Load figure');
        EPO4figure; %Load the figure
        EPO4figure.setMicLoc(static_positions.mic_position/100) %Update Mic Positions
        EPO4figure.setDestination(static_positions.destination/100);
        
        %EPO4figure.setWayPoint(static_positions.waypoint/100); %Only add
        %to map if there is a waypoint
    end


    function timer_loop(timerObj, timerEvent)
        switch(state)
            case States.VoltageMeasure
                disp('Measuring Voltage')
                measure_voltage;
                if(voltage.done == true)
                    state = States.Straight;
                end
            case States.Drive %Example, states and flow can be altered.
                disp('Driving straight');
                %Status request
                %Planner
                [car.time, car.steer, car.speed] = planner(static_positions.destination);
                test_data.cartime = [test_data.cartime, car.time];
                drive_car(car.speed, car.steer, car.time);
                state = States.Sample_straight;
                
            case States.Sample
                disp('Sampling after straight');
                %Sample
                %TDOA
                TDOA_data = TDOA;
                test_data.TDOA = [test_data.TDOA ;TDOA_data];
                %Localize
                if(car.did_turn == true)
                    pass = localize_5ch(TDOA_data, 200, car.d_theta);
                    Orientation;
                    test_data.pass = [test_data.pass; pass];
                else
                    pass = localize_5ch(TDOA_data, 50, 0);%Misschien de expected distance nog aanpassen
                    Orientation
                    test_data.pass = [test_data.pass; pass];
                end
                
                if(pass == 1)
                    EPO4figure.setKITT([position(1,end)/100 position(2,end)/100]); %Update car position
                    state = States.Drive;
                else
                    state = States.Sample;
                end
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

