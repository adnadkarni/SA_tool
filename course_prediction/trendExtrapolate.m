function [yPred] = trendExtrapolate(yTr, yStat, yPara)
%The function extrapolates time series trends after the extrapolation
%trigger indicator is set.
% M1 - structure of filter output
% M2 - structure of event output

%% Setup

yPred.selectTs = find(triggerExtp(yStat, yPara));                           % select time series to be extrapolated
yPred.tstampAhead = [1:yPara.numTAhead]';                                   % time stamps for the extrapolations (just number)

if (~isempty(yPred.selectTs))
    
    %% Course prediction
    y0 = yTr.X;
    yPred.yAhead = y0(end,yPred.selectTs) + ...
              yStat.magTrend(end,yPred.selectTs).*yPred.tstampAhead/60;     % linear extrapolation
    
    
    %% Time to limit
    indexNegTr = yPred.selectTs(find(yStat.magTrend(end,yPred.selectTs) < 0));
    
    indexPosTr = yPred.selectTs(find(yStat.magTrend(end,yPred.selectTs) >= 0));
    
    yPred.t2Lim(indexNegTr,1) = (yPara.limitMin - ...
                    y0(end,indexNegTr))./yStat.magTrend(end,indexNegTr);    % time to the min limit
    yPred.t2Lim(indexPosTr,1) = (yPara.limitMax - ...
                    y0(end,indexPosTr))./yStat.magTrend(end,indexPosTr);    % time to the max limit
    
    %% Generate course prediction report
    
    numSelectTs = length(yPred.selectTs);
    
    yPred.cpTab = table(yTr.indexTime(end)*ones(numSelectTs,1),...
                    yTr.nameTS(yPred.selectTs),...
                    yStat.magTrend(end,yPred.selectTs)',...
                    yStat.durTrendSeg(end)*ones(numSelectTs,1),...
                    yPred.t2Lim(yPred.selectTs),...
 'VariableNames', {'time', 'Name', 'MWperMin', 'Duration', 'Min2Limit'  } ) ;
    
    
    %% Plot course prediction
    flagPlotExt = 0; % whether to plot results
    
    if flagPlotExt == 1
        close all;
        plotExtrapolate(yTr, yPred);
    end
    
end

end

