function [xin] = outlier2Nan(xin, th)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
indexOutlier = cellfun(@(x) find(abs(x) <= th), xin, 'UniformOutput',false);

for i=1:length(indexOutlier)
    xin{i}(indexOutlier{i}) = nan;
end

end

