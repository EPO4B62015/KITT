function [acc_tijd, rem_tijd] = rem_acc_tijd(afstand)
load data_time.mat
afstand1 = round(afstand, 2);
if(afstand1 > 5.95)
    find_time = 5.95;
end
if(afstand1 < 0.51)
    find_time = 0;
    disp('Afstand is te klein - dus doe maar niks')
end
column = find(time_135(1, 1:end) == find_time);
acc_tijd = time_135(2, column);
rem_tijd = time_135(3, column);

end