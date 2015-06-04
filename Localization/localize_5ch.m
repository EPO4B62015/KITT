function x = localize_5ch(tdoa_matrix, last_pos, theta)
%Checking if calculations are possible
[row, col] = size(x_matrix);
elements = (row * (row - 1))/2;

if(elements ~= length(tdoa_matrix))
    error('X matrix and TDOA matrix dont match!');
end

if(abs(tdoa_matrix(1)) < 10 && abs(tdoa_matrix(8) < 10))
    disp('Close to middle Y');%Grid?
elseif(abs(tdoa_matrix(3)) < 10 && abs(tdoa_matrix(5) < 10))
    disp('Close to middle X');%Grid?
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
%Angle calculated. What to reject and what to do when rejected?
if(abs(angle-theta) < 15)
    %Accept
else
    %reject
end

end