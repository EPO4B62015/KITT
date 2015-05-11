function [ dist_start_rollout, dist_start_break ] = intersect_distance(lookup_time)
% function which returns the distance at which to break or roll out when
% given an input for the total drive time.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%    ER WORDT VANNALES MET DE DATA GEDAAN MAAR DIT IS ZO INPUTDATA
%    SPECIFIEK DAT DE HELE CODE OPNIEUW MOET WORDEN GESCHREVEN ALS ER
%    ANDERE TEST/MEASUREMENTDATA IS...  ECHT NIET HANDIG.
%    + ER IS 0 DOCUMENTATIE EN COMMENTAAR BIJ DE CODE, WAT HET DUS OOK
%    ONNODIG VEEL WERK MAAKT OM EVEN DE FUNCTIE TE INVERTEREN. 
%
%    DUSJA, DEZE CODE IS NOG NIET AF VOOR DE GESTELDE DEADLINE VAN
%    DINSDAGOCHTEND. ANYWAY, GENOEG GEZEKEN, IK KOM ER MORGEN BIJ DE
%    OPENINGSVERGADERING WEL EVEN OP TERUG. XXX
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the measurementdata
load ('data_f_test.mat');
% assign that data to the correct variables
data_t_a = data_a_165;      % acceleration data
data_t_d_rollout = data_d_150_2;    % rollout data
data_t_d_break = data_d_135; % break data

% use loaded data to compute needed stuff
distance_a          = (abs(data_t_a(1:end,4)-data_t_a(1,4)))/100;                   % acceleration distances in meters
distance_d_rollout  = (abs(data_t_d_rollout(1:end,4)-data_t_d_rollout(1,4)))/100;   % rollout distances in meters
distance_d_break    = (abs(data_t_d_break(4:end,4)-data_t_d_break(4,4)))/100;       % break distances in meters

time_a          = data_t_a(1:end,7);            % acceleration times in seconds
time_d_rollout  = data_t_d_rollout(1:end,7);	% rollout times in seconds
time_d_break    = data_t_d_break(4:end,7);      % break times in seconds

velocity_a  = diff(distance_a)./diff(time_a);                % acceleration velocity in meters per second
velocity_a  = [0;velocity_a];                                % add 0 as the starting velocity
time_a      = [0;time_a];                                    % add 0 as the starting time



velocity_d  = diff(distance_d_rollout)./diff(time_d_rollout);                % deceleration velocity in meters per second
time_d_rollout      = time_d_rollout(1:end) - time_d_rollout(1);
distance_d_curve = distance_d_rollout(1:14);
time_d_curve = time_d_rollout(1:14);



velocity_d_break       = diff(distance_d_break)./diff(time_d_break);
velocity_d_break = [2.45; velocity_d_break];
time_d_break = time_d_break(1:end) - time_d_break(1);

load('test_data.mat')

[a_fit, gofa] = accfit_made_long(testafstand, V_test);
[d_fit, gofd] = decfit(distance_d_rollout(1:end-1), velocity_d);
[d_fit_fast, gofdf] = decfit_fast(distance_d_fast, velocity_d_break);
[dist_time_a, gofta] = dist_time_acc(testtime,testafstand);
[dist_time_d, goftd] = dist_time_dec(distance_d_curve, time_d_curve);
[dist_time_d_fast, goftdf] = dist_time_dec_fast(distance_d_fast, time_d_break);

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

pos_150_zero = find(velocity_d_fitted <= 0);
d_150 = dist(pos_150_zero(1)); % distance at which deceleration reaches 0 velocity

    if (d_150 >= lookup_distance)
        break;
    end
velocity_d_fitted = [velocity_d_fitted(1:10); velocity_d_fitted(1:end-10)];
end
[i_d,i_v1] = polyxpoly(dist,V_fitted,dist,velocity_d_fitted);
pos_ip_150 = find(dist_time >= i_d);
time_to_brake = time(pos_ip_150(1));
brake_time_150 =  dist_time_d(d_150-i_d);
time_ip_150 = [time_to_brake; brake_time_150];

while(1)

pos_135_zero = find(velocity_d_fast_fitted <= 0);
d_135 = dist(pos_135_zero(1)); % distance at which deceleration


    if (d_135 >= lookup_distance)
        break
    end 
velocity_d_fast_fitted = [velocity_d_fast_fitted(1:10);velocity_d_fast_fitted(1:end-10)];
end
[i_d_fast,i_v3] = polyxpoly(dist,V_fitted,dist,velocity_d_fast_fitted);% intersection
pos_ip_135 = find(dist_time >= i_d_fast);
time_ip_135 = [time(pos_ip_135(1)); abs( 0.55 - dist_time_d_fast(d_135 - i_d_fast))];


end

