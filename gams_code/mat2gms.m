function [ M2G ] = mat2gms( G_n, B_n, Yf, Yt, NT, mpc_base)
%% Input data
%--------------------------------------------------------------------------
% Set definition-----------------------------------------------------------
%--------------------------------------------------------------------------
% Bus index
M2G.BI.name = 'BI';
M2G.BI.uels = strseq('B',NT.BusInd);  % Set indices like B1,B2,..
M2G.BI.ts = 'All bus Index';

% Generator index
M2G.GI.name = 'GI';
M2G.GI.uels = strseq('B',NT.GenInd);
M2G.GI.ts = 'Generator bus index';

% Load index
M2G.LI.name = 'LI';
M2G.LI.uels = strseq('B',NT.LoadInd);
M2G.LI.ts = 'Load bus index';

% PV bus index
M2G.PVI.name = 'PVI';
M2G.PVI.uels = strseq('B',NT.PVInd);
M2G.PVI.ts = 'PV bus index';

% Branch index
M2G.BrI.name = 'BrI';
M2G.BrI.uels = strseq('Br',NT.BranchInd);
M2G.BrI.ts = 'Branch index';

% SVC buses
M2G.SVCI.name = 'SVCI';
M2G.SVCI.uels = strseq('B',NT.SvcInd);
M2G.SVCI.ts = 'SVC bus index';

% Non-Generator buses
M2G.NGI.name = 'NGI';
M2G.NGI.uels = strseq('B',NT.NGInd);
M2G.NGI.ts = 'Non-generator bus index';

% LTC from and to branches
M2G.LTCI.name = 'LTCI';
M2G.LTCI.uels = strseq('B',NT.LTCInd);
M2G.LTCI.ts = 'LTC bus index';

%% Create arrays for GAMS structures
% Array of bus vs generator indices
busgenary_n = zeros(NT.ng,3);
busgenary_n(1:NT.ng,1)=NT.GenInd;
busgenary_n(1:NT.ng,2)=NT.GenInd;
busgenary_n(1:NT.ng,3)=1;

% Array of bus vs load indices
busloadary_n = zeros(NT.nl,3);
busloadary_n(1:NT.nl,1)=NT.LoadInd;
busloadary_n(1:NT.nl,2)=NT.LoadInd;
busloadary_n(1:NT.nl,3)=1;

% Array of bus vs SVC indices
bussvcary_n = zeros(NT.nsvc,3);
bussvcary_n(1:NT.nsvc,1)=NT.SvcInd;
bussvcary_n(1:NT.nsvc,2)=NT.SvcInd;
bussvcary_n(1:NT.nsvc,3)=1;

% Array of bus vs LTC indices
busltcary_n(:,1) = NT.LTCInd;
busltcary_n(:,2) = NT.LTCInd;
busltcary_n(:,3) = ones(NT.nltc,1);

% Create array of branch flow limits
f=mpc_base.branch(:,1);
t=mpc_base.branch(:,2);
smax = mpc_base.branch(:,6)/100;

brnchary_n(:,1)= [f;t];
brnchary_n(:,2)= [t;f];
brnchary_n(:,3)= ones(2*NT.nbr,1);

Slin_max_n(:,1)=[f;t];
Slin_max_n(:,2)=[t;f];
Slin_max_n(:,3)=[smax;smax];

% create weight array
wl_n = zeros(NT.nl,1);

% create ZIP model parameter array
p1_n = [0.5;0.325]; q1_n = [0.5;1];
p2_n = [0;0];       q2_n = [0;0];
p3_n = [0.5;0.675]; q3_n  = [0.5;0];

% Create matrices of various from and to side Ymatrix entries
[r,c,ele]=find(G_n); 
G_sp = [r,c,ele];
[r,c,ele]=find(B_n);
B_sp = [r,c,ele];

[r,c,ele]=find(full(real(Yf)));
Gf_sp = [r,c,ele];

[r,c,ele]=find(full(real(Yt)));
Gt_sp = [r,c,ele];

