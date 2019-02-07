function [ y ] = missing_diagnostics_by_3ph( x,tp )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global ds_num_pts
global ds_num_pmu

if size(x,1) < ds_num_pts
    y.no_data = ds_num_pts-size(x,1);
else
    y.no_data = 0;
end

%% phase-wise statistic

switch tp
    case 1 % voltage magnitude phases
        y.ph = sum([x(:,1)==0 , x(:,2)== 0 ,  x(:,3)== 0],2) +...
            sum([isnan(x(:,1)), isnan(x(:,2)),  isnan(x(:,3))],2) +...
            sum([x(:,1) >= 4e5-100 & x(:,1) <= 4e5+100],2)+...
            sum([x(:,2) >= 4e5-100 & x(:,2) <= 4e5+100],2)+...
            sum([x(:,3) >= 4e5-100 & x(:,3) <= 4e5+100],2) + y.no_data;
        
    case 2 % current magnitude phases
        y.ph = sum([x(:,1)==0 , x(:,2)== 0 ,  x(:,3)== 0],2) +...
            sum([isnan(x(:,1)), isnan(x(:,2)),  isnan(x(:,3))],2 ) +...
            sum([abs(x(:,1)) >= 1e3, abs(x(:,2)) >= 1e3, abs(x(:,3)) >= 1e3],2) + y.no_data;
        
    case 3 % voltage angle phases
        y.ph = sum([x(:,1)==0 , x(:,2)== 0 ,  x(:,3)== 0],2) +...
            sum([isnan(x(:,1)), isnan(x(:,2)),  isnan(x(:,3))],2 ) + y.no_data;
        
    case 4 % current angle phases
        y.ph = sum([x(:,1)==0 , x(:,2)== 0 ,  x(:,3)== 0],2) +...
            sum([isnan(x(:,1)), isnan(x(:,2)),  isnan(x(:,3))],2 ) + y.no_data;
end

end

