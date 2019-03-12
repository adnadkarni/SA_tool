function [ yOut, Yp ] = makeData( Yp, hr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global db;

%% Store time series data

yIn = eval(sprintf('db.%s(:,hr)',Yp.typeVar{Yp.selectVar}));

%% variable declaration

numPMU = size(yIn,1);                                                       % total number of PMUs
tp = Yp.selectVar;                                                          % temporary variable for var type
namePMU = db.pmu_name;                                                      % temporary variable for pmu name
k=1;

%% create time series matrix
for i=1:numPMU
    if (~isempty(yIn{i}) && tp ~= 5)                                        % For three phase channels
        ncol = size(yIn{i},2);
        if ncol == 1
            yOut.val(:,k) = yIn{i}(1:Yp.numSampPerHour,:);                  % stack time-series side-by-side
            yOut.namePMU(k) = {strcat(namePMU{i},'')};                      % stack their names side by side (phase-wise)
        
        elseif ncol == 3
            yOut.val(:,3*k-2:3*k) = yIn{i}(1:Yp.numSampPerHour,:);          % stack time-series side-by-side
            yOut.namePMU(3*k-2:3*k) = {strcat(namePMU{i},'_a'),...
                strcat(namePMU{i},'_b'),strcat(namePMU{i},'_c')};           % stack their names side by side (phase-wise)
        
        elseif ncol == 4
            yOut.val(:,4*k-3:4*k) = yIn{i}(1:Yp.numSampPerHour,:);          % stack time-series side-by-side
            yOut.namePMU(4*k-3:4*k) = {strcat(namePMU{i},'_a'),...
                strcat(namePMU{i},'_b')...
                ,strcat(namePMU{i},'_c'),strcat(namePMU{i},'_p')};          % stack their names side by side (phase-wise)
        end
        
    elseif (~isempty(yIn{i}) && tp == 5)                                    % for single channels
        yOut.val(:,k) = yIn{i}(1:Yp.numSampPerHour,:);                      % stack time-series side-by-side
        yOut.namePMU{k} = namePMU{i};                                       % stack their names side by side (phase-wise)
    end
    k=k+1;
end

yOut.namePMU = yOut.namePMU';
yOut.indexTime = db.time(1:Yp.numSampPerHour,hr);

%% Downsample dataset and update the parameters
yOut.val = downsample(yOut.val,Yp.rateDownsample);                          % downsample data
yOut.indexTime = downsample(yOut.indexTime,Yp.rateDownsample);              % downsample timestamps
Yp.numSampDataset = size(yOut.val,1);                                       % get new size of dataset
Yp.rateFrame = Yp.rateFrame*Yp.rateDownsample;                              % get new rate of frame
Yp.durOfDataset = Yp.numSampDataset*Yp.rateFrame;                           % get new duration of dataset
Yp.numSampSlide = Yp.numSecSlide/Yp.rateFrame;                              % get new slide time

end

