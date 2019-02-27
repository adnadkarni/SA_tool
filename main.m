clearvars -except db
clc

%cd('/home/aditya/Desktop/SA_tool/');
%% Add paths
%1) Reading and data preproecessing
addpath(genpath('/home/aditya/Desktop/SA_tool/data_preparation/'));
addpath(genpath('/home/aditya/Desktop/SA_tool/auxiliary_functions'));
%2) T&L filter parameters and submodules
addpath(genpath('/home/aditya/Desktop/SA_tool/core_analytics/'));
%3) Output statistics and event-detection
addpath(genpath('/home/aditya/Desktop/SA_tool/output_statistics'));
%4) Course prediction of select time series
addpath(genpath('/home/aditya/Desktop/SA_tool/course_prediction'));
%5) Various plot functions
addpath(genpath('/home/aditya/Desktop/SA_tool/plot_functions'));
%6) 

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

global selectDB;
global db;
selectDB = 1;

% read dataset
[ db ] = read_db( selectDB );

%% Parameter input

[yPara] = getFilterPara();

%% Execute the tool
dataIn = eval(sprintf('db.%s',yPara.typeVar{yPara.selectVar}));

for hr = 1:size(dataIn,2)
    
    % Get hourly data, downsample and update the parameters ---------------
    
    [ yData, yPara ] = makeData( yPara, hr );
      
    % Missing data scan----------------------------------------------------
    
    [ yPara, yDataloss ] = scanDataloss( yData, yPara);
    
    % Run T&L filtering----------------------------------------------------
    
    if (yPara.statusTF)
        
        [ yTnL{hr}, yStat{hr}, yExtr{hr} ] = TnLFilterScheme( yData, yPara);
        
    end
    
    %% Get mining results for the hour
    
    [gatherStat] = collectResults(yStat);
    
    %% Get signature thresholds

    [thrMine] = getThr4Mine(1);

    %% Get all mining results
   
    [resultsTr] = getMiningResultsTr(gatherStat, thrMine);                  % trend
    
    [resultsSpk] = getMiningResultsSpk(gatherStat, thrMine);                % spike
    
%     [resultsLev] = getMiningResultsLev(gatherStat, thrMine);                % level

    
    %% Plot the results for dashboard
    
    plotResMineAll(yData, yPara, resultsTr, resultsSpk);
    
end

