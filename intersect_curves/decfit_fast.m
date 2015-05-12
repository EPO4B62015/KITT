function [fitresult, gof] = decfit_fast(distance_d_fast, velocity_d_fast)


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( distance_d_fast, velocity_d_fast );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [-0.17 5.35 2.53 0.62];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

