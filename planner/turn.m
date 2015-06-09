function [ time ] = turn(d_theta)
%TURN Summary of this function goes here
%   returns time to make a certain turn of d_theta

% Moet nog getweaked / gecalibreerd worden
% positive d_theta
if d_theta > 5
    time = 0.01622222222*d_theta;
elseif d_theta < -5
    % negative d_theta 
    time = -0.02277777777*d_theta;
else 
    time = 0;
end
end

