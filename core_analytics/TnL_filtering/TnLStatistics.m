function [ yOut ] = TnLStatistics( yIn, yPara )
% This function calculates various trend-filtering derived statistics for
% the time series block

%% Note time stamp of current window

yOut.indexEndTime = yIn.indexTime(end);

%% Trend statistics
% Identify trend segments, start and end points

indexTrendChng = [];

for i=1:length(yIn.nameTS)
    indexTrendChng = [indexTrendChng; find(abs(yIn.Dx(:,i))...
                        >= 5*std(yIn.Dx(:,i)))];                            % Detect the trend change points from 
                                                                            % second derivative spikes
end

yOut.indexEndOfTrendSeg = [1;unique(indexTrendChng)+1;yPara.numSampWin];    % store ends of trend segment

% Identify trend magnitude and duration

lengthTrendSeg = diff(yOut.indexEndOfTrendSeg);                             % number of frames in each trend segment
lengthTrendSeg(1) = lengthTrendSeg(1)+1;

yOut.durTrendSeg = (lengthTrendSeg)*(yPara.rateFrame);                      % duration of each trend segment

yOut.magTrend = yIn.Fx(yOut.indexEndOfTrendSeg(2:end)-1,:)*60;              % unit/min , Fx is already in per second

% Calculate weighted trend

for i=1:length(yIn.nameTS)
    
    posTrend = find(yOut.magTrend(:,i)>0);                                  % find positive trend segments
    
    negTrend = find(yOut.magTrend(:,i)<0);                                  % find negative trend segments
    
    yOut.wtdPosTrend(i,1) = (yOut.magTrend(posTrend,i)'*...
                            yOut.durTrendSeg(posTrend,1))/(yIn.durOfWin);   % weighted positive trend
    
    yOut.wtdNegTrend(i,1) =  (yOut.magTrend(negTrend,i)'*...
                        yOut.durTrendSeg(negTrend,1))/(yIn.durOfWin);       % weighted negative trend
    
    yOut.wtdTrend(i,1) =  (yOut.magTrend(:,i)'*...
                                yOut.durTrendSeg)/(yIn.durOfWin);           % overall weighted trend
end

%% Identify spikes locations and magnitude

for i=1:length(yIn.nameTS)
    indexSpike{i,1} = detectOutlier(yIn.U(:,i));                            % gather spike points in each residual
end

yOut.indexSpikeUnique = unique(cell2mat(indexSpike));                       % find unique spike indices in all time series

yOut.indexSpikeZmod = yOut.indexSpikeUnique(yOut.indexSpikeUnique ~= -999); % first will be -999

yOut.indexTimeSpikeZmod = yIn.indexTime(yOut.indexSpikeZmod);               % get time index of spike


if (~isempty(yOut.indexSpikeZmod))
    
    yOut.magSpikeZmod = yIn.U(yOut.indexSpikeZmod,:);                       % magnitude of spike (unit is input unit)

else
    
    yOut.magSpikeZmod = [];
    
end

%% Level change statistics

% Identify level segments, start and end points
indexLevelChng = [];

for i=1:length(yIn.nameTS)
    indexLevelChng = [indexLevelChng; find(abs(yIn.Fw(:,i))...
                        >= 5*std(yIn.Fw(:,i)))];                            % Detect the trend change points from                                                                      % second derivative spikes
end

changePtsLevel = unique(indexLevelChng);

yOut.indexTimeLevelChange = yIn.indexTime(changePtsLevel+1);                % time of level change

yOut.indexEndOfLevelSeg = [1;changePtsLevel+1;yPara.numSampWin];            % store ends of trend segment

% Identify level magnitude and duration

lengthLevelSeg = diff(yOut.indexEndOfLevelSeg);                             % number of frames in each trend segment
lengthLevelSeg(1) = lengthLevelSeg(1)+1;

yOut.durLevelSeg = (lengthLevelSeg)*(yPara.rateFrame);                      % duration of each trend segment

yOut.magLevel = yIn.W(yOut.indexEndOfLevelSeg(2:end),:);                    % unit/min , Fx is already in per second

yOut.magLevelChange = yIn.Fw(changePtsLevel,:);                             % level change in units


%% Calculate residual statistics

% yOut.res_mean = mean(yIn.U);                                                
% 
% yOut.res_std = std(yIn.U);

end

