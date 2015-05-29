%Function to generate beacon setting. Input is 


%timer_3 > nbits * timmer_1 + die_out;
%timer_0 < 20kHz;
%timer_0 / timer_1 > 4 and whole
%

car_freq = [5 10 20 25 30];
code_freq = [1 1.5 2 2.5 3 3.5 4 4.5 5];
repeat_freq = [1 2 3 4 5 6 7 8 9 10];

%code word is random. With good autocorolation