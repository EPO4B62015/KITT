function [time,steer,speed] = planner(next_position)
%input: position(x,y,orientation),next_position(x,y)
global car;
global position;
global test_data;
global static_positions;
if car.voltage >= 17 % speed compensation for voltage drop
    speed = 158;
elseif car.voltage >= 14
    speed = 162;
else
    speed = 165;
end
[~,numberofpoints] = size(static_positions.route);
d_x              = next_position(1,static_positions.point)-position(1,end);
d_y              = next_position(2,static_positions.point)-position(2,end);
desired_theta    = atan2d(d_y,d_x);
car.d_theta      = desired_theta - position(3,end);
distance         = sqrt(d_x^2 + d_y^2);
test_data.dtheta = [test_data.dtheta, car.d_theta]; 
car.v_factor = car.voltage / car.voltage; %temporary always 1
if distance <= 0.3
    time = 3; % for 3 seconds
    steer = 150;
    speed = 150; %standing still
    if static_positions.point >= numberofpoints
        %WERETHERE_playsound or something
    else
    static_positions.point = static_positions.point + 1; % keep track of where we're going
    end
else
    if car.did_turn == true
        time         = 0.5 / car.v_factor;
        steer        = 150;
        car.did_turn = false;
    else
        if abs(car.d_theta) <= 10    %straigth
            if distance <= 1.5;
                time    = straight(distance);
                steer   = 150;
            else                %distance is greater than 1.5m
                time    = 1 / car.v_factor;    % return a 1s drive
                steer   = 150;  % straight
            end
        else                    % turn
            %car.d_theta    = roundn(car.d_theta,1.5); % round up or down to nearest 15 degrees.
            car.did_turn    = true; % make sure that we drive a bit in a straight line next
            if car.d_theta <= 0
                steer = 100;
            else
                steer = 197;
            end
            time = turn(car.d_theta);
        end
    end
end
end