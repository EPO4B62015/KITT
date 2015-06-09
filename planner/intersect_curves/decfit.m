function [fitresult, gof] = decfit(distance_d, velocity_d)

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( distance_d, velocity_d );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.95;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

