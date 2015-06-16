function drive_car(speedsetting, steersetting, time_to_drive)
%DRIVE_CAR Summary of this function goes here
%   Detailed explanation goes here

global car
drive(speedsetting, steersetting);
pause(time_to_drive);
drive(150, car.steer_straight);

end