[r,c,ele] = find(full(imag(Yf)));
Bf_sp = [r,c,ele];

[r,c,ele] = find(full(imag(Yt)));
Bt_sp = [r,c,ele];

%% Create GAMS structures

M2G.busgenary.name = 'busgenary';
M2G.busgenary.val = busgenary_n;
M2G.busgenary.type = 'parameter';
M2G.busgenary.dim = 2;
M2G.busgenary.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.busgenary.form = 'sparse';
M2G.busgenary.ts = 'Indicator matrix of generators';

M2G.busloadary.name = 'busloadary';
M2G.busloadary.val = busloadary_n;
M2G.busloadary.type = 'parameter';
M2G.busloadary.dim = 2;
M2G.busloadary.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.busloadary.form = 'sparse';
M2G.busloadary.ts = 'Indicator matrix of loads';

M2G.bussvcary.name = 'bussvcary';
M2G.bussvcary.val = bussvcary_n;
M2G.bussvcary.type = 'parameter';
M2G.bussvcary.dim = 2;
M2G.bussvcary.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.bussvcary.form = 'sparse';
M2G.bussvcary.ts = 'Indicator matrix of SVC devices';

M2G.brnchary.name = 'brnchary';
M2G.brnchary.val = brnchary_n;
M2G.brnchary.type = 'parameter';
M2G.brnchary.dim = 2;
M2G.brnchary.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.brnchary.form = 'sparse';
M2G.brnchary.ts = 'Indicator matrix of branches';

M2G.Slin_max.name = 'Slin_max';
M2G.Slin_max.val = Slin_max_n;
M2G.Slin_max.type = 'parameter';
M2G.Slin_max.dim = 2;
M2G.Slin_max.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.Slin_max.form = 'sparse';
M2G.Slin_max.ts = 'Indicator matrix of Max line loading only for credible contingencies';

M2G.wl.name = 'wl';
M2G.wl.val = wl_n;
M2G.wl.type = 'parameter';
M2G.wl.uels = M2G.LI.uels;
M2G.wl.form = 'full';
M2G.wl.ts = 'Weights assigned to loads';

M2G.busltcary.name = 'busltcary';
M2G.busltcary.val = busltcary_n;
M2G.busltcary.type = 'parameter';
M2G.busltcary.dim = 2;
M2G.busltcary.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.busltcary.form = 'sparse';
M2G.busltcary.ts = 'Indicator matrix of LTC';
%% Parameters---------------------------------------------------------------
%--------------------------------------------------------------------------
% Ybus---------------------------------------------------------------
%--------------------------------------------------------------------------

M2G.G.name = 'G';
M2G.G.val = G_sp;
M2G.G.type = 'parameter';
M2G.G.dim = 2;
M2G.G.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.G.form = 'sparse';
M2G.G.ts = 'Conductance matrix';
%
M2G.B.name = 'B';
M2G.B.val = B_sp;
M2G.B.type = 'parameter';
M2G.B.dim = 2;
M2G.B.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.B.form = 'sparse';
M2G.B.ts = 'Susceptance matrix';

M2G.Gf.name = 'Gf';
M2G.Gf.val = Gf_sp;
M2G.Gf.type = 'parameter';
M2G.Gf.dim = 2;
M2G.Gf.uels = {M2G.BrI.uels,M2G.BI.uels};
M2G.Gf.form = 'sparse';
M2G.Gf.ts = 'Conductance matrix';

M2G.Gt.name = 'Gt';
M2G.Gt.val = Gt_sp;
M2G.Gt.type = 'parameter';
M2G.Gt.dim = 2;
M2G.Gt.uels = {M2G.BrI.uels,M2G.BI.uels};
M2G.Gt.form = 'sparse';
M2G.Gt.ts = 'Conductance matrix';

M2G.Bf.name = 'Bf';
M2G.Bf.val = Bf_sp;
M2G.Bf.type = 'parameter';
M2G.Bf.dim = 2;
M2G.Bf.uels = {M2G.BrI.uels,M2G.BI.uels};
M2G.Bf.form = 'sparse';
M2G.Bf.ts = 'Conductance matrix';

