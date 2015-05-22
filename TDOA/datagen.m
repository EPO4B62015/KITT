% Generate codeword of Ncodebits with 'high' autocorrelation

Ncodebits = 64;                 % # of bits of code


% TODO:  maximize autocorrelation
x = sign(randn(Ncodebits,1));   % generate random 64 bit binary code
