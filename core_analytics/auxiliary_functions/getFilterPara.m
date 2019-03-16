function [y] = getFilterPara()
% The function sets up various parameters required for the situational
% awareness scheme. It also sets the filter parameters.

%% variable definition
global selectDB;

%% power system variable selection based on choice of database

y.typeVar = {'Vm', 'Va', 'Im', 'Ia', 'fr', 'P', 'Q', 'Pg', 'Qg', 'tap'};
VarForDB = {1,3,6,6,6,6,9,6,5};
y.selectVar = VarForDB{selectDB};

%% prompt specs

prompt = {'trend-filter status','time-step (seconds):','downsample rate (interger):',...
    'window size (minutes):', 'lambda', 'mu', 'Hourly samples', 'slide time (seconds)'};

title = 'Enter trend-filter parameters';

dims = [1 55];

%% default input

defInput{1} = {'1', '0.04', '25',   '5' , '100' , '50', '22000', '5' };  % pgcil trend
defInput{2} = {'1', '0.04', '5',   '3' , '500' , '10', '90000', '60' };  % pgcil 7 day
defInput{7} = {'1', '0.04', '1',   '1/120' , '100' , '100', '7500', '5' };  % pgcil trend
defInput{8} = {'1', '0.04', '125', '15' , '250' , '100', '86800', '60' };  % getco trend
defInput{9} = {'1', '0.02', '2'  , '0.5', '1000', '100', '13800', '2' };   % wafms

in = str2double(inputdlg(prompt,title,dims,defInput{selectDB}));

%% Specify other inputs

y.statusTF = in(1);                                                         % whether trend filter
y.rateFrame = in(2);                                                        % time resolution
y.rateDownsample = in(3);                                                   % downsample rate
y.numSampWin = ceil((60*in(4))/(in(2)*in(3)));                               % window size specify in(4) in hours
y.lambda = in(5);                                                           % trend filter penalty
y.mu = in(6);                                                               % level filter penalty
y.numSampPerHour = in(7);                                                   % total samples in one hour
y.numSecSlide = in(8);                                                     % slide window by  in seconds
 
%% Select time-series to be filtered

selectTs{1} = [53:56,84,137];%[133:140];%[34,35];%[1:size(db.pmu_name,1)];                             % for PGCIL 10 bus;
selectTs{2} = [4,8,12,16];
selectTs{9} = [1:6];                                                        % for frequency data
selectTs{8} = [3:8];                                                        % for adani400

y.selectTS = selectTs{selectDB};
end

