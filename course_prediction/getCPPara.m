function [yOut] = getCPPara(yPara)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% trigger thresholds

thMagPred = [500; 0; 0; 0; 0; 0; 0; 0; 0; 0];                               % unit per min
thDurPred = [10; 0; 0; 0; 0; 0; 0; 0; 0; 0];                                % seconds
        
        
%% Limit hit thresholds
        
limitMax = 1.1*[400e3/sqrt(3); 1; 1; 1; 1; 1; 1; 1; 1; 1];
limitMin = 0.9*[400e3/sqrt(3); 1; 1; 1; 1; 1; 1; 1; 1; 1];
        
%% Forecast horizon
        
numTAhead = [300; 60; 60; 60; 60; 60; 60; 60; 60; 60];                      % in seconds


%% vector of thresholds for prediction

yOut.thMagPred = thMagPred(yPara.selectVar);
yOut.thDurPred = thDurPred(yPara.selectVar);
yOut.limitMax = limitMax(yPara.selectVar);
yOut.limitMin = limitMin(yPara.selectVar);
yOut.numTAhead = numTAhead(yPara.selectVar);
yOut.numMinWin = 3;
end

