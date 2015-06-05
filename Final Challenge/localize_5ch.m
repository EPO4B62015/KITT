function pass = localize_5ch(tdoa_matrix, expected_travel_distance)
%Checking if calculations are possible
global position;
x_matrix = [0 0 30; 413 0 30; 413 210 30; 0 210 30; 173 0 77];
row = 5;
col = 3;
elements = (row * (row - 1))/2;

if(elements ~= length(tdoa_matrix))
    error('X matrix and TDOA matrix dont match!');
end

if(abs(tdoa_matrix(1)) < 10 && abs(tdoa_matrix(8) < 10))
    disp('Close to middle Y');%Grid?
    pass = 0;
elseif(abs(tdoa_matrix(3)) < 10 && abs(tdoa_matrix(5) < 10))
    disp('Close to middle X');%Grid?
    pass = 0;
else
    A_matrix = zeros(elements, col + row - 1);
    b_matrix = zeros(elements, 1);
    mic1 = 1;
    mic2 = 2;
    for i = 1:elements
        for j = 1:col
            A_matrix(i, j) = 2 * (x_matrix(mic2, j) - x_matrix(mic1, j));
        end
        A_matrix(i, col - 1 + mic2) = -2 * tdoa_matrix(i);
        b_matrix(i, 1) = tdoa_matrix(i)^2 - norm(x_matrix(mic1, 1:col))^2 + norm(x_matrix(mic2, 1:col))^2;
        mic2 = mic2 + 1;
        if(mic2 > row)
            mic1 = mic1 + 1;
            mic2 = mic1 + 1;
        end
    end
    y = pinv(A_matrix) * b_matrix;
    x = y(1:col);
end

diff = x - last_pos;
angle = atan2d(diff(2), diff(1));
distance_traveled = norm(diff);
%Angle calculated. What to reject and what to do when rejected?
position = [position; x(1) x(2) 0];
% if(abs(angle - position(3, end)) < 15)
%     %Accept
%     if(distance_traveled < expected_travel_distance * 1.5)
%         pass = 1;
%         
%     else
%         pass = 0;
%     end
% else
%     %reject
%     pass = 0;
% end

end