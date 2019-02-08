function [ Yo, Ye, Yext ] = l1trnd_filtering( Y, Yi)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
numWin = 1;
Yi.name = Y.name_indx(Yi.ts_indx);

for count = Yi.win_sz:Yi.nsamp_slide:Yi.ds_sz %Yi.win_sz
    Yi.win_indx = [count-Yi.win_sz+1:count]';
    Yi.win_dur = Yi.win_sz*Yi.ts;
    Yi.val = Y.val(Yi.win_indx, Yi.ts_indx);
    Yi.t_indx = Yi.win_indx*Yi.ts;
    
    [ Yo{numWin} ] = ds_scale(Yi);
    [ Yo{numWin} ] = trend_filter(Yo{numWin});
    [ Yo{numWin} ] = ds_rescale(Yo{numWin});
    
    % Calculate trend statistics
    [ Ye{numWin} ] = trend_statistics( Yo{numWin} );
    
    % Run course prediction------------------------------------------------
    if ~isempty(Yo{numWin}.X)
        [Yext.selectTsForExp{numWin}] = triggerExt(Ye{numWin}); % select time series to be extrapolated
%         if sum(selectTsForExp) ~= 0
%             [Yext{numWin}] = extrapolateTrend(Yo{numWin}, Ye{numWin}, selectTsForExp{numWin}); % extrapolate trends if trigger is set
%         end
    end
    
    numWin = numWin + 1;
    compl_status = 100*count/(Yi.ds_sz);
    sprintf('completed = %2.1f',compl_status)
end



end

