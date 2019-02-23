function [outputArg1] = detectOutlier(u)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% modified Z-score method
thr = 5;
med = median(u);
mad = median(abs(u-median(u)));
mod_z = 0.6745*(u-med)/mad;

indx_spk = find(abs(mod_z) > thr);

if isempty(indx_spk)
    indx_spk = -999;
end
outputArg1 = indx_spk;
end

