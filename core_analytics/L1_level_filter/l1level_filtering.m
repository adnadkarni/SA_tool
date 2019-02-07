function [ Yo, Ye ] = l1level_filtering( Y, Yi, ts_indx, tp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
win_num = 1;
Yi.val_ds = downsample(Y.val,Yi.dsamp_rate);
lev_thresh = [0.001,5,0,0];
global Yo;

for count = Yi.dsamp_win_sz:Yi.dsamp_win_sz:size(Yi.val_ds,1)%Yi.dsamp_win_sz
    Yi.win_indx = [count-Yi.dsamp_win_sz+1:count]';
    Yi.val = Y.val(Yi.win_indx, ts_indx);
    Yi.t_indx = Yi.win_indx*Yi.ts*Yi.dsamp_rate;
    Yi.name = Y.name_indx(ts_indx);
    [ Yo{win_num} ] = ds_scale(Yi);
    [ Yo{win_num} ] = level_filter(Yo{win_num});
    [ Yo{win_num} ] = ds_rescale(Yo{win_num});
    
    %   plot(Yi.t_indx,[Yo{win_num}.val(:,1),Yo{win_num}.X(:,1)]);
    % Calculate trend statistics
    
    [ Ye{win_num}, Yo{win_num} ] = level_statistics( Yo{win_num}, lev_thresh(tp) );
    
    if count==68000
%         chng_pts = findchangepts(Yo{win_num}.val(:,4),'Statistic','linear');
        plot([Yo{win_num}.val(:,4),mean(Yo{win_num}.val(:,4))*ones(Yo{win_num}.dsamp_win_sz,1),...
            Yo{win_num}.X(:,4)]);
    end
    win_num = win_num + 1;
    count
end



end

