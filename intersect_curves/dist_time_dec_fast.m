function [fitresult, gof] = dist_time_dec_fast(distance_d_fast, time_d_fast)
%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( distance_d_fast, time_d_fast );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 1;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
