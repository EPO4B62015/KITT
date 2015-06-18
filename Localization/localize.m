function x = localize(x_matrix, tdoa_matrix)
    %Checking if calculations are possible
    [row, col] = size(x_matrix);
    elements = (row * (row - 1))/2;
    if(elements ~= length(tdoa_matrix))
        error('X matrix and TDOA matrix dont match!');
    end
    
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
    
    %EEN VAN DEZE WEGCOMMENTEN
    %y = pinv(A_matrix) * b_matrix;
    y = lscov(A_matrix, b_matrix);
    x = y(1:col);
end