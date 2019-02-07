function [ Y_sp ] = suspect_scan( Y, tp )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if tp==1 | tp==3
    Y_sp = [];
end


if tp==2
    lim_min = 10;
    lim_max = 1000;
    for j=1:size(Y.val,2)
        [zfl_stat{j}, zfl_mag(j)] = suspect_flow( Y.val(:,j), lim_min, lim_max );
    end
    
    [ Y_sp.zfl ] = combine_dl_by_channel( zfl_stat, 'zfl' );
    [ Y_sp.infl ] = combine_dl_by_channel( zfl_stat, 'infl' );
    [ Y_sp.suspfl ] = combine_dl_by_channel( zfl_stat, 'suspfl' );
end
end

