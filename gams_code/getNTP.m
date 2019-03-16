function [mpc, NT] = getNTP()

mpc=case10;


% Bus data
NT.BusInd = mpc.bus(:,1);
NT.nb= size(NT.BusInd,1);

% Branch data
FrmB = mpc.branch(:,1);
ToB = mpc.branch(:,2);
NT.nbr = size(FrmB,1);
ind1=[]; ind2=[];

NT.BranchInd = [1:NT.nbr]';

% Gen data
NT.GenInd = mpc.gen(:,1);
NT.ng= size(NT.GenInd,1);
NT.slack = find(mpc.bus(:,2)==3);
NT.PVInd = find(mpc.bus(:,2)==2);
NT.npv=size(NT.PVInd,1);
NT.NGInd = find(~ismember(NT.BusInd,NT.GenInd));

% load data
ind1 = find(mpc.bus(:,3));
ind2 = find(mpc.bus(:,4));
NT.LoadInd =  union(ind1,ind2);
NT.nl = size(NT.LoadInd,1);

% svc data
NT.SvcInd = mpc.svc(:,1);
NT.nsvc = size(NT.SvcInd,1);

% LTC branch
NT.LTCInd = mpc.ltc(:,1); NT.nltc = size(NT.LTCInd,1);

% NT change status


end

