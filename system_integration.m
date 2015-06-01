% complete system integration / control loop

% started by Thomas, everyone can and should contribute.

% chronological order of the final challenge, datasheet/specs file needed
% to have an overview of all inputs and outputs of the subsystems, and also
% layout / place in the final loop of these subsystems.


% 1. WIRELESS CHARGING

    % make sure the car doesn't start to drive until charged to 17V
    % when reaching 17V, first turn of charger and then start with the
    % complete control loop.
    
% 2. Initial position, x,y,z + orientation is known
    % (accuracy of targets at least 30cm)

%1. input: measured/computed location of the car.
%   extra input: anticollision system.
%2. output: drive and steer commands

% % %   How do we implement the control loop? Simulink? transfer functions?
    
    
    
% 3. Waypoints exist for more advanced tasks, distance between those
% waypoints are at least 1.5m, car should stop for at least 2sec there and
% our computer (running the control loop) should give a signal.

    % anticollision should work all the time.

    % no human interaction allowed

    % realtime plot of past and current car position + orientation. Also draw
    % obstackles and waypoints. (waypoints on beforehand), also show that the
    % car found an obstacle.

% 4. when the car reaches the final position, stop the car and the computer
% should give a signal.