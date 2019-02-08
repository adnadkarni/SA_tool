clearvars -except db
clc

%% Add paths
%1) Reading and data preproecessing
addpath(genpath('/home/aditya/Dropbox/SA_tool/Historian_mining/data_preparation/'));
addpath(genpath('/home/aditya/Dropbox/SA_tool/Historian_mining/auxiliary_functions'));
%2) T&L filter parameters and submodules
addpath(genpath('/home/aditya/Dropbox/SA_tool/Historian_mining/core_analytics/'));
%3) Output statistics and event-detection
addpath(genpath('/home/aditya/Dropbox/SA_tool/Historian_mining/output_statistics'));
%4) Course prediction of select time series
addpath(genpath('/home/aditya/Dropbox/SA_tool/Historian_mining/course_prediction'));
%5) Various plot functions
addpath(genpath('/home/aditya/Dropbox/SA_tool/Historian_mining/plot_functions'));

%% Select and read dataset
% 1 - PGCIL 10bus
% 2 - PGCIL 7 days
% 3 - PGCIL 5 hr
% 4 - WR
% 5 - GETCO
% 6 - Fault event
% 7 - Kundur data
% 8 - Adani400
% 9 - WAFMS

global db_select;
global db;
db_select = 7;
 [ db ] = read_db( db_select );

%% Preprocessing, setup and parameter input
typeVar = {'Vm', 'Va', 'Im', 'Ia', 'fr', 'P', 'Q', 'Pg', 'Qg', 'tap'};
var_db = {5,6,6,6,6,6,9,6,5};
selectVar = var_db{db_select};

run_lev = 0;

% Filter parameters--------------------------------------------------------
[Yp] = input_filter_para();

%% Execute the tool functions

for hr = 1:size(eval(sprintf('db.%s',typeVar{selectVar})),2)
    
    % Get hourly data, downsample and update the
    % parameters-----------------------------------------------------------
    [ Yi, Yp ] = makeY( eval(sprintf('db.%s(:,hr)',typeVar{selectVar})), db.pmu_name, selectVar, Yp );
      
    % Missing data scan----------------------------------------------------
    [ Yp, Ydl ] = missing_scan( Yi, Yp, selectVar );
    
    % Run trend filtering--------------------------------------------------    
    if Yp.tf_status
        % Perform trend filtering to return statistics
        [ Ytr{hr}, Yst{hr} ] = l1trnd_filtering( Yi, Yp);
    else
        Yst{hr} = [];
    end
    
    % Run level filtering--------------------------------------------------
%     if run_lev==1
%         % Perform level filtering to return statistics
%         [ Ylv{hr}, Ylv{hr} ] = l1level_filtering( Yi, Yi_lev, ts_indx, var_select );
%     else
%         Ylv{hr} = [];
%     end
    
end

%% aggregate calculated indicators
[results] = collect_output(Ytr, Yst);


%% Detection logic I - trend change
% plot attributes----------------------------------------------------------
plotInput_trnd = {'V_{mag}', 'I_{mag}', 'V_{ang}', 'I_{ang}', 'Frequency', 'MW-flow',...
    'MVar-flow', 'MW-gen', 'MVar-gen', 'taps';
    'kV', 'Amps', 'Deg', 'Deg', 'Hz', 'MW', 'MVar', 'MW', 'MVar', 'Int';
    '', '', '', '', 'df/dt', 'MW-ramp', 'MVar-ramp', '', '', '';
    'kV/min', 'Amps/min', 'deg/min', 'deg/min', 'mHz/sec', 'MW/min', 'MVar/min', '', '', '';
    '', '', '', '', 1e3/60, 1, '', '', '', '';
    '', '', '', '', 1, 1, '', '', '', '';
    '', '', '', '', 5, 1.7, '', '', '', '';
    '', '', '', '', -5, -1.7, '', '', '', ''};
% detection function
[Etr] = trnd_event_detect(results, Ytr, Yst, plotInput_trnd(:,selectVar));

%% Detection logic II - spike ----------------------------------------
plotInput_spk = {'V_{mag}', 'I_{mag}', 'V_{ang}', 'I_{ang}', 'Frequency', 'MW-flow',...
    'MVar-flow', 'MW-gen', 'MVar-gen', 'taps';
    'kV', 'Amps', 'Deg', 'Deg', 'Hz', 'MW', 'MVar', 'MW', 'MVar', 'Int';
    '', '', '', '', 'df/dt', 'MW-ramp', 'MVar-ramp', '', '', '';
    'kV/min', 'Amps/min', 'deg/min', 'deg/min', 'mHz/sec', 'MW/min', 'MVar/min', '', '', '';
    '', '', '', '', 1e3, 1, '', '', '', '';
    '', '', '', '', 1, -1, '', '', '', '';
    '', '', '', '', 5, 10, '', '', '', '';
    '', '', '', '', -5, -10, '', '', '', ''};
% detection function
[Espk] = spk_event_detect(results, Ytr, Yst, plotInput_spk(:,selectVar));

%% Dashboard
eventStatus = zeros(size(results.win_st,1),3);  % event status of each window
eventStatus(Etr.susp_win,1) = 1;
eventStatus(Espk.suspWin,3) = 1;

figure(3)
bar(eventStatus);

