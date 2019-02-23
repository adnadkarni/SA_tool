function [yOut] = getExtpPara()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% trigger thresholds
yOut.thMagPred = 1000;   % unit/min
yOut.thDurPred = 10;    % sec


%% Limit hit thresholds

yOut.limitMax = 1.05*400e3/sqrt(3);
yOut.limitMin = 0.95*400e3/sqrt(3);

%% Forecast horizon

yOut.numTAhead = 600;                                                       % in seconds
end

