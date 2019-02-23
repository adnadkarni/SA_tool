function [ yTr, yStat, yPred ] = l1trnd_filtering( yData, yPara )
%This function executes various trend filtering functions and returns
%various trend statistics.

%% preparation
numWin = 1;

%% scan with sliding window

for count = yPara.numSampWin:yPara.numSampSlide:yPara.numSampDataset%Yi.win_sz
    
    
    yTr{numWin}.indexWin = [count-yPara.numSampWin+1:count]';               % frame numbers in a window
    
    yTr{numWin}.durOfWin = (yPara.numSampWin)*(yPara.rateFrame);            % duration of window
    
    yTr{numWin}.val = yData.val(yTr{numWin}.indexWin,...
        yPara.selectTS);                                % extract data for the window
    
    yTr{numWin}.indexTime = (yTr{numWin}.indexWin)*(yPara.rateFrame);       % assign time stamps for window data
    
    yTr{numWin}.nameTS = yData.namePMU(yPara.selectTS);
    
    %% Trend filtering
    
    [ yTr{numWin} ] = scaleData(yTr{numWin});                               % scale data (normalize)
    
    [ yTr{numWin} ] = trend_filter(yTr{numWin}, yPara.lambda);              % trend filter function
    
    [ yTr{numWin} ] = rescaleData(yTr{numWin}, yPara.rateFrame);            % rescale data
    
    %% Calculate trend statistics
    
    [ yStat{numWin} ] = trend_statistics( yTr{numWin}, yPara );
    
    %% Run course prediction-----------------------------------------------
    
    yParaExtp = getExtpPara();                                              % get thresholds
    
    if (~isempty(yTr{numWin}.X))
        
        [yPred{numWin}] = trendExtrapolate(yTr{numWin},...
            yStat{numWin}, yParaExtp);                                      % extrapolate trends if trigger is set
        
    end
    
    %% End of trend filtering
    
    numWin = numWin + 1;
    compl_status = 100*count/(yPara.numSampDataset);
    sprintf('Trend filtering completion = %2.1f',compl_status)
end


%% extra
%             if numWin <= 100
%                 writetable(yPred{numWin}.cpTab,'expResults.xlsx',...
%                     'Sheet',numWin);
%             end
%        else
%            warning('All time series are bad');


end

