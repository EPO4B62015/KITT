function [fitresult, gof] = dist_time_acc(testtime, testafstand)

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( testtime, testafstand );

% Set up fittype and options.
ft = 'linearinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );


