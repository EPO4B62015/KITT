function [hhat,H] = ch3(y,x)
%Frequency domain channel estimation
eps = 0.2; %Epsilon

Ny = length(y); Nx = length(x); 
L = Ny - Nx +1;
Y = fft(y);
X = fft([x; zeros(Ny - Nx , 1)]); %Zero padding to length Ny
H = Y ./ X;

G = X;
ii = find(abs(X) <= eps);
G(ii) = 0;
ii = find(abs(X) > eps);
G(ii) = 1;

H = H.*G;

h = ifft(H);
hhat = h(1:L);
%-- make the sequence real if needed

