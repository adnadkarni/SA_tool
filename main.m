clearvars -except db A1 A2
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
%6) Control scheme
addpath(genpath('/home/aditya/Desktop/SA_tool/gams_code'));

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
%    [ db ] = read_db( selectDB );

%% Parameter input
for count = 1:1
    
[yPara] = getFilterPara();

%% Execute the tool
dataIn = eval(sprintf('db.%s',yPara.typeVar{yPara.selectVar}));


for hr = 1:size(dataIn,2)
    
    % Get hourly data, downsample and update the parameters ---------------
    
    [ yData, yPara ] = makeData( yPara, hr );
    
    % Missing data scan----------------------------------------------------
    
    [ yPara, yDataloss ] = scanDataloss( yData, yPara);
    
    [ yData ] = imputeData( yData, yPara, yDataloss);
    
    % Run T&L filtering----------------------------------------------------
    
    if (yPara.statusTF)
        
        [ yTnL{hr}, yStat{hr}, yCP{hr} ] = TnLFilterScheme( yData, yPara);
        
    end
    
    %% Get mining results for the hour
    
    [gatherStat] = collectResults(yStat);

    %% Get signature authentication thresholds

    [thrMine] = getThr4Mine(1);

    %% Get all mining results
   
    [resultsTr] = getMiningResultsTr(gatherStat, thrMine);                  % trend
    
    [resultsSpk] = getMiningResultsSpk(gatherStat, thrMine);                % spike
    
    [resultsLev] = getMiningResultsLev(gatherStat, thrMine);                % level

    
    %% Plot the results for dashboard
    
    plotResMineAll(yData, yPara, resultsTr, resultsSpk, resultsLev);        % status plot
    
    numWinPlot = [93];
    
    plotResMineWin(yTnL{hr}{numWinPlot}, yPara, yStat{hr}{numWinPlot}, resultsTr,...
                                resultsSpk, resultsLev, numWinPlot);        % window plot
     
end

% for trend fit plots
% val = yTnL{1}{105}.val(:,2);
% W(:,count) = yTnL{1}{105}.W(:,2);
% tm = yTnL{1}{105}.indexTime;
% A1(:,count) = gatherStat.numTrendSeg;
% A2(:,count) = gatherStat.resSigma(:,1);
%  yPara.lambda 
end
%plotSelectLambda(A1(1:36,:), A2(1:36,:));
%plotDemoLambda(tm,[val,W]/1e6);