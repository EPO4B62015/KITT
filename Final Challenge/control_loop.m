function t = control_loop() %Timer functie met een acceleratie tijd en een remtijd

global position
global voltage
global car  % need this don't delete
global static_positions
global test_data

fail_factor = 0;
drive_counter = 0;
z_counter = 0;

test_data.pass = 0;
test_data.TDOA = [0;0;0;0;0;0;0;0;0;0];
test_data.measured = zeros(1,12000,5);
test_data.dtheta = 0;
test_data.cartime = [0 0 0];
test_data.pos_tdoa = [0;0;0];
static_positions.origin = [1;1;90]; %start position
static_positions.destination = [1;1;0];
static_positions.waypoint = [1;1;0];
static_positions.point = 1; % need this in planner
[sound, Fs] = audioread('ObjectiveComplete.mp3');
player = audioplayer(sound,Fs);
if static_positions.waypoint == [0;0;0]
    static_positions.route = [static_positions.destination];
else
    static_positions.route = [static_positions.waypoint,static_positions.destination];
end
static_positions.mic_positions = [0 0 30; 600 0 30; 600 600 30; 0 600 30; 300 0 77];

car.did_turn = false;
car.did_last_turn = false;
car.steer_straight = 150;
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
        EPO4figure.setMicLoc(static_positions.mic_positions/100) %Update Mic Positions
        EPO4figure.setDestination(static_positions.destination/100);
        EPO4figure.setKITT([position(1,end)/100 position(2,end)/100], 1); %Update car position
        if static_positions.waypoint == [0;0;0]
            disp('No waypoint');
        else
            EPO4figure.setWayPoint(static_positions.waypoint/100);
        end;
    end


    function timer_loop(timerObj, timerEvent)
        switch(state)
            case States.VoltageMeasure
                disp('Measuring Voltage')
                measure_voltage;
                if(voltage.done == true)
                    state = States.Drive;
                end
            case States.Drive %Example, states and flow can be altered.
                disp('Driving straight');
                fail_factor = 0;
                drive_counter = 0;
                %Status request
                status_update;
                %Planner
                [car.time, car.steer, car.speed] = planner;
                test_data.cartime = [test_data.cartime, car.time];
                if(car.status == 1)
                    %Car is at waypoint
                    play(player)
                elseif(car.status == 2)
                    %Car is at destination
                    play(player)
                    disp('At destination!')
                    
                end
                
                drive_car(car.speed, car.steer, car.time);
                state = States.Sample;
                
            case States.Sample
                disp('Sampling after straight');
                %Sample
                %TDOA
                TDOA_data = TDOA;
                disp('TDOA afgerond');
                test_data.TDOA = [test_data.TDOA ,TDOA_data];
                %Localize
                pass = localize_5ch(TDOA_data, (100 * car.time) + (12 * drive_counter));
                %pass = 1;
                test_data.pass = [test_data.pass; pass];
                
                if(pass == 1)
                    EPO4figure.setKITT([position(1,end)/100 position(2,end)/100], 0); %Update car position
                    state = States.Drive;
                    Orientation; %function without nonglobal arguments
                else
                    state = States.Sample;
                    fail_factor = fail_factor + 1;
                    if(fail_factor >= 3)
                        drive_counter = drive_counter + 1;
                        fail_factor = 0;
                        if(drive_counter >= 3)
                            
                            switch(pass)
                                case 2
                                    %This will hopefully never happen. In
                                    %this case just trow an error. Maybe
                                    %later drive backwards and reset position?
                                    error('Car outside microphone range');
                                case 3
                                    drive_counter = 100;
                                    
                                case 4
                                    car.did_turn = true;
                                    pass = localize_5ch(TDOA_data, 1000);
                                    %This will reevaluate its
                                    %orientation and position
                                    if(pass ~= 1)
                                        error('Could not reevaluate position. Something funny is going on.');
                                    end
                                case 5
                                    z_counter = z_counter + 1;
                                    if(z_counter > 3)
                                        error('Z_counter is too large. Something funny is going on.');
                                    end
                                case 6
                                    localize_5ch(TDOA_data, 1000);
                                case 7
                                    localize_5ch(TDOA_data, 1000);
                            end
                        else
                            drive_car(car.speed, car.steer_straight, 0.2);
                        end
                    end
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


