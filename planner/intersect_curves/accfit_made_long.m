function [fitresult, gof] = accfit_made_long(testafstand, V_test)

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( testafstand, V_test );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.Robust = 'LAR';
opts.StartPoint = [2.35 0 -2.57 -3];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

