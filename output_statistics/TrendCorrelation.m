function [outputArg1] = TrendCorrelation(Yo, event)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

st = event.max_trnd_st;
en = event.max_trnd_en;

xCorr = Yo(st:en,:);
R = corrcoef(xCorr);

outputArg1 = R;
end

