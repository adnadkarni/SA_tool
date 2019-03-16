function [yOut] = getMiningResultsSpk (yIn, thrIn)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

yOut.statusSpike = zeros(length(yIn.maxSpike),1);                           % initialize status vector
yOut.maxSpike = zeros(length(yIn.maxSpike),1);                              % initialize spike magnitude vector
yOut.setEvent = zeros(length(yIn.maxSpike),1);
yOut.indexEndTime = yIn.indexEndTime;                                       % window end time of current segment
yOut.magNindexSpike = cell(length(yIn.maxSpike),2);

%% get above threshold spikes
indexMaxSpike = find(abs(yIn.maxSpike) >= thrIn.thrMaxSpike);               % find window with significant spike                                           % set status of above threshold spikes as one

%% identify the first occurrences of 
if (~isempty(indexMaxSpike))
    yOut.statusSpike(indexMaxSpike,1) = 1;
    for i = 1:length(indexMaxSpike)
        yOut.magNindexSpike{indexMaxSpike(i),1} = yIn.magSpike{indexMaxSpike(i)};
        yOut.magNindexSpike{indexMaxSpike(i),2} = yIn.indexSpike{indexMaxSpike(i)};
    end
    yOut.maxSpike(indexMaxSpike) =...
                                yIn.maxSpike(indexMaxSpike);
    
end

end