M2G.Bt.name = 'Bt';
M2G.Bt.val = Bt_sp;
M2G.Bt.type = 'parameter';
M2G.Bt.dim = 2;
M2G.Bt.uels = {M2G.BrI.uels,M2G.BI.uels};
M2G.Bt.form = 'sparse';
M2G.Bt.ts = 'Conductance matrix';

% Load parameters
M2G.p1.name = 'p1';
M2G.p1.val = p1_n;
M2G.p1.uels = M2G.LI.uels;
M2G.p1.type = 'parameter';
M2G.p1.form = 'full';

M2G.q1.name = 'q1';
M2G.q1.val = q1_n;
M2G.q1.uels = M2G.LI.uels;
M2G.q1.type = 'parameter';
M2G.q1.form = 'full';

M2G.p2.name = 'p2';
M2G.p2.val = p2_n;
M2G.p2.uels = M2G.LI.uels;
M2G.p2.type = 'parameter';
M2G.p2.form = 'full';

M2G.q2.name = 'q2';
M2G.q2.val = q2_n;
M2G.q2.uels = M2G.LI.uels;
M2G.q2.type = 'parameter';
M2G.q2.form = 'full';

M2G.p3.name = 'p3';
M2G.p3.val = p3_n;
M2G.p3.uels = M2G.LI.uels;
M2G.p3.type = 'parameter';
M2G.p3.form = 'full';

M2G.q3.name = 'q3';
M2G.q3.val = q3_n;
M2G.q3.uels = M2G.LI.uels;
M2G.q3.type = 'parameter';
M2G.q3.form = 'full';

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Input to GAMS
% Real power generation

Pgmax_n = mpc_base.gen(:,9)/100;
Pgmin_n = mpc_base.gen(:,10)/100;

% Reactive power generation

Qgmax_n = mpc_base.gen(:,4)/100;
Qgmin_n = mpc_base.gen(:,5)/100;

% Bus voltages
Vmax_n =  1.15*ones(NT.nb,1);
Vmin_n =  0.7*ones(NT.nb,1);

% Loads
pf_n=cos(atan(mpc_base.bus(NT.LoadInd,4)./mpc_base.bus(NT.LoadInd,3)));
Plmax_n = 1.5*mpc_base.bus(NT.LoadInd,3)/100;
Plmin_n = 0.5*mpc_base.bus(NT.LoadInd,3)/100;
Qlmax_n = 1.5*mpc_base.bus(NT.LoadInd,4)/100;
Qlmin_n = 0.5*mpc_base.bus(NT.LoadInd,4)/100;

% SVCs
Bsvcmax_n = 1.2*mpc_base.svc(1:NT.nsvc,4)/100;
Bsvcmin_n = 0.9*mpc_base.svc(1:NT.nsvc,4)/100;

% Generator parameters
Sgmax_n = [6000;3000;3000]/100;

% Tap changer
Bltc_n(:,1) = mpc_base.ltc(:,1);
Bltc_n(:,2) = mpc_base.ltc(:,2);
Bltc_n(:,3) = mpc_base.ltc(:,4);
Bltc_n = [Bltc_n;[4 4 -20];[10 10 -20]];


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
M2G.pf.name = 'pf';
M2G.pf.val = pf_n;
M2G.pf.uels = M2G.LI.uels;
M2G.pf.type = 'parameter';
M2G.pf.form = 'full';

M2G.Pgmax.name = 'Pgmax';
M2G.Pgmax.val = Pgmax_n;
M2G.Pgmax.uels = M2G.GI.uels;
M2G.Pgmax.type = 'parameter';
M2G.Pgmax.form = 'full';


M2G.Pgmin.name = 'Pgmin';
M2G.Pgmin.val = Pgmin_n;
M2G.Pgmin.uels = M2G.GI.uels;
M2G.Pgmin.type = 'parameter';
M2G.Pgmin.form = 'full';

