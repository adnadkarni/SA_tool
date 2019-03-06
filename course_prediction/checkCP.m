function [selectTS, flagPred] = checkCP(yStatWin, thPredict)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% trigger criterion 1
% If the trend magnitude of the last trend segment is greater than 1 and
% the trend duration of that segment is more than 1 minute

selectTS = (abs(yStatWin.magTrend(end,:)) >= thPredict.thMagPred) &...
                        (yStatWin.durTrendSeg(end) >= thPredict.thDurPred);

flagPred = (sum(selectTS) >= 1);

 
end

