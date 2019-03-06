function [yCP] = runCP(yTr, yStat, yCP, yPara)
%The function extrapolates time series trends after the extrapolation
%trigger indicator is set.
% M1 - structure of filter output
% M2 - structure of event output

%% Setup
yCP.tstampAhead = [1:yPara.numTAhead]';                                   % time stamps for the extrapolations (just number)
yCP.flagCP = 1;

if (~isempty(yCP.selectTS))
    
    %% Course prediction
    y0 = yTr.X;
    yCP.yAhead = y0(end,yCP.selectTS) + ...
              yStat.magTrend(end,yCP.selectTS).*yCP.tstampAhead/60;     % linear extrapolation
    
    
    %% Time to limit
    indexNegTr = yCP.selectTS(find(yStat.magTrend(end,yCP.selectTS) < 0));
    
    indexPosTr = yCP.selectTS(find(yStat.magTrend(end,yCP.selectTS) >= 0));
    
    yCP.t2Lim(indexNegTr,1) = (yPara.limitMin - ...
                    y0(end,indexNegTr))./yStat.magTrend(end,indexNegTr);    % time to the min limit
    yCP.t2Lim(indexPosTr,1) = (yPara.limitMax - ...
                    y0(end,indexPosTr))./yStat.magTrend(end,indexPosTr);    % time to the max limit
    
    %% Generate course prediction report
    
    numSelectTS = length(yCP.selectTS);
    
    yCP.cpTab = table(yTr.indexTime(end)*ones(numSelectTS,1),...
                    yTr.nameTS(yCP.selectTS),...
                    yStat.magTrend(end,yCP.selectTS)',...
                    yStat.durTrendSeg(end)*ones(numSelectTS,1),...
                    yCP.t2Lim(yCP.selectTS),...
 'VariableNames', {'time', 'Name', 'MWperMin', 'Duration', 'Min2Limit'  } ) ;
    
    
    %% Plot course prediction
    flagPlotExt = 0; % whether to plot results
    
    if flagPlotExt == 1
        close all;
        plotExtrapolate(yTr, yCP);
    end
    
end

end

