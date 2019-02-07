function [ db ] = read_pgcil7day( pth, pmu_num, dte )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


% extract power flows
current_pth = pwd;  % store current folder path
cd(pth); % change to the folder where data is stored

num_pmu = length(pmu_num);

for count = 1:num_pmu
    for i=dte
        fld_name1 = sprintf('/%02d-09-17',i);
        for hr_num=0:23
            hr_num
            if (hr_num ~= 23)
                fld_name2 = strcat('/EXPORT-PMUs-','201709',sprintf('%02d%02d0000', i, hr_num),...
                    '-','201709',sprintf('%02d%02d0000', i, hr_num+1),'-CSV/');
                
                fle_name = strcat(num2str(pmu_num),'-','201709',sprintf('%02d%02d0000', i, hr_num),...
                    '-','201709',sprintf('%02d%02d0000', i, hr_num+1),'.csv');
                
            else
                fld_name2 = strcat('/EXPORT-PMUs-','201709',sprintf('%02d%02d0000', i, hr_num),...
                    '-','201709',sprintf('%02d%02d0000', i+1, 0),'-CSV/');
                
                fle_name = strcat(num2str(pmu_num),'-','201709',sprintf('%02d%02d0000', i, hr_num),...
                    '-','201709',sprintf('%02d%02d0000', i+1, 0),'.csv');
            end
            
            pth = strcat('.',fld_name1, fld_name2, fle_name);
            data_hr = csvread(pth,1,2);
            
            db.Vm{count,hr_num+1} = data_hr(:,[4,6,8,10]);
            db.Va{count,hr_num+1} = angle_correction_dbserver (data_hr(:,[5,7,9,11]));
            db.Im{count,hr_num+1} = data_hr(:,[12,14,16,18]);
            db.Ia{count,hr_num+1} = angle_correction_dbserver (data_hr(:,[13,15,17,19]));
            db.P{count,hr_num+1} = data_hr(:,20);
            db.Q{count,hr_num+1} = data_hr(:,21);
            db.fr{count,hr_num+1} = data_hr(:,2);
        end 
    end
    db.pmu_name{count} = num2str(pmu_num(count));
end
cd(current_pth); % change back to the current folder
end

