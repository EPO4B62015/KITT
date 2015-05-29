function tdoa = make_tdoa(matrix_mics_position, car_location)
% Generates test TDOA data
% input: mic positions, some field position
% output: TDOA data
    [row, col] = size(matrix_mics_position); % number of mics and dimension of their location
    dimensions = length(car_location); %dimension of car location data
    if(col ~= dimensions) % check for same dimensions
        error('Mics location dimensions dont match with x_location dimensions');
    end
    elements = (row * (row - 1))/2;
    tdoa = zeros(elements, 1);
    mic1 = 1;
    mic2 = 2;
    for i = 1:elements
        tdoa(i, 1) = (norm(matrix_mics_position(mic1, 1:col) - car_location) - norm(matrix_mics_position(mic2, 1:col) - car_location));
        mic2 = mic2 + 1;
        if(mic2 > row)
            mic1 = mic1 + 1;
            mic2 = mic1 + 1;
        end
    end
end