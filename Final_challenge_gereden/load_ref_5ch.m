function reference = load_ref_5ch
% load('Ref_rec_5ch.mat') 
% begin_ref = 2450;
% end_ref = 3000;
% reference = Ref_rec_5ch(begin_ref:end_ref)';

% load('ch5_refsignal2.mat') 
% begin_ref = 2800;
% end_ref = 3400;
% reference = Ref_signal(begin_ref:end_ref)';

% load('Impulse_eigenauto.mat')
% reference = ref_sig_eigenauto;

load('ref.mat')
reference = ref;
end