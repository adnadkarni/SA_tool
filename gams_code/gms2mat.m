function [G2M,R]=gms2mat_operative_slack(NT)

G2M.Pgl.name = 'Pg';
G2M.Pgl.field = 'l';
G2M.Pgl.form = 'full';

% Pgm.name = 'Pg';
% Pgm.field = 'm';
% Pgm.form = 'full';

G2M.Qgl.name = 'Qg';
G2M.Qgl.field = 'l';
G2M.Qgl.form = 'full';

% Qgm.name = 'Qg';
% Qgm.field = 'm';
% Qgm.form = 'full';

G2M.Vl.name = 'Vmag';
G2M.Vl.field = 'l';
G2M.Vl.form = 'full';

G2M.Vrl.name = 'Vr';
G2M.Vrl.field = 'l';
G2M.Vrl.form = 'full';

G2M.Vil.name = 'Vi';
G2M.Vil.field = 'l';
G2M.Vil.form = 'full';

% Vm.name = 'Vmag';
% Vm.field = 'm';
% Vm.form = 'full';
 
G2M.Pll.name = 'Pl';
G2M.Pll.field = 'l';
G2M.Pll.form = 'full';

% Plm.name = 'Pl';
% Plm.field = 'm';
% Plm.form = 'full';

G2M.Qll.name = 'Ql';
G2M.Qll.field = 'l';
G2M.Qll.form = 'full';

% Qlm.name = 'Ql';
% Qlm.field = 'm';
% Qlm.form = 'full';

G2M.Bsvcl.name = 'Bsvc';
G2M.Bsvcl.field = 'l';
G2M.Bsvcl.form = 'full';

% Bsvcm.name = 'eBsvcmax';
% Bsvcm.field = 'm';
% Bsvcm.form = 'full';

G2M.MVAl.name = 'eMVA_max';
G2M.MVAl.field = 'l';
G2M.MVAl.form = 'sparse';

% G2M.MVAm.name = 'eMVA_max';
% G2M.MVAm.field = 'm';
% G2M.MVAm.form = 'full';

G2M.Pflow.name = 'Pflow';
G2M.Pflow.field = 'l';
G2M.Pflow.form = 'sparse';

G2M.Qflow.name = 'Qflow';
G2M.Qflow.field = 'l';
G2M.Qflow.form = 'sparse';

G2M.sv.name = 'sv';
G2M.sv.form = 'full';

G2M.spg.name = 'spg';
G2M.spg.form = 'full';

G2M.sqg.name = 'sqg';
G2M.sqg.form = 'full';

G2M.spl.name = 'spl';
G2M.spl.form = 'full';

G2M.sbsvc.name = 'sbsvc';
G2M.sbsvc.form = 'full';

G2M.Pgl = rgdx('matsol.gdx',G2M.Pgl);
% Pgm = rgdx('matsol.gdx',Pgm);

G2M.Qgl = rgdx('matsol.gdx',G2M.Qgl);
% Qgm = rgdx('matsol.gdx',Qgm);

G2M.Vl = rgdx('matsol.gdx',G2M.Vl);
% Vm = rgdx('matsol.gdx',Vm);

G2M.Vrl = rgdx('matsol.gdx',G2M.Vrl);

G2M.Vil = rgdx('matsol.gdx',G2M.Vil);

G2M.Pll = rgdx('matsol.gdx',G2M.Pll);
% Plm = rgdx('matsol.gdx',Plm);

G2M.Qll = rgdx('matsol.gdx',G2M.Qll);
% Qlm = rgdx('matsol.gdx',Qlm);
 
G2M.Bsvcl = rgdx('matsol.gdx',G2M.Bsvcl);
% Bsvcm = rgdx('matsol.gdx',Bsvcm);

% G2M.MVAl = rgdx('matsol.gdx',G2M.MVAl);
% G2M.MVAm = rgdx('matsol.gdx',G2M.MVAm);

% G2M.Pflow = rgdx('matsol.gdx',G2M.Pflow);
% 
% G2M.Qflow = rgdx('matsol.gdx',G2M.Qflow);

G2M.sv = rgdx('matsol.gdx',G2M.sv);

G2M.spg = rgdx('matsol.gdx',G2M.spg);

G2M.sqg = rgdx('matsol.gdx',G2M.sqg);

G2M.spl = rgdx('matsol.gdx',G2M.spl);

G2M.sbsvc = rgdx('matsol.gdx',G2M.sbsvc);

% r=G2M.MVAl.val(:,1); c=G2M.MVAl.val(:,2);
% G2M.MVA_gms = [r,c,G2M.MVAl.val(:,3)*100,diag(G2M.MVAm.val(r,c))];
% ind1 = mpc_base.branch(:,11)==1;
% MVA_gms = [MVA_gms,mpc_base.branch(ind1,6)];
% MVA_gms = [MVA_gms,MVA_gms(:,3)./MVA_gms(:,5)*100];
% MVA_gms = sortrows(MVA_gms,6);
% G2M.Pflow_gms = [G2M.Pflow.val(:,1:2),G2M.Pflow.val(:,3)*100];
% G2M.Qflow_gms = [G2M.Qflow.val(:,1:2),G2M.Qflow.val(:,3)*100];
% 

R.V_gms = [NT.BusInd,G2M.Vl.val,G2M.sv.val];
R.Vph_gms = [NT.BusInd, 180*atan(G2M.Vil.val./G2M.Vrl.val)/pi];
R.Pg_gms = [NT.GenInd,G2M.Pgl.val(NT.GenInd,:)*100,G2M.spg.val(NT.GenInd)*100];
R.Qg_gms = [NT.GenInd,G2M.Qgl.val(NT.GenInd,:)*100,G2M.sqg.val(NT.GenInd)*100];
R.Pl_gms = [NT.LoadInd,G2M.Pll.val(NT.LoadInd,:)*100,G2M.spl.val(NT.LoadInd)*100];
R.Ql_gms = [NT.LoadInd,G2M.Qll.val(NT.LoadInd,:)*100,zeros(NT.nl,1)];
end

