function [fitresult, gof] = dist_time_dec(distance_d_curve, time_d_curve)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( distance_d_curve, time_d_curve );

% Set up fittype and options.
ft = 'linearinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );
