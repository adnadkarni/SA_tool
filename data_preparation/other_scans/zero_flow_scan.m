function [ Y ] = zero_flow_scan( Y, lim )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

for j=1:size(Y.val,2)
    [zfl_stat(j), zfl_mag(j)] = zero_flow( Y.val(:,j), lim );
end

Y.zfl_lines = [find(zfl_stat);zfl_mag(find(zfl_stat))];
end

