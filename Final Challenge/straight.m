function [ time ] = straight(distance)
global car;
%TURN Summary of this function goes here
%   returns time to drive a certain distance lower than 1.5m (for now)

% Moet nog getweaked / gecalibreerd worden
time = (2/1.5) * distance / car.v_factor;

end

