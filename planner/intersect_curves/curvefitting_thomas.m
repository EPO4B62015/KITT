clear all;
% Acceleration and Deceleration automatic curve fitting (Thomas)

% Approach:
% - Load and assign data
load ('data_f_test.mat'); % Load whatever data you want

data_t_a = data_a_165; % Assign matrices from the loaded data to the
data_t_d_rollout = data_d_150_2; % corresponding variables
data_t_d_brake = data_d_135; 


% - generate the needed stuff from the cleaned up data
% -- acceleration
dist_a = abs(data_t_a(1:end,4)-data_t_a(1,4))/100;  
time_a = data_t_a(1:end,7)-data_t_a(1,7);
velocity_a = [0;(diff(dist_a)./diff(time_a))];

[max_a,i] = max(velocity_a); % find index of max velocity
velocity_a = velocity_a(1:i); % truncate to that
time_a = time_a(1:i);
dist_a = dist_a(1:i);

dist_d_rollout = abs(data_t_d_rollout(1:end,4)-data_t_d_rollout(1,4))/100;
time_d_rollout = data_t_d_rollout(1:end,7)-data_t_d_rollout(1,7);
velocity_d_rollout = [0;(diff(dist_d_rollout)./diff(time_d_rollout))];

[max_d_rollout,i] = max(velocity_d_rollout);     % find index of max value
velocity_d_rollout = velocity_d_rollout(i:end);    % truncate everything before that index
time_d_rollout = time_d_rollout(i:end) - time_d_rollout(i);
dist_d_rollout = dist_d_rollout(i:end);
velocity_d_rollout(velocity_d_rollout<0) = 0; 

dist_d_brake = abs(data_t_d_brake(1:end,4)-data_t_d_brake(1,4))/100;
time_d_brake = data_t_d_brake(1:end,7)-data_t_d_brake(1,7);
velocity_d_brake = [0;(diff(dist_d_brake)./diff(time_d_brake))];

[max_d_brake,i] = max(velocity_d_brake);     % find index of max value
velocity_d_brake = velocity_d_brake(i:end);    % truncate everything before that index
time_d_brake = time_d_brake(i:end) - time_d_brake(i);
dist_d_brake = dist_d_brake(i:end);
velocity_d_brake(velocity_d_brake<0) = 0; 

figure
hold on
title('Time-Velocity plot');
plot(time_a,velocity_a);
plot(time_d_rollout,velocity_d_rollout);
plot(time_d_brake,velocity_d_brake);
legend('Acceleration','Roll-out','Braking');
xlim([0 time_a(end)]);
xlabel('Time in seconds');
ylabel('Velocity in meters per second');

% 
% % - Acceleration
% % -- fit curve
% fit_a = polyfit(dist_a,velocity_a,3);
% fitted_a = polyval(fit_a,dist_a);
% 
% % -- Remove all data to the right of the maximum of the fitted curve
% [max_a,ii] = max(fitted_a); % find index of max value
% fitted_a = fitted_a(1:ii);  % truncate to that index
% dist_a = dist_a(1:ii);      % also for the dist_a because otherwise lengths don't match
% 
% % -- Add 0.0 to the curve
% % -- Add (10.max) to the curve
% fitted_a = [0;fitted_a;max_a];
% dist_a = [0;dist_a;10];
% velocity_a = [velocity_a;max(velocity_a)];
% 
% 
% % - Deceleration
% % -- fit curve
% fit_d = polyfit(dist_d,velocity_d,3); % poly fit order 3
% fitted_d = polyval(fit_d,dist_d);
% 
% % -- Remove all data to the left of the maximum of the fitted curve
% [max_d,jj] = max(fitted_d);     % find index of max value
% fitted_d = fitted_d(jj:end);    % truncate everything before that index
% dist_d = dist_d(jj:end);        % also for the dist_d because matching lengths
% 
% % -- Remove all data below the x-axis 
% fitted_d(fitted_d<0) = 0;       % remove everything smaller than 0
% 
% % -- add (0.max) to the curve
% fitted_d = [fitted_d(1);fitted_d;0]; % extend the graph to the y-axis in a straight line
% dist_d = [0;dist_d;10];           % extend the graph to some far away point
% 
% 
% % -  Plot ALL THE THINGS
% figure
% hold on
% max_v = max(max(fitted_d), max(fitted_a));
% ylim([0 3]);
% xlim([0 3]);
% plot(dist_a,velocity_a);
% plot(dist_a,fitted_a);
% %plot(dist_d,velocity_d(1:end-1));
% plot(dist_d,fitted_d);
% legend('Acceleration','Deceleration');
% xlabel('Distance in meters (m)');
% ylabel('Velocity in meters per second (m/s)');
% 
% % use aquired smooth curves 
% [i_d,i_v] = polyxpoly(dist_a,fitted_a,dist_d,fitted_d); % intersect
% 
% 
% % TODO  COPY FROM OTHER SCRIPT (this shit doesn't work on my laptop for
% % some reason) (intersect and stuff)