M2G.Qgmax.name = 'Qgmax';
M2G.Qgmax.val = Qgmax_n;
M2G.Qgmax.uels = M2G.GI.uels;
M2G.Qgmax.type = 'parameter';
M2G.Qgmax.form = 'full';


M2G.Qgmin.name = 'Qgmin';
M2G.Qgmin.val = Qgmin_n;
M2G.Qgmin.uels = M2G.GI.uels;
M2G.Qgmin.type = 'parameter';
M2G.Qgmin.form = 'full';


M2G.Vmax.name = 'Vmax';
M2G.Vmax.val = Vmax_n;
M2G.Vmax.uels = M2G.BI.uels;
M2G.Vmax.type = 'parameter';
M2G.Vmax.form = 'full';


M2G.Vmin.name = 'Vmin';
M2G.Vmin.val = Vmin_n;
M2G.Vmin.uels = M2G.BI.uels;
M2G.Vmin.type = 'parameter';
M2G.Vmin.form = 'full';


M2G.Plmax.name = 'Plmax';
M2G.Plmax.val = Plmax_n;
M2G.Plmax.uels = M2G.LI.uels;
M2G.Plmax.type = 'parameter';
M2G.Plmax.form = 'full';


M2G.Plmin.name = 'Plmin';
M2G.Plmin.val = Plmin_n;
M2G.Plmin.uels = M2G.LI.uels;
M2G.Plmin.type = 'parameter';
M2G.Plmin.form = 'full';

M2G.Qlmax.name = 'Qlmax';
M2G.Qlmax.val = Qlmax_n;
M2G.Qlmax.uels = M2G.LI.uels;
M2G.Qlmax.type = 'parameter';
M2G.Qlmax.form = 'full';


M2G.Qlmin.name = 'Qlmin';
M2G.Qlmin.val = Qlmin_n;
M2G.Qlmin.uels = M2G.LI.uels;
M2G.Qlmin.type = 'parameter';
M2G.Qlmin.form = 'full';

M2G.Bsvcmax.name = 'Bsvcmax';
M2G.Bsvcmax.val = Bsvcmax_n;
M2G.Bsvcmax.uels = M2G.SVCI.uels;
M2G.Bsvcmax.type = 'parameter';
M2G.Bsvcmax.form = 'full';

M2G.Bsvcmin.name = 'Bsvcmin';
M2G.Bsvcmin.val = Bsvcmin_n;
M2G.Bsvcmin.uels = M2G.SVCI.uels;
M2G.Bsvcmin.type = 'parameter';
M2G.Bsvcmin.form = 'full';

% Generator parameters
M2G.Sgmax.name = 'Sgmax';
M2G.Sgmax.val = Sgmax_n;
M2G.Sgmax.uels = M2G.GI.uels;
M2G.Sgmax.type = 'parameter';
M2G.Sgmax.form = 'full';

% LTC parameters
M2G.Bltc.name = 'Bltc';
M2G.Bltc.val = Bltc_n;
M2G.Bltc.type = 'parameter';
M2G.Bltc.dim = 2;
M2G.Bltc.uels = {M2G.BI.uels,M2G.BI.uels};
M2G.Bltc.form = 'sparse';
M2G.Bltc.ts = 'Susceptance matrix for LTC';
%--------------------------------------------------------------------------
%% Slack variables
%--------------------------------------------------------------------------
M2G.svmax.name = 'svmax';
M2G.svmax.val =  0.05*ones(NT.nb,1); M2G.svmax.val(NT.GenInd,1) = 0.01; %svmax.val(2,1) = 0.1;
M2G.svmax.uels = M2G.BI.uels;
M2G.svmax.type = 'parameter';
M2G.svmax.form = 'full';

M2G.svmin.name = 'svmin';
M2G.svmin.val =  -0.05*ones(NT.nb,1); M2G.svmin.val(NT.GenInd,1) = -0.01; %svmin.val(2,1) = -0.1;
M2G.svmin.uels = M2G.BI.uels;
M2G.svmin.type = 'parameter';
M2G.svmin.form = 'full';

