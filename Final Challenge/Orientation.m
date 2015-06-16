%Start Orientation is known. Use this as 0
%For info on atand2d see
%http://nl.mathworks.com/help/matlab/ref/atan2d.html

function Orientation%(position)
%Function to keep track of the orientation of the car
global position
global car

if(car.did_turn)
    position(3, end) = position(3,end - 1) + car.d_theta;
else
    
    %Take positive y axis as 0 degree
    
    x_diff = position(1, end) - position(1, end-1);
    y_diff = position(2, end) - position(2, end-1);
    
    angle = atan2d(y_diff,x_diff) % * 180 / pi;
    
    position(3,end) = angle;
end
end