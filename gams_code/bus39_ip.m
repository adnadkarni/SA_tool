function [BusInd,GenInd,LoadInd,SvcInd,PVInd,NGInd,slack,nb,ng,nl,nsvc,npv,nbr] = bus39_ip( mpc_base )
BusInd = mpc_base.bus(:,1); 
nb= size(BusInd,1);
GenInd = mpc_base.gen(:,1); 
ng= size(GenInd,1);
ind1 = find(mpc_base.bus(:,3));
ind2 = find(mpc_base.bus(:,4));
LoadInd =  union(ind1,ind2);
nl = size(LoadInd,1);
SvcInd = mpc_base.svc(:,1); 
nsvc = size(SvcInd,1);
slack = find(mpc_base.bus(:,2)==3);
PVInd = find(mpc_base.bus(:,2)==2); 
npv=size(PVInd,1);
NGInd = [1:30]';

FrmB = mpc_base.branch(:,1);
ToB = mpc_base.branch(:,2); 
nbr=size(FrmB,1);
ind1=[]; ind2=[];
end

