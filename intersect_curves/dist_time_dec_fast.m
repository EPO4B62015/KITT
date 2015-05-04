function [fitresult, gof] = dist_time_dec_fast(distance_d_fast, time_d_fast)
%CREATEFIT(DISTANCE_D_FAST,TIME_D_FAST)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : distance_d_fast
%      Y Output: time_d_fast
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 04-May-2015 22:24:38


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( distance_d_fast, time_d_fast );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.999991555082061;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'time_d_fast vs. distance_d_fast', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel distance_d_fast
% ylabel time_d_fast
% grid on


