function [time,steer,speed] = planner
%input: position(x,y,orientation),next_position(x,y)
global car;
global position;
global test_data;
global static_positions;
% compensation for voltage drop of supercaps
if car.voltage >= 17 % speed compensation for voltage drop
    speed = 159; % IMPORTANT, CALIBRATE FOR 1.3s for 1m
    disp('Voltage level: normal, just cruizing')
elseif car.voltage >= 14 % adjust by hand acordingly
    speed = 159;
    disp('Voltage level: meh, lets hit the gas')
else
    speed = 165;
    disp('Voltage level: drained, pedal to the metal!')
end
% end of compensation for voltage drop of supercaps
[~,numberofpoints] = size(static_positions.route);
d_x              = static_positions.route(1,static_positions.point)-position(1,end);
d_y              = static_positions.route(2,static_positions.point)-position(2,end);
desired_theta    = atan2d(d_y,d_x);
car.d_theta      = desired_theta - position(3,end);
distance         = sqrt(d_x^2 + d_y^2);
test_data.dtheta = [test_data.dtheta, car.d_theta];
car.v_factor = 1; %car.voltage / car.voltage; %temporary always 1
if distance <= 0.3
    steer = car.steer_straight;
    speed = 150; %standing still
    
    if static_positions.point >= numberofpoints
        time = 40;
        disp('WE MADE IT, right? RIGHT?!')
        car.status = 2;
    else
        static_positions.point = static_positions.point + 1; % keep track of where we're going
        disp('ARRIVED AT A WAYPOINT, on to the next one!')
        time = 6;
        car.status = 1;
    end
else
    car.status = 0;
    if car.did_turn == true
        time         = 0.5 / car.v_factor;
        steer        = car.steer_straight;
        car.did_turn = false;
        car.did_last_turn = true;
        disp('Driving straight a bit to provide data for orientation after we made a turn.')
    else
        car.did_last_turn = false;
        disp('To turn or not to turn, thats the question...')
        if abs(car.d_theta) <= 5    %straigth
            disp('No turn!');
            if distance <= 1.5;
                time    = straight(distance);
                steer   = car.steer_straight;
                disp('Almost there, careful now, we got one shot (nope, just kidding).')
            else                %distance is greater than 1.5m
                time    = 1 / car.v_factor;    % return a 1s drive
                steer   = car.steer_straight;  % straight
                disp('Lets drive in a straight line for a bit and check again later.')
            end
        else                    % turn
            disp('Lets turn')
            %car.d_theta    = roundn(car.d_theta,1.5); % round up or down to nearest 15 degrees.
            car.did_turn    = true; % make sure that we drive a bit in a straight line next
            if car.d_theta <= 0
                steer = 100;
                disp('to the right!')
            else
                steer = 200;
                disp('to the left!')
            end
            time = turn(car.d_theta);
        end
    end
end
end