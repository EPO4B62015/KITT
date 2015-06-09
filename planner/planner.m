function [ time,steer,speed ] = planner(position,next_position,did_turn)
%input: position(x,y,orientation) ,next_position(x,y), 
speed           = 158;
d_x             = next_position(1)-position(1,end);
d_y             = next_position(2)-position(2,end);
desired_theta   = arctan2d(d_y/d_x);
d_theta         = desired_theta - position(3,end);
distance        = sqrt(d_x^2 + d_y^2);

<<<<<<< HEAD

if madeturn == true
=======
if did_turn == true
>>>>>>> 77601ea4df72fddf78b9d20791dc8b90f6c4dbac
    time        = 0.5;
    steer       = 153;
    did_turn    = false;
else
    if abs(d_theta) <= 5    %straigth
        if distance <= 1.5;
            time    = intersect_time(distance);
            steer   = 153;
        else                %distance is greater than 1.5m
            time    = 1;    % return a 1s drive
            steer   = 153;  % straight
        end
    else                    % turn
        d_theta     = roundn(d_theta,1.5); % round up or down to nearest 15 degrees.
        did_turn    = true; % make sure that we drive a bit in a straight line next
        if d_theta <= 0
            steer = 200;
        else
            steer = 100;
        end
        time = turn(d_theta);
    end
end

end
