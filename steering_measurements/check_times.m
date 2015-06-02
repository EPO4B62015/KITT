% figure out how long steering x degrees takes when driving at different
% speeds.


% speed and steering settings

% speeds
v_neutral = 150;
v_fast    = v_neutral + 15;
v_normal  = v_neutral + 5; 
v_brake   = v_neutral - 15;

% steering (make sure to steer the same amount to left or right)
d_neutral = 153;
d_left    = d_neutral - 47; 
d_right   = d_neutral + 47;





    % 15 degrees change
    % 30 degrees change

% 45 degrees change (medium left or medium right)
steering_timer(v_fast,d_left,1,0.01);
    % 60 degrees change
    % 75 degrees change

% 90 degrees change (left or right)
steering_timer(v_fast,d_left,2.0,0.01);
    % 105 degrees change
    % 120 degrees change

% 135 degrees change

    % 150 degrees change
    % 165 degrees change

% 180 degrees change (turn around left or right)

    % 195 degrees change
    % 210 degrees change

% 225 degrees change

    % 240 degrees change
    % 255 degrees change

% 270 degrees change (3/4 circle left or right)

    % 285 degrees change
    % 300 degrees change

% 315 degrees change

    % 330 degrees change
    % 345 degrees change

% 360 degrees change (full circle left or right)