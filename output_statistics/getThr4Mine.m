function [yOut] = getThr4Mine (varType)

switch varType
    case 1
        yOut.thrMaxTrend = 500; % volts/min
        yOut.thrDurTrend = 15;
        yOut.thrWtdTrend = 500; %volts/min
        yOut.thrMaxSpike = 500; % volts
        yOut.thrNumFramesDeclareEvent = 3; %
        yOut.thrMaxLevelChange = 500;
        yOut.thrDurLevel = 15;
end

end
