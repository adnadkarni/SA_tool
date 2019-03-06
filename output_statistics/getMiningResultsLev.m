% Author: aditya <aditya@aditya-Lenovo-G510>
% Created: 2019-02-24

function [yOut] = getMiningResultsLev (yIn, thrIn)

for i=1:size(yIn.lastSegTrend,1)
    
    yOut.indexEndTime(i,1) = yIn.indexEndTime(i);                           % window end time of current segment

    indexMaxLevelChange = find(abs(yIn.maxLevelChange(i,:))...
                                              >= thrIn.thrMaxLevelChange);  % find window with significant last segment trend
    
    durSeg = yIn.durLastSegLevel(i);                                        % get duration of that trend segment
    
    if (~isempty(indexMaxLevelChange))
                
        yOut.statusLevelChange(i,1) = 1;
        
%        yOut.lastSegLevel(i,:) = yIn.lastSegTrend(i,:);
                
        yOut.durLastSegLevel(i,1) = durSeg;
    else
        yOut.statusLevelChange(i,1) = 0;
%        yOut.lastSegLevel(i,1) = nan;
        yOut.durLastSegLevel(i,1) = nan;
    end
    
end

end
