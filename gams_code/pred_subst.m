function [ mpc_base] = pred_subst( mpc_base,NT,init,t )

% using predictions
mpc_base.bus(:,8) = cellfun(@(v)v(t),init.Vm);       
mpc_base.bus(:,9) = cellfun(@(v)v(t),init.Va);
mpc_base.bus(NT.LoadInd,3) = cellfun(@(v)v(t),init.Pl);       
mpc_base.bus(NT.LoadInd,4) = cellfun(@(v)v(t),init.Ql);

mpc_base.branch(9,9) = cellfun(@(v)v(t),init.tap);

mpc_base.gen(:,2) = cellfun(@(v)v(t),init.Pg);
mpc_base.gen(:,3) = cellfun(@(v)v(t),init.Qg); 
mpc_base.gen(:,6) = cellfun(@(v)v(t),init.Vm(NT.GenInd));
end

