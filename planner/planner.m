function [ time,steer,speed ] = planner(next_position)
%input: position(x,y,orientation) ,next_position(x,y), 
global car;
global position;
global test_data;
speed           = 158;
d_x             = next_position(1)-position(1,end);
d_y             = next_position(2)-position(2,end);
desired_theta   = atan2d(d_y,d_x);
car.d_theta         = desired_theta - position(3,end);
distance        = sqrt(d_x^2 + d_y^2);
%test_data.dtheta = [test_data.dtheta, car.d_theta]; 

if car.did_turn == true
    time        = 0.5;
    steer       = 153;
    car.did_turn    = false;
else
    if abs(car.d_theta) <= 5    %straigth
        if distance <= 1.5;
            time    = straight(distance);
            steer   = 153;
        else                %distance is greater than 1.5m
            time    = 1;    % return a 1s drive
            steer   = 153;  % straight
        end
    else                    % turn
        %car.d_theta     = roundn(car.d_theta,1.5); % round up or down to nearest 15 degrees.
        car.did_turn    = true; % make sure that we drive a bit in a straight line next
        if car.d_theta <= 0
            steer = 197;
        else
            steer = 100;
        end
        time = turn(car.d_theta);
    end
end

end
