function [ Yo, Ye ] = l1trnd_filtering( Y, Yi)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
win_num = 1;
Yi.name = Y.name_indx(Yi.ts_indx);

for count = Yi.win_sz:Yi.nsamp_slide:Yi.ds_sz %Yi.win_sz
    Yi.win_indx = [count-Yi.win_sz+1:count]';
    Yi.win_dur = Yi.win_sz*Yi.ts;
    Yi.val = Y.val(Yi.win_indx, Yi.ts_indx);
    Yi.t_indx = Yi.win_indx*Yi.ts;
    
    [ Yo{win_num} ] = ds_scale(Yi);
    [ Yo{win_num} ] = trend_filter(Yo{win_num});
    [ Yo{win_num} ] = ds_rescale(Yo{win_num});
    
    % Calculate trend statistics
    [ Ye{win_num} ] = trend_statistics( Yo{win_num} );
    
    % Run course prediction------------------------------------------------
    if ~isempty(Ye{win_num})
        
    end
    
    win_num = win_num + 1;
    compl_status = 100*count/(Yi.ds_sz);
    sprintf('completed = %2.1f',compl_status)
end



end

