function [res_tab] = results_table(R)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
level_values = [R.V_gms(:,2);R.Pg_gms(:,2);R.Qg_gms(:,2);R.Pl_gms(:,2);R.Ql_gms(:,2)];
slack_values = [R.V_gms(:,3);R.Pg_gms(:,3);R.Qg_gms(:,3);R.Pl_gms(:,3);R.Ql_gms(:,3)];
res_tab = table(level_values,slack_values);
end

