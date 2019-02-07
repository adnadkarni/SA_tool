function [y] = input_filter_para()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% variable definition
global db_select;
global db;

prompt = {'trend-filter status','time-step (seconds):','downsample rate (interger):',...
    'window size (minutes):', 'lambda', 'mu', 'Hourly samples', 'slide time (seconds)'};
title = 'Enter trend-filter parameters';
dims = [1 55];

defInput{1} = {'1', '0.04', '1',   '0.5' , '1000' , '1000', '22000', '2' }; % pgcil trend
defInput{7} = {'1', '0.04', '1',   '1/120' , '100' , '100', '7500', '5' }; % pgcil trend
defInput{8} = {'1', '0.04', '125', '15' , '250' , '1000', '86800', '60' }; % getco trend
defInput{9} = {'1', '0.02', '2'  , '0.5', '1000', '1000', '13800', '2' }; % wafms

in = str2double(inputdlg(prompt,title,dims,defInput{db_select}));

y.tf_status = in(1); % whether trend filter
y.ts = in(2); % time resolution
y.ds_rate = in(3); % downsample rate
y.win_sz = ceil((60*in(4))/(in(2)*in(3))); % window size specify in(4) in hours
y.lambda = in(5); % trend filter penalty
y.mu = in(6); % level filter penalty
y.nsamp_hr = in(7); % total samples in one hour
y.sec_slide = in(8); % slide window by  in seconds
 
% Select time-series to be filtered----------------------------------------
ts_indx_matrix{1} = [30:40];%[1:size(db.pmu_name,1)]; % for PGCIL 10 bus;
ts_indx_matrix{9} = [1:6]; %for frequency data
ts_indx_matrix{8} = [3:8]; % for adani400

y.ts_indx = ts_indx_matrix{db_select};
end

