function [ yTnL, yStat, yPred ] = TnLFilterScheme( yData, yPara )
%This function executes various trend filtering functions and returns
%various trend statistics.

%% preparation
numWin = 1;
yTnL = cell(1,1);

%% scan with sliding window

for count = yPara.numSampWin:yPara.numSampSlide:yPara.numSampDataset%Yi.win_sz
    
    
    yTnL{numWin}.indexWin = [count-yPara.numSampWin+1:count]';              % frame numbers in a window
    
    yTnL{numWin}.durOfWin = (yPara.numSampWin)*(yPara.rateFrame);           % duration of window
    
    yTnL{numWin}.val = yData.val(yTnL{numWin}.indexWin, yPara.selectTS);    % extract data for the window
                                                            
    yTnL{numWin}.indexTime = yData.indexTime...
                                    (count-yPara.numSampWin+1:count);       % assign time stamps for window data
    
    yTnL{numWin}.nameTS = yData.namePMU(yPara.selectTS);
    
    %% Trend filtering
    
    [ yTnL{numWin} ] = scaleData(yTnL{numWin});                             % scale data (normalize)
    
    [ yTnL{numWin} ] = TnLFilter(yTnL{numWin}, yPara.lambda, yPara.mu);     % trend filter function
        
    [ yTnL{numWin} ] = rescaleData(yTnL{numWin}, yPara.rateFrame);          % rescale data
    
    %% Calculate trend statistics
    
    [ yStat{numWin} ] = TnLStatistics( yTnL{numWin}, yPara );
    
    %% Run course prediction-----------------------------------------------
    
    yParaExtp = getExtpPara();                                              % get thresholds
    
    if (~isempty(yTnL{numWin}.X))
        
        [yPred{numWin}] = trendExtrapolate(yTnL{numWin},...
            yStat{numWin}, yParaExtp);                                      % extrapolate trends if trigger is set
        
    end
    
    %% End of trend filtering
    
    numWin = numWin + 1;
    compl_status = 100*count/(yPara.numSampDataset);
    sprintf('%2.1f completed',floor(compl_status))
end

%% extra
%             if numWin <= 100
%                 writetable(yPred{numWin}.cpTab,'expResults.xlsx',...
%                     'Sheet',numWin);
%             end
%        else
%            warning('All time series are bad');


end

