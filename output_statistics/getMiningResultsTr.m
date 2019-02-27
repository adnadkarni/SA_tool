% Author: aditya <aditya@aditya-Lenovo-G510>
% Created: 2019-02-24

function [yOut] = getMiningResultsTr (yIn, thrIn)

for i=1:size(yIn.lastSegTrend,1)
    
    yOut.indexEndTime(i,1) = yIn.indexEndTime(i);                           % window end time of current segment

    indexMaxTrend = find(abs(yIn.lastSegTrend(i,:)) >= thrIn.thrMaxTrend);  % find window with significant last segment trend
    
    durSeg = yIn.durLastSegTrend(i);                                        % get duration of that trend segment
    %wtdTrend = yIn.lastSegTrend(i,:);                                      % get weighted trend for the whole window
    
    if (~isempty(indexMaxTrend) && durSeg >= thrIn.thrDurTrend)
                
        yOut.statusLastSegTrend(i,1) = 1;
        
        yOut.lastSegTrend(i,:) = yIn.lastSegTrend(i,:);
        
        yOut.wtdAtInstTrend(i,:) = yIn.wtdTrend(i,:);
        
        yOut.durLastSegTrend(i,1) = durSeg;
    else
        yOut.statusLastSegTrend(i,1) = 0;
        yOut.lastSegTrend(i,1) = nan;
        yOut.wtdAtInstTrend(i,1) = nan;
        yOut.durLastSegTrend(i,1) = nan;
    end
    
end

end
