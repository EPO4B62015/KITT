function h = matched_f(x,y)
Ny = length(y);
Nx = length(x);
L = Ny-Nx +1;
xr = flipud(x);
h = filter(xr,1,y);
h = h(Nx:end);
alpha = x' *x;
h = h/alpha;
end