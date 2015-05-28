function tdoa = make_tdoa(x_matrix_mics, x_location)
    [row, col] = size(x_matrix_mics);
    dimensions = length(x_location);
    if(col ~= dimensions)
        error('Mics location does not work with x_location');
    end
    elements = (row * (row - 1))/2;
    tdoa = zeros(elements, 1);
    mic1 = 1;
    mic2 = 2;
    for i = 1:elements
        tdoa(i, 1) = (norm(x_matrix_mics(mic1, 1:col) - x_location) - norm(x_matrix_mics(mic2, 1:col) - x_location));
        mic2 = mic2 + 1;
        if(mic2 > row)
            mic1 = mic1 + 1;
            mic2 = mic1 + 1;
        end
    end
end