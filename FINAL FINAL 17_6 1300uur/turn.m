function [ time ] = turn(d_theta)
global car;
%TURN Summary of this function goes here
%   returns time to make a certain turn of d_theta

% Moet nog getweaked / gecalibreerd worden
% positive d_theta
if d_theta > 5
    time = (0.01422222222*d_theta +0.5) / car.v_factor;
elseif d_theta < -5
    % negative d_theta 
    time = (-0.0142222222*d_theta +0.5) / car.v_factor;
else 
    time = 0;
end
end

