function [db] = read_wafms(pth, event_id)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fname = strcat(pth,'/',event_id);
fdata = csvread(fname,1,1);

for i=1:size(fdata,2)
    db.fr{i,1} = fdata(:,i);
end
db.pmu_name = {'Mumbai', 'Kanpur', 'Kharagpur', 'Guwahati', 'Surathkal', 'Delhi'};
end

