% Acceleration and Deceleration automatic curve fitting (Thomas)

% Approach:
% - Load data
% - (maybe alter data slightly to delete outliers)
% - fit cubic curve 
% - Acceleration
% -- Remove all data to the right of the maximum of the fitted curve
% -- Add 0.0 to the curve
% -- Add (10.max) to the curve
% - Deceleration
% -- Remove all data to the left of the maximum of the fitted curve
% -- Remove all data below the x-axis 
% -- add (0.max) to the curve

% use aquired smooth curves 