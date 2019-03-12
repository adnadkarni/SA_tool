Bus_name = [M2G.GI.uels';M2G.GI.uels';M2G.GI.uels';M2G.LI.uels'];
Var_type = [repmat('Pg',ng,1);repmat('Qg',ng,1);repmat('Vg',ng,1);repmat('Pl',nl,1)];
    
Var_min = [mpc_base.gen(:,11);mpc_base.gen(:,5);0.9*ones(ng,1);0.8*mpc_base.bus(LoadInd,3)];
Var_pred =  [[init.Pg;0;0;0];init.Qg;init.Vmag(GenInd);Plmax.val*100];
Var_mag = [Pg_gms(:,2)*100;Qg_gms(:,2)*100;V_gms(GenInd,2);Pl_gms(:,2)*100];
Var_max = [mpc_base.gen(:,10);mpc_base.gen(:,4);1.1*ones(ng,1);1.2*mpc_base.bus(LoadInd,3)];
Var_slack = -[Pg_gms(:,3)*100;Qg_gms(:,3)*100;V_gms(GenInd,3);Pl_gms(:,3)*100];
Var_slack_mag = abs(Var_slack);

control_matrix1 = table(Bus_name,Var_type,Var_min,Var_pred,Var_mag,Var_max,Var_slack,Var_slack_mag);

control_matrix = sortrows(control_matrix1,'Var_slack_mag','descend');
control_matrix(:,'Var_slack_mag') = [];

writetable(control_matrix,'control_matrix.txt');