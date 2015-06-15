function [ time ] = turn(d_theta)
global voltage;
%TURN Summary of this function goes here
%   returns time to make a certain turn of d_theta

% Moet nog getweaked / gecalibreerd worden
% positive d_theta
if d_theta > 5
    time = (0.01622222222*d_theta +0.5) / voltage.factor;
elseif d_theta < -5
    % negative d_theta 
    time = (-0.0162222222*d_theta +0.5) / voltage.factor;
else 
    time = 0;
end
end

