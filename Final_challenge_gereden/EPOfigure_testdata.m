%Create EPOFIGURE from testdata
close all;
%load testdata
%load Test3.mat
post_test = position;%test_data.pos_tdoa;
i = 1;
EPO4figure; %Load the figure
EPO4figure.setMicLoc(static_positions.mic_positions/100) %Update Mic Positions
EPO4figure.setDestination(static_positions.destination/100);

[n,m] = size(post_test);
EPO4figure.setKITT(static_positions.origin(1:2,1)/100, 1);


for i = 1:m
    
    EPO4figure.setKITT([post_test(1,i)/100 post_test(2,i)/100], 0); %Update car position
    pause(0.01);
end