function [ db ] = read_getco( pth, dte )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

addpath(pth);
% extract power flows
pth0 = pwd;  % store current folder path
cd(sprintf('%s/%d',pth,dte)); % change to the folder where data is stored
fileList = dir('*.cfg'); % list all files with the extension .cfg
i=1;

for i=1:size(fileList,1)%[101,113,213]
    fname{i,1} = fileList(i).name; %
    split_fname = strsplit(fname{i,1},'-');
    db.pmu_name{i,1} = strcat(split_fname{1},'_',split_fname{2});
    read_comtrade(fname{i,1}); % read cfg file
    Vmrs = whos(); % get all workspace Vmriables in Vmrs
    for j=1:size(Vmrs,1)
        str = Vmrs(j,1).name; % get first Vmriable name
        if ~isempty(regexp(str,'VAVm'))
            db.Vm{i,1}(:,1) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VBVm'))
            db.Vm{i,1}(:,2) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VCVm'))
            db.Vm{i,1}(:,3) = eval(str);
        elseif ~isempty(regexp(str,'VPVm'))
            db.Vm{i,1}(:,4) = eval(str);
        elseif ~isempty(regexp(str,'VAVa'))
            db.Va{i,1}(:,1) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VBVa'))
            db.Va{i,1}(:,2) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'VCVa'))
            db.Va{i,1}(:,3) = eval(str);
        elseif ~isempty(regexp(str,'VPVa'))
            db.Va{i,1}(:,4) = eval(str);
        elseif ~isempty(regexp(str,'IAVm'))
            db.Im{i,1}(:,1) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'IBVm'))
            db.Im{i,1}(:,2) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'ICVm'))
            db.Im{i,1}(:,3) = eval(str);
        elseif ~isempty(regexp(str,'IPVm'))
            db.Im{i,1}(:,4) = eval(str);
        elseif ~isempty(regexp(str,'IAVa'))
            db.Ia{i,1}(:,1) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'IBVa'))
            db.Ia{i,1}(:,2) = eval(str); % find if a Vmriable ends with MW_
        elseif ~isempty(regexp(str,'ICVa'))
            db.Ia{i,1}(:,3) = eval(str);
        elseif ~isempty(regexp(str,'IPVa'))
            db.Ia{i,1}(:,4) = eval(str);
        elseif ~isempty(regexp(str,'MW_'))
            db.P{i,1}(:,1) = eval(str);
        elseif ~isempty(regexp(str,'MX_'))
            db.Q{i,1}(:,1) = eval(str);
        elseif ~isempty(regexp(str,'FrequencyF'))
            db.fr{i,1}(:,1) = eval(str);
        end
    end
    clearvars -except fileList i db pth0
    i
end

cd(pth0); % change back to the current folder
end

