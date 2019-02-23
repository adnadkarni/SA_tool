function [ yOut ] = trend_statistics( yIn, yPara )
% This function calculates various trend-filtering derived statistics for
% the time series block

%% Identify trend segments, start and end points

indexTrendChng = [];

for i=1:length(yIn.nameTS)
    indexTrendChng = [indexTrendChng; find(abs(yIn.Dx(:,i))...
                        >= 5*std(yIn.Dx(:,i)))];                            % Detect the trend change points from 
                                                                            % second derivative spikes
end

yOut.indexEndOfSeg = [1;unique(indexTrendChng)+1;yPara.numSampWin];         % store ends of trend segment

%% Identify trend magnitude and duration

lengthTrendSeg = diff(yOut.indexEndOfSeg);                                  % number of frames in each trend segment
lengthTrendSeg(1) = lengthTrendSeg(1)+1;

yOut.durTrendSeg = (lengthTrendSeg)*(yPara.rateFrame);                      % duration of each trend segment

yOut.magTrend = yIn.Fx(yOut.indexEndOfSeg(2:end)-1,:)*60;                   % unit/min , Fx is already in per second

%% Calculate weighted trend

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

if (~isempty(yOut.indexSpikeZmod))
    
    yOut.magSpikeZmod = yIn.U(yOut.indexSpikeZmod,:);                       % magnitude of spike (unit is input unit)

else
    
    yOut.magSpikeZmod = [];
end
%% Calculate residual statistics

% yOut.res_mean = mean(yIn.U);                                                
% 
% yOut.res_std = std(yIn.U);

end

