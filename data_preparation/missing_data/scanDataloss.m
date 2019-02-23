function [ yPara, yDataloss ] = scanDataloss( yData, yPara )
%This function gives various statistics about the missing data in the
%selected database.

%% Obtain channels with large amount of missing data
% count=1;

for j=1:length(yPara.selectTS)                                              % j = across all selected time series
    
    indx = yPara.selectTS(j);
    [ yDataloss.byChannel{j} ] = datalossByChannel( yData.val(:,indx),...
        yPara.selectVar );                                                  % get nan, max by each channel
    
%     if (rem(j,4)==0 && ismember(yPara.selectVar,[1,2,3,4]))                 % phase wise statistics of missing data, 
%                                                                             % only for phasors 
%         [ yDataloss.dl_ph{count} ] = missing_diagnostics_by_3ph( yData.val(:,indx-3:indx-1), yPara.selectVar );
%         count=count+1;
%     else
%         yDataloss.dl_ph{count} = [];
%     end
%     [ yDataloss.dl_blk{j} ] = missing_count_block( yData.val(:,indx) );  % block wise missing data for each channel
end


 [ yDataloss.collectByChannel ] = collectByChannel( yDataloss.byChannel, 'percAll' );
% [ yDataloss.dl_type ] = combine_dl_by_channel( yDataloss.dl_ch, 'perc_missing' );
% [ yDataloss.dl_byblk ] = combine_dl_by_channel( yDataloss.dl_blk, [1,3] );
% 
% if ismember(tp,[1,2,3,4])
%     [ yDataloss.dl_byph ] = combine_dl_by_channel( yDataloss.dl_ph, 'ph' );
% else
%     yDataloss.dl_byph = [];
% end

%% Remove wrong data channels-------------------------------------------
numColRemove = (yDataloss.collectByChannel >= 90);
yPara.selectTS(numColRemove) = [];
end

