function [ O, Yp ] = makeY( I, pmu_name, tp, Yp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

num_pmus = size(I,1); % total number of PMUs
k=1;
for i=1:num_pmus
    if (~isempty(I{i}) && tp ~= 5) % For three phase channels
        ncol = size(I{i},2);
        if ncol == 1
            O.val(:,k) = I{i}(1:Yp.nsamp_hr,:); % stack time-series side-by-side
            O.name_indx(k) = {strcat(pmu_name{i},'')}; % stack their names side by side (phase-wise)
        elseif ncol == 3
            O.val(:,3*k-2:3*k) = I{i}(1:Yp.nsamp_hr,:); % stack time-series side-by-side
            O.name_indx(3*k-2:3*k) = {strcat(pmu_name{i},'_a'),strcat(pmu_name{i},'_b')...
                ,strcat(pmu_name{i},'_c')}; % stack their names side by side (phase-wise)
        elseif ncol == 4
            O.val(:,4*k-3:4*k) = I{i}(1:Yp.nsamp_hr,:); % stack time-series side-by-side
            O.name_indx(4*k-3:4*k) = {strcat(pmu_name{i},'_a'),strcat(pmu_name{i},'_b')...
                ,strcat(pmu_name{i},'_c'),strcat(pmu_name{i},'_p')}; % stack their names side by side (phase-wise)
        end

        
    elseif ~isempty(I{i}) && tp == 5 % for single channels
        O.val(:,k) = I{i}(1:Yp.nsamp_hr,:); % stack time-series side-by-side
        O.name_indx{k} = pmu_name{i}; % stack their names side by side (phase-wise)
    end
    k=k+1;
end

O.name_indx = O.name_indx';

%% Downsample dataset and update the parameters
O.val = downsample(O.val,Yp.ds_rate);
Yp.ds_sz = size(O.val,1);
Yp.ts = Yp.ts*Yp.ds_rate;
Yp.ds_dur = Yp.ds_sz*Yp.ts;
Yp.nsamp_slide = Yp.sec_slide/Yp.ts;

end

