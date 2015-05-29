function [hhat_fe, h_mf] = channel_estimation_5ch(y)
reference = load_ref_5ch; %Load the reference signal, response measured at 1 cm.
[hhat_fe, H_fe] = ch3(y,reference);
h_mf = matched_f(reference,y);
end