function pass = localize_5ch(tdoa_matrix, expected_travel_distance)
%Checking if calculations are possible
%Pass codes
%   0 = Multiple elements are smaller than 5.
%   1 = pass
%   2 = Outside the range of the mics
%   3 = Rejected because of travel distance
%   4 = Rejected because of angle
%   5 = Rejected because z too large
%   6 = Rejected because of travel distance while turning
%   7 = Rejected because of travel distance while going straight after turn
disp('Start localize');
global position;
global static_positions;
global test_data;
global car;
mic_positions = static_positions.mic_positions;% [0 0 30; 413 0 30; 413 210 30; 0 210 30; 173 0 77];
row = 5;
col = 3;
elements = (row * (row - 1))/2;
pass = 1;
if(elements ~= length(tdoa_matrix))
    error('X matrix and TDOA matrix dont match!');
end

% if(length(find(abs(tdoa_matrix) < 5)) > 1.5)
%     disp('Multiple elements are smaller than 5. Can not compute!')
%     pass = 0;
%     return;
% end

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
%y = pinv(A_matrix) * b_matrix;
y = lscov(A_matrix, b_matrix);
x = y(1:col);
test_data.pos_tdoa = [test_data.pos_tdoa, x];

% if(abs(x(3)) > 1200)%Z filter
%     pass = 5;
%     return
% end
% if(x(3) > 20 && x(3) < 32)
%     vector = [x(1); x(2); 0];
%     position = [position vector];
%     return;
% end


if(x(1) < -100 || x(2) < -100 || x(1) > mic_positions(3, 1)+100 || x(2) > mic_positions(3,2)+100)
    pass = 2;
    return;
end

disp('Check 1');
diff_x = x(1) - position(1,end);
diff_y = x(2) - position(2,end);
angle = atan2d(diff_y, diff_x);
distance_traveled = norm([diff_y diff_x]);
%Angle calculated. What to reject and what to do when rejected?

disp('Check 2')
if(car.did_turn == true)
    if(distance_traveled < expected_travel_distance * 1.5)
        vector = [x(1); x(2); 0];
        position = [position vector];
    else
       disp('Rejected because of travel distance while turning');
       pass = 6;
    end
    return
elseif(car.did_last_turn == true)
    if(distance_traveled < expected_travel_distance * 1.5)
        vector = [x(1); x(2); 0];
        position = [position vector];
    else
       disp('Rejected because of travel distance while driving after turning');
       pass = 7;
    end
    return
elseif(distance_traveled < expected_travel_distance * 1.5)
    if(abs(angle - position(3, end) < 15))
        vector = [x(1); x(2); 0];
        position = [position vector];
    else
        disp('Rejected because of angle');
        pass = 4;
    end
else
    disp('Rejected because of travel distance');
    pass = 3;
end
disp('Einde localize');
end