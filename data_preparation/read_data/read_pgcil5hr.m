function [ db ] = read_pgcil5hr( pth, pmu_list, dte )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% extract power flows
current_pth = pwd;  % store current folder path
cd(pth); % change to the folder where data is stored

num_pmu = length(pmu_list);

for count = 1:num_pmu % PMU id
    count
    for i=dte  % date
        for hr_num=4:9  % hour
            if (hr_num ~= 23)
                fld_name2 = strcat('/EXPORT-PMUs-','201801',sprintf('%02d%02d3000', i, hr_num),...
                    '-','201801',sprintf('%02d%02d3000', i, hr_num+1),'-CSV/');
                
                fle_name = strcat(num2str(pmu_list(count)),'-','201801',sprintf('%02d%02d3000', i, hr_num),...
                    '-','201801',sprintf('%02d%02d3000', i, hr_num+1),'.csv');
                
            else
                fld_name2 = strcat('/EXPORT-PMUs-','201801',sprintf('%02d%02d3000', i, hr_num),...
                    '-','201801',sprintf('%02d%02d3000', i+1, 0),'-CSV/');
                
                fle_name = strcat(num2str(pmu_list(count)),'-','201801',sprintf('%02d%02d3000', i, hr_num),...
                    '-','201801',sprintf('%02d%02d3000', i+1, 0),'.csv');
            end
            
            pth = strcat('.', fld_name2, fle_name);
            data_hr = csvread(pth,1,3);
            
            db.Vm{count,hr_num-3} = data_hr(:,[4,6,8,10]-1);
            db.Va{count,hr_num-3} = data_hr(:,[5,7,9,11]-1);
            db.Im{count,hr_num-3} = data_hr(:,[12,14,16,18]-1);
            db.Ia{count,hr_num-3} = data_hr(:,[13,15,17,19]-1);
            db.P{count,hr_num-3} = data_hr(:,19);
            db.Q{count,hr_num-3} = data_hr(:,20);
            db.fr{count,hr_num-3} = data_hr(:,1);
            db.pmu_name = num2cell(pmu_list);
        end   
    end
end
cd(current_pth); % change back to the current folder

end

