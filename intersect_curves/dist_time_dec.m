function [fitresult, gof] = dist_time_dec(distance_d_curve, time_d_curve)
%CREATEFIT(DISTANCE_D_CURVE,TIME_D_CURVE)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : distance_d_curve
%      Y Output: time_d_curve
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 04-May-2015 22:31:21


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( distance_d_curve, time_d_curve );

% Set up fittype and options.
ft = 'linearinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'time_d_curve vs. distance_d_curve', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel distance_d_curve
% ylabel time_d_curve
% grid on


