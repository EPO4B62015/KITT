lookup_velocity = 2.3;
load ('data_f_test.mat');
data_t_a = data_a_165;
data_t_d = data_d_150_2;
data_t_d_fast = data_d_135;

Afstand    = (abs(data_t_a(1:end,4)-data_t_a(1,4)))/100;
Time_a  = data_t_a(1:end,7); %tijd vanaf zelfde moment metingen
V = diff(Afstand)./diff(Time_a);
V = [0;V];
Time_a  = [0;Time_a];

data_t_d            = data_t_d(1:end,1:end);
distance_d    = (abs(data_t_d(1:end,4)-data_t_d(1,4)))/100;
time_d      = data_t_d(1:end,7);
velocity_d  = diff(distance_d)./diff(time_d);   % Derivative
time_d      = time_d(1:end) - time_d(1);
distance_d_curve = distance_d(1:14);
time_d_curve = time_d(1:14);

distance_d_fast    = (abs(data_t_d_fast(4:end,4)-data_t_d_fast(4,4)))/100;
time_d_fast  = data_t_d_fast(4:end,7); %tijd vanaf zelfde moment metingen
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

while(1)
[i_d,i_v1] = polyxpoly(dist,V_fitted,dist,velocity_d_fitted);
 % distance at which deceleration reaches 0 velocity

    if (i_v1 >= lookup_velocity)
        break;
    end
velocity_d_fitted = [velocity_d_fitted(1:10); velocity_d_fitted(1:end-10)];
end

pos_150_zero = find(velocity_d_fitted <= 0);
d_150 = dist(pos_150_zero(1));
pos_ip_150 = find(dist_time >= i_d);
time_to_brake = time(pos_ip_150(1));
brake_time_150 =  dist_time_d(d_150-i_d);
td_150 = [time_to_brake; brake_time_150; d_150-i_d];

while(1)

    
[i_d_fast,i_v3] = polyxpoly(dist,V_fitted,dist,velocity_d_fast_fitted);% intersection



    if (i_v3 >= lookup_velocity)
        break
    end 
velocity_d_fast_fitted = [velocity_d_fast_fitted(1:10);velocity_d_fast_fitted(1:end-10)];
end
pos_135_zero = find(velocity_d_fast_fitted <= 0);
d_135 = dist(pos_135_zero(1)); % distance at which deceleration
pos_ip_135 = find(dist_time >= i_d_fast);
td_135 = [time(pos_ip_135(1)); abs(0.5 - dist_time_d_fast(d_135 - i_d_fast)); d_135-i_d_fast];


