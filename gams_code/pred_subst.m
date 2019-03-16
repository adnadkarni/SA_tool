function [ mpc] = pred_subst( mpc,NT,init,t )

% using predictions
mpc.bus(:,8) = cellfun(@(v)v(t),init.Vm);       
mpc.bus(:,9) = cellfun(@(v)v(t),init.Va);
mpc.bus(NT.LoadInd,3) = cellfun(@(v)v(t),init.Pl);       
mpc.bus(NT.LoadInd,4) = cellfun(@(v)v(t),init.Ql);

mpc.branch(9,9) = cellfun(@(v)v(t),init.tap);

mpc.gen(:,2) = cellfun(@(v)v(t),init.Pg);
mpc.gen(:,3) = cellfun(@(v)v(t),init.Qg); 
mpc.gen(:,6) = cellfun(@(v)v(t),init.Vm(NT.GenInd));
end

