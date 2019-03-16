function [yOut] = getThr4Mine (varType)

switch varType
    case 1
        yOut.thrTrendType = 1;  % 1 for dynamic trend treshold
        yOut.thrMaxTrend = 500; % volts/min
        yOut.thrDurTrend = 15;  % seconds
        yOut.thrWtdTrend = 200; %volts/min
        yOut.thrMaxSpike = 500; % volts
        yOut.thrNumFramesDeclareEvent = 3; %
        yOut.thrMaxLevelChange = 231;
        yOut.thrDurLevel = 15;
    case 2
        yOut.thrTrendType = 1;  % 1 for dynamic trend treshold
        yOut.thrMaxTrend = 5; % amps/min
        yOut.thrDurTrend = 15;
        yOut.thrWtdTrend = 2; %volts/min
        yOut.thrMaxSpike = 5; % volts
        yOut.thrNumFramesDeclareEvent = 3; %
        yOut.thrMaxLevelChange = 5;
        yOut.thrDurLevel = 15;
    case 5
        yOut.thrTrendType = 1;  % 1 for dynamic trend treshold
        yOut.thrMaxTrend = 1; % Hz/min
        yOut.thrDurTrend = 5;    % seconds
        yOut.thrWtdTrend = 0.5; %Hz/min
        yOut.thrMaxSpike = 0.1; % Hz
        yOut.thrNumFramesDeclareEvent = 3; %
        yOut.thrMaxLevelChange = 0.5;       % Hz
        yOut.thrDurLevel = 5;      % seconds
end

end
