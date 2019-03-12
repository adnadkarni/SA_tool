function [yAdjustedLC] = reAdjustLevel(indexLC, yLC )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for j=1:size(yLC,2)                                                         % number of time series
    for i=1:length(indexLC)-1                                               % number of level segments
        
        if (i < length(indexLC)-1)
            avg = mean(yLC(indexLC(i):indexLC(i+1)-1, j));                  % mean of segment
            yAdjustedLC(indexLC(i):indexLC(i+1)-1, j) =...
                avg.*ones(indexLC(i+1)-indexLC(i),1);                       % 
        else
            avg = mean(yLC(indexLC(i):indexLC(i+1), j));
            yAdjustedLC(indexLC(i):indexLC(i+1), j) =...
                avg.*ones(indexLC(i+1)-indexLC(i)+1,1);
        end
        
    end
end
end

