function [db] = read_wafms(pth, event_id)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fname = strcat(pth,'/',event_id);
fdata = csvread(fname,1,0);

for i=2:size(fdata,2)
    db.fr{i-1,1} = fdata(:,i);
end
db.pmu_name = {'Mumbai', 'Kanpur', 'Kharagpur', 'Guwahati', 'Surathkal', 'Delhi'};
db.tstmp = gps2utc(fdata(:,1));


% plot dataset
% figure(1)
% subplot(2,1,1)
% cellPlot(db.tstmp, db.fr);
% subplot(2,1,2)
% [db.fr] = outlier2Nan(db.fr, 45);
% cellPlot(db.tstmp, db.fr);
end

