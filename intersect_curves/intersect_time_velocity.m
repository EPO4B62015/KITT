function [rollout, brake] = intersect_time_velocity(lookup_velocity)
% Function that returns braktime, brakeduration and brakedistance for
% rollout and braking.

% Load data and assing to variables
load ('data_f_test.mat');
data_t_a = data_a_165;
data_t_d_rollout = data_d_150_2;
data_t_d_brake = data_d_135;

% 2.4 m/s is the maximum velocity, so higher than that doesn't make sense
if (lookup_velocity > 2.4)
    lookup_velocity = 2.4;
end

distance_a = (abs(data_t_a(1:end,4)-data_t_a(1,4)))/100;
time_a     = data_t_a(1:end,7); 
velocity_a = [0;(diff(distance_a)./diff(time_a))];
time_a     = [0;time_a];
distance_a = [0;distance_a];

distance_d_rollout          = (abs(data_t_d_rollout(1:end,4)-data_t_d_rollout(1,4)))/100;
time_d_rollout              = data_t_d_rollout(1:end,7);
velocity_d_rollout          = diff(distance_d_rollout)./diff(time_d_rollout);   
time_d_rollout              = time_d_rollout(1:end) - time_d_rollout(1);
distance_d_rollout_curve    = distance_d_rollout(1:14);
time_d_rollout_curve        = time_d_rollout(1:14);

distance_d_brake    = (abs(data_t_d_brake(4:end,4)-data_t_d_brake(4,4)))/100;
time_d_brake        = data_t_d_brake(4:end,7); 
velocity_d_brake    = diff(distance_d_brake)./diff(time_d_brake);
velocity_d_brake    = [2.45; velocity_d_brake];
time_d_brake        = time_d_brake(1:end) - time_d_brake(1);

% load corrected and extrapolated data
load('test_data.mat')

[a_fit,~]            = accfit_made_long(testafstand, V_test);
[d_fit,~]            = decfit(distance_d_rollout(1:end-1), velocity_d_rollout);
[d_fit_fast,~]       = decfit_fast(distance_d_brake, velocity_d_brake);
[dist_time_a,~]      = dist_time_acc(testtime,testafstand);
[dist_time_d,~]      = dist_time_dec(distance_d_rollout_curve, time_d_rollout_curve);
[dist_time_d_fast,~] = dist_time_dec_fast(distance_d_brake, time_d_brake);

time = linspace(0,4,1000);
dist = linspace(0,6,1000);
dist_time = dist_time_a(time);
V_fitted = a_fit(dist);
velocity_d_fitted = d_fit(dist);
velocity_d_fast_fitted = d_fit_fast(dist);
pos1 = find(velocity_d_fast_fitted < 0); 
velocity_d_fast_fitted(pos1(1):end) = 0;
pos2 = find(velocity_d_fitted < 0);
velocity_d_fitted(pos2(1):end) = 0;
ini_fit_v = velocity_d_fitted(1);

while(1) % 150 rollout
[i_d,i_v1] = polyxpoly(dist,V_fitted,dist,velocity_d_fitted);
 % distance at which deceleration reaches 0 velocity
step_size = abs(30 + round((i_v1 -lookup_velocity * 100),0));

    if (i_v1 < 0.98 * lookup_velocity)
        fit = [0];
        fit(1:step_size,1) = ini_fit_v;
        velocity_d_fitted = [fit; velocity_d_fitted(1:end-step_size)];
    elseif (i_v1 > 1.02 * lookup_velocity)
        fit = [0];
        fit(1:step_size-1,1) = 0;
        velocity_d_fitted = [ velocity_d_fitted((step_size):end);fit];
    else
        break
    end
    
end

pos_150_zero = find(velocity_d_fitted < 0.02);
d_150 = dist(pos_150_zero(1));
pos_ip_150 = find(dist_time >= i_d);
time_to_brake = time(pos_ip_150(1));
brake_time_150 =  dist_time_d(d_150-i_d);
rollout = [time_to_brake; brake_time_150; d_150-i_d];

while(1) % 135 braking
[i_d_fast,i_v3] = polyxpoly(dist,V_fitted,dist,velocity_d_fast_fitted); % intersect
step_size = abs(30 + round((i_v3 -lookup_velocity * 100),0));

    if (i_v3 < 0.98 * lookup_velocity)
        fit = [0];
        fit(1:step_size,1) = ini_fit_v;
        velocity_d_fast_fitted = [fit; velocity_d_fast_fitted(1:end-step_size)];
    elseif (i_v3 > 1.02 * lookup_velocity)
        fit = [0];
        fit(1:step_size-1,1) = 0;
        velocity_d_fast_fitted = [ velocity_d_fast_fitted((step_size):end);fit];
    else
        break
    end
    
end

pos_135_zero = find(velocity_d_fast_fitted < 0.02);
d_135 = dist(pos_135_zero(1)); % distance at which deceleration
pos_ip_135 = find(dist_time >= i_d_fast);
brake = [time(pos_ip_135(1)); abs(0.5 - dist_time_d_fast(d_135 - i_d_fast)); d_135-i_d_fast];
end