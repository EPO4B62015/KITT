function pass = localize_5ch(tdoa_matrix, expected_travel_distance, expected_angle_difference)
%Checking if calculations are possible
disp('Start localize');
global position;
global static_positions;
global test_data;
mic_positions = static_positions.mic_positions;% [0 0 30; 413 0 30; 413 210 30; 0 210 30; 173 0 77];
row = 5;
col = 3;
elements = (row * (row - 1))/2;
pass = 1;
if(elements ~= length(tdoa_matrix))
    error('X matrix and TDOA matrix dont match!');
end

if(length(find(abs(tdoa_matrix) < 5)) > 1.5)
    disp('Multiple elements are smaller than 5. Can not compute!')
    pass = 0;
    return;
end

A_matrix = zeros(elements, col + row - 1);
b_matrix = zeros(elements, 1);
mic1 = 1;
mic2 = 2;
for i = 1:elements
    for j = 1:col
        A_matrix(i, j) = 2 * (mic_positions(mic2, j) - mic_positions(mic1, j));
    end
    A_matrix(i, col - 1 + mic2) = -2 * tdoa_matrix(i);
    b_matrix(i, 1) = tdoa_matrix(i)^2 - norm(mic_positions(mic1, 1:col))^2 + norm(mic_positions(mic2, 1:col))^2;
    mic2 = mic2 + 1;
    if(mic2 > row)
        mic1 = mic1 + 1;
        mic2 = mic1 + 1;
    end
end
y = pinv(A_matrix) * b_matrix;
x = y(1:col)
test_data.pos_tdoa = [test_data.pos_tdoa, x];
if(x(1) < 0 || x(2) < 0 || x(1) > mic_positions(3, 1) || x(2) > mic_positions(3,2))
    pass = 0;
    return;
end
disp('Check 2');
diff_x = x(1) - position(1,end);
diff_y = x(2) - position(2,end);
angle = atan2d(diff_y, diff_x);
distance_traveled = norm([diff_y diff_x]);
%Angle calculated. What to reject and what to do when rejected?

disp('Check 1')
if(distance_traveled < expected_travel_distance * 1.5)
    if(abs(angle - position(3, end) < 15 + expected_angle_difference))
        vector = [x(1); x(2); 0];
        position = [position vector];
    else
        disp('Rejected because of angle');
        pass = 0;
    end
else
    disp('Rejected because of travel distance');
    pass = 0;
end
disp('Einde localize');
end