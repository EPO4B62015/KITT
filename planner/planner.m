%Planner
%input: position(x,y,orientation) , next_position(x,y), 
delta_x = next_position(1)-position(1);
delta_y = next_position(2)-position(2);
if position(orientation) == arctan((next_position(1)-position(1))/(next_position(2)-position(2))) % no steering necessary, so straight line
    % drive straight line with length pytagoras: length = sqrt((next_position(1)-position(1)² +
    % route(y)²)
else
    % make a turn with route(orientation) as the angle
end
