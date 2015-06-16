%Create EPOFIGURE from testdata
close all;
%load testdata
load test3.mat
i = 1;
EPO4figure; %Load the figure
EPO4figure.setMicLoc(static_positions.mic_positions/100) %Update Mic Positions
EPO4figure.setDestination(static_positions.destination/100);

[n,m] = size(position);



for i = 1:m
    if(i == 1)
        start = 1;
    else
        start = 0;
    end
    EPO4figure.setKITT([position(1,i)/100 position(2,i)/100], start); %Update car position
    pause(2.5);
end