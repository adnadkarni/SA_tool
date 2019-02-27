%## Author: aditya <aditya@aditya-Lenovo-G510>
%## Created: 2019-02-24

function [yOut] = collectResults (ySt)

%% Collect all trend statistics
for i=1:length(ySt)
    for j=1:length(ySt{i})
        
        %% Trend statistics
        yOut.indexEndTime(j,1) = ySt{i}{j}.indexEndTime;
        yOut.wtdTrend(j,:) = ySt{i}{j}.wtdTrend';
        yOut.lastSegTrend(j,:) = ySt{i}{j}.magTrend(end,:);
        yOut.durLastSegTrend(j,:) = ySt{i}{j}.durTrendSeg(end,:);
        
        %% Spike statistics
        if (~isempty(ySt{i}{j}.magSpikeZmod))
            
            tDiff = ySt{i}{j}.indexEndTime - ySt{i}{j}.indexTimeSpikeZmod;  % how much long ago the spikes were detected
            indexOldSpike = find(tDiff > seconds(3));                       % get spikes which are already detected
            ySt{i}{j}.magSpikeZmod(indexOldSpike,:) = [];                   % remove already detected spike record
            
            if (~isempty(ySt{i}{j}.magSpikeZmod))
                [yOut.maxSpike(j,:)] =...
                                        findMaxAbs(ySt{i}{j}.magSpikeZmod);
            else
                yOut.maxSpike(j,:) = 0;
                yOut.indexMaxSpike(j,:) = 0;
            end
        else
            yOut.maxSpike(j,:) = 0;
            yOut.indexMaxSpike(j,:) = 0;
        end
        
        %% Level statistics
        yOut.lastSegLevel(j,:) = ySt{i}{j}.magLevel(end,:);
        yOut.durLastSegLevel(j,:) = ySt{i}{j}.durLevelSeg(end,:);
        if (~isempty(ySt{i}{j}.changeLevel))
            yOut.maxChangeLevel(j,:) = findMaxAbs(ySt{i}{j}.changeLevel);
        else 
            yOut.maxChangeLevel(j,:) = 0;
        end
    end
end
%keyboard
end
