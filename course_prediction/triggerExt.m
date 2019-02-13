function [M2] = triggerExt(M1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%quntTrend = M1.trnd_mag(end,:)'./M1.trnd_wtd; % last segment trend/weighted trend

% trigger criterion 1
% If the trend magnitude of the last trend segment is greater than 1 and
% the trend duration of that segment is more than 1 minute

M2 = abs(M1.trnd_mag(end,:))>= 1 & M1.trnd_seg_duration(end) >= 60;
%M2 = abs(M1.trnd_mag(end,:)/60)>= 0.5 & M1.trnd_seg_duration(end) >= 2;
%abs(M1.trnd_mag(end,:))
 
end

