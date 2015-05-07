clear all;
% Acceleration and Deceleration automatic curve fitting (Thomas)

% Approach:
% - Load and assign data
load ('data_f_test.mat'); % Load whatever data you want

data_t_a = data_a_165; % Assign matrices from the loaded data to the
data_t_d = data_d_150; % corresponding variables

% - (maybe alter data slightly to delete outliers)
i=2;j=2;k=2;
while(i<size(data_t_a,1)) 
    if(data_t_a(i,4)==999 && data_t_a(i,3) == 999)
        data_t_a = [data_t_a(1:i-1,1:end); data_t_a(i+1:end,1:end)];
    elseif(data_t_a(i,4)==999)
        data_t_a(i,4)=data_t_a(i,3);
    elseif(data_t_a(i,3)==999)
        data_t_a(i,3)=data_t_a(i,4);   
    else
        i=i+1;
    end
end

while(k<size(data_t_a,1))
    if (data_t_a(k,2) < 150)
        data_t_a = data_t_a(1:k-1,1:end);
        break;
    end
    k = k+1;  
end

while(j<size(data_t_d,1)) 
    if(data_t_d(j,4) == 999 && data_t_d(j,3) == 999)
        data_t_d = [data_t_d(1:j-1,1:end); data_t_d(j+1:end,1:end)];
        j= j-1;
    elseif(data_t_d(j,4) == 999)
        data_t_d(j,4) = data_t_d(j,3);
    elseif(data_t_d(j,3) == 999)
        data_t_d(j,3) = data_t_d(j,4);   
    end
j=j+1;
end

% - generate the needed stuff from the cleaned up data
% -- acceleration
dist_left_a     = abs(data_t_a(2:end,3)-data_t_a(2,4)); %afstand van 0 laten lopen
dist_right_a    = abs(data_t_a(2:end,4)-data_t_a(2,3));
    
dist_a = (dist_right_a /100); % distance in meters
time_a  = data_t_a(2:end,7); %tijd vanaf zelfde moment metingen
velocity_a       = diff(dist_a)./diff(time_a);
velocity_a = [0;velocity_a]; % begin with zero and append last value
dist_a(end) = 20;
time_a  = [0;time_a];

% -- deceleration
data_t_d            = data_t_d(7:end,1:end);
dist_left_d     = abs(data_t_d(2:end,3)-data_t_d(2,4));
dist_right_d    = abs(data_t_d(2:end,4)-data_t_d(2,3));

dist_d  = (dist_right_d / 100);         % Distance in meters
time_d      = data_t_d(2:end,7);
velocity_d  = diff(dist_d)./diff(time_d);   % Derivative
velocity_d  = [0;velocity_d];
time_d      = [0;time_d];

% - Acceleration
% -- fit curve
fit_a = polyfit(dist_a,velocity_a,3);
fitted_a = polyval(fit_a,dist_a);

% -- Remove all data to the right of the maximum of the fitted curve
[max_a,ii] = max(fitted_a); % find index of max value
fitted_a = fitted_a(1:ii);  % truncate to that index
dist_a = dist_a(1:ii);      % also for the dist_a because otherwise lengths don't match

% -- Add 0.0 to the curve
fitted_a = [0;fitted_a];
dist_a = [0;dist_a];

% -- Add (10.max) to the curve
fitted_a = [fitted_a;max_a];
dist_a = [dist_a;3];
velocity_a = [velocity_a;max(velocity_a)];


% - Deceleration
% -- fit curve
fit_d = polyfit(dist_d,velocity_d,3);
fitted_d = polyval(fit_d,dist_d);

% -- Remove all data to the left of the maximum of the fitted curve
[max_d,jj] = max(fitted_d);     % find index of max value
fitted_d = fitted_d(jj:end);    % truncate everything before that index
dist_d = dist_d(jj:end);        % also for the dist_d because matching lengths

% -- Remove all data below the x-axis 
fitted_d(fitted_d<0) = 0;       % remove everything smaller than 0

% -- add (0.max) to the curve
fitted_d = [fitted_d(1);fitted_d]; % extend the graph to the y-axis in a straight line
dist_d = [0;dist_d];            % make the graph touch the y-axis
fitted_d = [fitted_d;0];        % make it reach zero in case it doesn't
dist_d = [dist_d;3];            % extend the graph to some far away point


% -  Plot ALL THE THINGS
figure
hold on
max_v = max(max(velocity_d), max(velocity_a));
ylim([0 max_v+0.5]);
xlim([0 3]);
plot(dist_a,velocity_a);
plot(dist_a,fitted_a);
plot(dist_d,velocity_d(1:end-1));
plot(dist_d,fitted_d);
legend('Acceleration','Deceleration');
xlabel('Distance in meters (m)');
ylabel('Velocity in meters per second (m/s)');

% use aquired smooth curves 


% TODO  COPY FROM OTHER SCRIPT (this shit doesn't work on my laptop for
% some reason) (intersect and stuff)

