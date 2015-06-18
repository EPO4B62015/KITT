x = linspace(0,600,601);
y = linspace(0,600,601);
z = 26*ones(1,601);
pos = [0;0;0];
for j = 1:601
test00 = x(j)*ones(1,601);
test0 = [test00;y;z];
pos = [pos, test0];
end

mic_positions = [0 0 40; 600 0 40; 600 600 40; 0 600 40; 300 0 46];

for i = 1:length(pos)
   tdoa(:,i) =  make_tdoa(mic_positions, pos(:,i)');
end

for k = 1:length(tdoa)
    pos_calc(:,k) = localize(mic_positions, tdoa(:,k));
end

dist = sqrt(pos(1,:).^2 + pos(2,:).^2);
dist_calc = sqrt(pos_calc(1,:).^2 + pos_calc(2,:).^2);
afweiking = abs(dist - dist_calc);

% Interpolate to grid
interpolant = scatteredInterpolant(pos(1,:)',pos(2,:)',afweiking'*100);

% Grid
[xx,yy] = meshgrid(linspace(0,600,100));  % replace, 0 1, 10 with range of your values

% Interpolate
intensity_interp = interpolant(xx,yy);

contourf(xx,yy,intensity_interp)