M2G.spgmax.name = 'spgmax';
M2G.spgmax.val = 0.1*abs(mpc_base.gen(:,2))/100; 
M2G.spgmax.uels = M2G.GI.uels;
M2G.spgmax.type = 'parameter';
M2G.spgmax.form = 'full';

M2G.spgmin.name = 'spgmin';
M2G.spgmin.val = -0.1*abs(mpc_base.gen(:,2))/100; 
M2G.spgmin.uels = M2G.GI.uels;
M2G.spgmin.type = 'parameter';
M2G.spgmin.form ='full';

M2G.sqgmax.name = 'sqgmax';
M2G.sqgmax.val = 0.1*abs(mpc_base.gen(:,3))/100;
M2G.sqgmax.uels = M2G.GI.uels;
M2G.sqgmax.type = 'parameter';
M2G.sqgmax.form = 'full';

M2G.sqgmin.name = 'sqgmin';
M2G.sqgmin.val = -0.1*abs(mpc_base.gen(:,3))/100;
M2G.sqgmin.uels = M2G.GI.uels;
M2G.sqgmin.type = 'parameter';
M2G.sqgmin.form = 'full';

M2G.splmax.name = 'splmax';
M2G.splmax.val = 0.05*abs(mpc_base.bus(NT.LoadInd,3))/100;
M2G.splmax.uels = M2G.LI.uels;
M2G.splmax.type = 'parameter';
M2G.splmax.form = 'full';

M2G.splmin.name = 'splmin';
M2G.splmin.val = -0.05*abs(mpc_base.bus(NT.LoadInd,3))/100;
M2G.splmin.uels = M2G.LI.uels;
M2G.splmin.type = 'parameter';
M2G.splmin.form = 'full';

M2G.sqlmax.name = 'sqlmax';
M2G.sqlmax.val = 0.05*abs(mpc_base.bus(NT.LoadInd,4))/100;
M2G.sqlmax.uels = M2G.LI.uels;
M2G.sqlmax.type = 'parameter';
M2G.sqlmax.form = 'full';

M2G.sqlmin.name = 'sqlmin';
M2G.sqlmin.val = -0.05*abs(mpc_base.bus(NT.LoadInd,4))/100;
M2G.sqlmin.uels = M2G.LI.uels;
M2G.sqlmin.type = 'parameter';
M2G.sqlmin.form = 'full';


M2G.sbsvcmax.name = 'sbsvcmax';
M2G.sbsvcmax.val = 0.05*abs(mpc_base.svc(:,4))/100;
M2G.sbsvcmax.uels = M2G.SVCI.uels;
M2G.sbsvcmax.type = 'parameter';
M2G.sbsvcmax.form = 'full';

M2G.sbsvcmin.name = 'sbsvcmin';
M2G.sbsvcmin.val = -0.05*abs(mpc_base.svc(:,4))/100;
M2G.sbsvcmin.uels = M2G.SVCI.uels;
M2G.sbsvcmin.type = 'parameter';
M2G.sbsvcmin.form = 'full';

%--------------------------------------------------------------------------
%% ini values also operating values----------------------------------------
%--------------------------------------------------------------------------
ini.Vmag = mpc_base.bus(:,8);
ini.delta = mpc_base.bus(:,9);
ini.Vr = ini.Vmag.*cos(ini.delta*pi/180);
ini.Vi = ini.Vmag.*sin(ini.delta*pi/180);
ini.Pg = mpc_base.gen(:,2)/100;
ini.Qg = mpc_base.gen(:,3)/100;
ini.Pl = mpc_base.bus(NT.LoadInd,3)/100;
ini.Ql = mpc_base.bus(NT.LoadInd,4)/100;
ini.Bsvc = mpc_base.svc(:,4)/100;


M2G.Vmag_ini.name = 'Vmag_ini';
M2G.Vmag_ini.val = ini.Vmag;
M2G.Vmag_ini.uels = M2G.BI.uels;
M2G.Vmag_ini.type = 'parameter';
M2G.Vmag_ini.form = 'full';


