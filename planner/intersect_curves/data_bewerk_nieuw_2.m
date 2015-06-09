% Input + load data %
lookup_velocity = 2;
load ('data_f_test.mat');
data_t_a = data_a_165;
data_t_d_rollout = data_d_150_2;
data_t_d_brake = data_d_135;
%%%%%%%%%%

% 2.4 m/s is the maximum speed so anything above that doesn't make sense %
if (lookup_velocity > 2.4)
    lookup_velocity = 2.4;
end
%%%%%%%%%%

% computation of needed stuff %
%- acceleration %
distance_a = (abs(data_t_a(1:end,4)-data_t_a(1,4)))/100;
time_a  = data_t_a(1:end,7); %tijd vanaf zelfde moment metingen
velocity_a = diff(distance_a)./diff(time_a);
velocity_a = [0;velocity_a];
time_a  = [0;time_a];
%- rollout %
distance_d  = (abs(data_t_d_rollout(1:end,4)-data_t_d_rollout(1,4)))/100;
time_d      = data_t_d_rollout(1:end,7);
velocity_d  = diff(distance_d)./diff(time_d);   % Derivative
time_d      = time_d(1:end) - time_d(1);
distance_d_curve = distance_d(1:14);
time_d_curve = time_d(1:14);
%- braking %
distance_d_fast    = (abs(data_t_d_brake(4:end,4)-data_t_d_brake(4,4)))/100;
time_d_fast  = data_t_d_brake(4:end,7); %tijd vanaf zelfde moment metingen
velocity_d_fast       = diff(distance_d_fast)./diff(time_d_fast);
velocity_d_fast = [2.45; velocity_d_fast];
time_d_fast = time_d_fast(1:end) - time_d_fast(1);

load('test_data.mat')

[a_fit, gofa] = accfit_made_long(testafstand, V_test);
[d_fit, gofd] = decfit(distance_d(1:end-1), velocity_d);
[d_fit_fast, gofdf] = decfit_fast(distance_d_fast, velocity_d_fast);
[dist_time_a, gofta] = dist_time_acc(testtime,testafstand);
[dist_time_d, goftd] = dist_time_dec(distance_d_curve, time_d_curve);
[dist_time_d_fast, goftdf] = dist_time_dec_fast(distance_d_fast, time_d_fast);

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


while(1) % 150 roll out
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
td_150 = [time_to_brake; brake_time_150; d_150-i_d];

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
td_135 = [time(pos_ip_135(1)); abs(0.5 - dist_time_d_fast(d_135 - i_d_fast)); d_135-i_d_fast];

%%%%% FIGURES %%%%%
figure
hold on
plot(dist,V_fitted);
plot(dist,velocity_d_fitted);
plot(dist,velocity_d_fast_fitted);
legend('Acceleration','Roll-out','Braking');
xlabel('Distance in meters (m)');
ylabel('Velocity in meters per second (m/s)');