function reference = load_ref_5ch
load('Ref_rec_5ch.mat') 
begin_ref = 2450;
end_ref = 3200;

reference = Ref_rec_5ch(begin_ref:end_ref)';
end