M2G.Vr_ini.name = 'Vr_ini';
M2G.Vr_ini.val = ini.Vr;
M2G.Vr_ini.uels = M2G.BI.uels;
M2G.Vr_ini.type = 'parameter';
M2G.Vr_ini.form = 'full';

M2G.Vi_ini.name = 'Vi_ini';
M2G.Vi_ini.val = ini.Vi;
M2G.Vi_ini.uels = M2G.BI.uels;
M2G.Vi_ini.type = 'parameter';
M2G.Vi_ini.form = 'full';


M2G.Pg_ini.name = 'Pg_ini';
M2G.Pg_ini.val = ini.Pg;
M2G.Pg_ini.uels = M2G.GI.uels;
M2G.Pg_ini.type = 'parameter';
M2G.Pg_ini.form = 'full';

M2G.Qg_ini.name = 'Qg_ini';
M2G.Qg_ini.val = ini.Qg;
M2G.Qg_ini.uels = M2G.GI.uels;
M2G.Qg_ini.type = 'parameter';
M2G.Qg_ini.form = 'full';

M2G.Pl_ini.name = 'Pl_ini';
M2G.Pl_ini.val = ini.Pl;
M2G.Pl_ini.uels = M2G.LI.uels;
M2G.Pl_ini.type = 'parameter';
M2G.Pl_ini.form = 'full';

M2G.Ql_ini.name = 'Ql_ini';
M2G.Ql_ini.val = ini.Ql;
M2G.Ql_ini.uels = M2G.LI.uels;
M2G.Ql_ini.type = 'parameter';
M2G.Ql_ini.form = 'full';

M2G.Bsvc_ini.name = 'Bsvc_ini';
M2G.Bsvc_ini.val = ini.Bsvc;
M2G.Bsvc_ini.uels = M2G.SVCI.uels;
M2G.Bsvc_ini.type = 'parameter';
M2G.Bsvc_ini.form = 'full';

%% Writing data to gdx files
wgdx('mat2gms_sets.gdx',M2G.BI,M2G.GI,M2G.LI,M2G.PVI,M2G.SVCI,M2G.BrI,M2G.LTCI);
wgdx('mat2gms_tables.gdx',M2G.busgenary,M2G.busloadary,M2G.bussvcary,M2G.brnchary,M2G.Slin_max,M2G.wl,M2G.busltcary);
wgdx('mat2gms_Ybus.gdx',M2G.G,M2G.B,M2G.Gf,M2G.Gt,M2G.Bf,M2G.Bt);
wgdx('mat2gms_varlim.gdx',M2G.pf,M2G.Pgmax,M2G.Pgmin,M2G.Qgmax,M2G.Qgmin,M2G.Vmax,M2G.Vmin,...
    M2G.Plmax,M2G.Plmin,M2G.Qlmax,M2G.Qlmin,M2G.Bsvcmax,M2G.Bsvcmin,M2G.Sgmax,M2G.Bltc);
wgdx('mat2gms_slack.gdx',M2G.svmax,M2G.svmin,M2G.spgmax,M2G.spgmin,M2G.sqgmax,M2G.sqgmin,M2G.splmax,...
    M2G.splmin,M2G.sqlmax,M2G.sqlmin,M2G.sbsvcmax,M2G.sbsvcmin);
wgdx('mat2gms_ini.gdx',M2G.Vmag_ini,M2G.Pg_ini,M2G.Qg_ini,M2G.Pl_ini,M2G.Ql_ini,M2G.Vr_ini,M2G.Vi_ini,M2G.Bsvc_ini);
wgdx('mat2gms_zip_para.gdx',M2G.p1,M2G.p2,M2G.p3,M2G.q1,M2G.q2,M2G.q3);


%  gdxInfo /home/aditya/MATLAB/matpower/mat2gms_sets.gdx;
%  gdxInfo /home/aditya/MATLAB/matpower/mat2gms_tables.gdx;
%  gdxInfo /home/aditya/MATLAB/matpower/mat2gms_para.gdx;
% gdxInfo /home/aditya/Desktop/MATLAB/matpower/mat2gms_Ybus.gdx;

end

