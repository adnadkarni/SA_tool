function [ db ] = read_WR( pth )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

addpath(pth);

% extract power flows
current_pth = pwd;  % store current folder path
cd(pth); % change to the folder where data is stored
fileList = dir('*.cfg'); % list all files with the extension .cfg
cd(current_pth); % change back to the current folder
i=1;

for i=1:size(fileList,1)%[101,113,213]
    fname{i,1} = fileList(i).name; %
    split_fname = strsplit(fname{i,1},'_');
    db.pmu_name{i,1} = strcat(split_fname{1},'_',split_fname{2});
    read_comtrade_new(fname{i,1}); % read cfg file
    Vmrs = whos(); % get all workspace Vmriables in Vmrs
    for j=1:size(Vmrs,1)
        str = Vmrs(j,1).name; % get first Vmriable name
        if ~isempty(regexp(str,'VRVm'))
            db.Vm{i,1}(:,1) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VYVm'))
            db.Vm{i,1}(:,2) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VBVm'))
            db.Vm{i,1}(:,3) = eval(str);
        elseif ~isempty(regexp(str,'VPVm'))
            db.Vm{i,1}(:,4) = eval(str);
        elseif ~isempty(regexp(str,'VRVa'))
            db.Va{i,1}(:,1) = angle_correction_dbserver (eval(str)); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VYVa'))
            db.Va{i,1}(:,2) = angle_correction_dbserver (eval(str)); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VBVa'))
            db.Va{i,1}(:,3) = angle_correction_dbserver (eval(str));
        elseif ~isempty(regexp(str,'VPVa'))
            db.Va{i,1}(:,4) = angle_correction_dbserver (eval(str));
        elseif ~isempty(regexp(str,'IRVm'))
            db.Im{i,1}(:,1) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'IYVm'))
            db.Im{i,1}(:,2) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'IBVm'))
            db.Im{i,1}(:,3) = eval(str);
        elseif ~isempty(regexp(str,'IPVm'))
            db.Im{i,1}(:,4) = eval(str);
        elseif ~isempty(regexp(str,'IRVa'))
            db.Ia{i,1}(:,1) = angle_correction_dbserver (eval(str)); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'IYVa'))
            db.Ia{i,1}(:,2) = angle_correction_dbserver (eval(str)); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'IBVa'))
            db.Ia{i,1}(:,3) = angle_correction_dbserver (eval(str));
        elseif ~isempty(regexp(str,'IPVa'))
            db.Ia{i,1}(:,4) = angle_correction_dbserver (eval(str));
        elseif ~isempty(regexp(str,'MW_'))
            db.P{i,1}(:,1) = eval(str);
        elseif ~isempty(regexp(str,'MX_'))
            db.Q{i,1}(:,1) = eval(str);
        elseif ~isempty(regexp(str,'FrequencyF'))
            db.fr{i,1}(:,1) = eval(str);
        end
    end
    clearvars -except fileList i db
    i
end

end

