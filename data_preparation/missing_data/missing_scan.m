function [ Yp, Y_dl ] = missing_scan( Y, Yp, tp )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% single out channels with large amount of missing data
count=1;
for j=1:length(Yp.ts_indx) % j = each of selected time series
    indx = Yp.ts_indx(j);
    [ Y_dl.dl_ch{j} ] = missing_diagnostics_by_channel( Y.val(:,indx), tp );  % nan, max by each channel
    if (rem(j,4)==0 && ismember(tp,[1,2,3,4])) % phase wise statistics of missing data, only for phasors
        [ Y_dl.dl_ph{count} ] = missing_diagnostics_by_3ph( Y.val(:,indx-3:indx-1), tp );
        count=count+1;
    else
        Y_dl.dl_ph{count} = [];
    end
    [ Y_dl.dl_blk{j} ] = missing_count_block( Y.val(:,indx) );  % block wise missing data for each channel
end


[ Y_dl.dl_all ] = combine_dl_by_channel( Y_dl.dl_ch, 'perc_all' );
[ Y_dl.dl_type ] = combine_dl_by_channel( Y_dl.dl_ch, 'perc_missing' );
[ Y_dl.dl_byblk ] = combine_dl_by_channel( Y_dl.dl_blk, [1,3] );

if ismember(tp,[1,2,3,4])
    [ Y_dl.dl_byph ] = combine_dl_by_channel( Y_dl.dl_ph, 'ph' );
else
    Y_dl.dl_byph = [];
end

% Remove wrong data channels-------------------------------------------
col_remove = (Y_dl.dl_all>90);
% Y.val(:,col_remove) = [];
% Y.name_indx(col_remove) = [];
Yp.ts_indx(col_remove) = [];
end

