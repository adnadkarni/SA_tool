function [eventStat, eventIndex, yDown] = detect_by_distribution(db)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

y = db.fr{1}; % data at 20 msec
naIndex = y < 45;
y(naIndex) = nan;
yDown = downsample(y,50);  % data at 1 sec

winSz = 60;
stdev = 0.038;
winCount = 1;

for i= winSz:length(yDown)

    yWin = yDown(i-winSz+1:i);
    yDevMean = 100*(yWin - mean(yWin))/mean(yWin);

    exceed3Sigma = find(abs(yDevMean) >= 3*stdev);

    eventStat(winCount) = ~isempty(exceed3Sigma);
    eventIndex{winCount,1} = exceed3Sigma + i-winSz;
    winCount = winCount + 1;
end

end

