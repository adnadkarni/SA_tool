function [NT] = bus_ip( mpc_base )

% Bus data
NT.BusInd = mpc_base.bus(:,1);
NT.nb= size(NT.BusInd,1);

% Branch data
FrmB = mpc_base.branch(:,1);
ToB = mpc_base.branch(:,2);
NT.nbr = size(FrmB,1);
ind1=[]; ind2=[];

NT.BranchInd = [1:NT.nbr]';

% Gen data
NT.GenInd = mpc_base.gen(:,1);
NT.ng= size(NT.GenInd,1);
NT.slack = find(mpc_base.bus(:,2)==3);
NT.PVInd = find(mpc_base.bus(:,2)==2);
NT.npv=size(NT.PVInd,1);
NT.NGInd = find(~ismember(NT.BusInd,NT.GenInd));

% load data
ind1 = find(mpc_base.bus(:,3));
ind2 = find(mpc_base.bus(:,4));
NT.LoadInd =  union(ind1,ind2);
NT.nl = size(NT.LoadInd,1);

% svc data
NT.SvcInd = mpc_base.svc(:,1);
NT.nsvc = size(NT.SvcInd,1);

% LTC branch
NT.LTCInd = mpc_base.ltc(:,1); NT.nltc = size(NT.LTCInd,1);
end

