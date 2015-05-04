%%%% CLEAR AND LOAD MEASUREMENTS %%%%%
%clear all;
load ('data_f_test.mat');

lookup_distance = 3.5;

data_t_a = data_a_165;
data_t_d = data_d_150_2;
data_t_d_fast = data_d_135;
%%%% REMOVE INCORRECT AND/OR NOT NEEDED MEASUREMENTS %%%%%
% i=2;j=2;k=2;
% while(i<size(data_t_a,1)) % incorrecte metingen weggooien
%     if(data_t_a(i,4)==999 && data_t_a(i,3) == 999)
%         data_t_a = [data_t_a(1:i-1,1:end); data_t_a(i+1:end,1:end)];
%     elseif(data_t_a(i,4)==999)
%         data_t_a(i,4)=data_t_a(i,3);
%     elseif(data_t_a(i,3)==999)
%         data_t_a(i,3)=data_t_a(i,4);   
%     else
%         i=i+1;
%     end
% end

% while(k<size(data_t_a,1))
%     if (data_t_a(k,2) < 150)
%         data_t_a = data_t_a(1:k-1,1:end);
%         break;
%     end
%     k = k+1;  
% end

% while(j<size(data_t_d,1)) 
%     if(data_t_d(j,4) == 999 && data_t_d(j,3) == 999)
%         data_t_d = [data_t_d(1:j-1,1:end); data_t_d(j+1:end,1:end)];
%         j= j-1;
%     elseif(data_t_d(j,4) == 999)
%         data_t_d(j,4) = data_t_d(j,3);
%     elseif(data_t_d(j,3) == 999)
%         data_t_d(j,3) = data_t_d(j,4);   
%     end
% j=j+1;
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% DISTANCES, TIMES and VELOCITIES %%%%%
Afstand_links_a     = abs(data_t_a(1:end,3)-data_t_a(1,3)); %afstand van 0 laten lopen
Afstand_rechts_a    = abs(data_t_a(1:end,4)-data_t_a(1,4));
    
Afstand = (Afstand_rechts_a /100); %Afstand in meters
Time_a  = data_t_a(1:end,7); %tijd vanaf zelfde moment metingen
V       = diff(Afstand)./diff(Time_a);
V = [0;V]; % begin with zero and append last value
%Afstand(end) = 20;


Time_a  = [0;Time_a];
data_t_d            = data_t_d(1:end,1:end);
distance_left_d     = abs(data_t_d(1:end,3)-data_t_d(1,3));
distance_right_d    = abs(data_t_d(1:end,4)-data_t_d(1,4));

distance_d  = (distance_right_d / 100);         % Distance in meters
time_d      = data_t_d(1:end,7);
velocity_d  = diff(distance_d)./diff(time_d);   % Derivative
velocity_d  = [velocity_d];
time_d      = time_d(1:end) - time_d(1);
distance_d_curve = distance_d(1:14);
time_d_curve = time_d(1:14);

distance_right_d_fast    = abs(data_t_d_fast(4:end,4)-data_t_d_fast(4,4));
    
distance_d_fast = (distance_right_d_fast /100); %Afstand in meters
time_d_fast  = data_t_d_fast(4:end,7); %tijd vanaf zelfde moment metingen
velocity_d_fast       = diff(distance_d_fast)./diff(time_d_fast);
velocity_d_fast = [2.45; velocity_d_fast];
time_d_fast = time_d_fast(1:end) - time_d_fast(1);


load('test_data.mat')
[d_fit_fast, gofdf] = decfit_fast(distance_d_fast, velocity_d_fast);
[a_fit, gofa] = accfit_made_long(testafstand, V_test);
[d_fit, gofd] = decfit(distance_d(1:end-1), velocity_d);
[dist_time, goft] = dist_time_acc(testtime,testafstand);
[dist_time_d, goftd] = dist_time_dec(distance_d_curve, time_d_curve);
[dist_time_d_fast, goftdf] = dist_time_dec_fast(distance_d_fast, time_d_fast);

time = linspace(0,4,1000);
dist = linspace(0,6,1000);
dist_time = dist_time(time);
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
display(d_150);
end
[i_d,i_v1] = polyxpoly(dist,V_fitted,dist,velocity_d_fitted);
pos_ip_150 = find(dist_time >= i_d);
time_ip_150 = time(pos_ip_150(1));


while(1)

pos_135_zero = find(velocity_d_fast_fitted <= 0);
d_135 = dist(pos_135_zero(1)); % distance at which deceleration


    if (d_135 >= lookup_distance)
        break
    end 
velocity_d_fast_fitted = [velocity_d_fast_fitted(1:10);velocity_d_fast_fitted(1:end-10)];
display(d_135);
end
[i_d_fast,i_v3] = polyxpoly(dist,V_fitted,dist,velocity_d_fast_fitted);% intersection
pos_ip_135 = find(dist_time >= i_d_fast);
time_ip_135 = time(pos_ip_135(1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% FIGURES %%%%%
figure
hold on
max_v = max(max(velocity_d), max(V));
% ylim([0 max_v+0.5]);
% xlim([0 3]);
plot(dist,V_fitted);
plot(dist,velocity_d_fitted);
plot(dist,velocity_d_fast_fitted);
legend('Acceleration','Deceleration');
xlabel('Distance in meters (m)');
ylabel('Velocity in meters per second (m/s)');