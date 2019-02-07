function [ Y_tr ] = ds_scale(Y_tr)
yavg = mean(Y_tr.val);
Y_tr.scfact = diag(1./yavg);

Y_tr.val = Y_tr.val*Y_tr.scfact;
end