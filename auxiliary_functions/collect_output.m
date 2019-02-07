function [op] = collect_output(Yo, Ye)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

k=1;
op.spk_z = [];
op.spk_zm = [];

for i=1:size(Yo,1)
    for j=1:size(Yo{i},2)
        op.win_st(k,1) = Yo{i}{j}.t_indx(1); % start of window
        op.win_en(k,1) = Yo{i}{j}.t_indx(end); % end of window
        op.wtr(k,:) =   Ye{i}{j}.trnd_wtd';  % weighted trend
        op.wtr_p(k,:) = Ye{i}{j}.trnd_wtd_p'; % weighted positive trend
        op.wtr_n(k,:) = Ye{i}{j}.trnd_wtd_n'; % weighted negative trend
        
        % find the largest-trend series and magnitude
        [max_trnd_mag1, max_trnd_pos1] = max(abs(Ye{i}{j}.trnd_mag));
        [max_trnd_mag2, max_trnd_pos2] = max(max_trnd_mag1);
        if size(Ye{i}{j}.trnd_mag,1) > 1 % if more than one segments of trend-fit
            op.max_trnd(k,1) = Ye{i}{j}.trnd_mag(max_trnd_pos1(max_trnd_pos2),max_trnd_pos2); % maximum of all trends
            op.max_trnd_ser(k,1) = max_trnd_pos2; % series of max. trend
            op.max_trnd_seg(k,1) = max_trnd_pos1(max_trnd_pos2); % segment of maximum trend
            op.max_trnd_len(k,1) = Ye{i}{j}.trnd_seg_duration(op.max_trnd_seg(k,1)); % duration of max. trend
            op.max_trnd_st(k,1) =  Ye{i}{j}.trnd_seg_pts(op.max_trnd_seg(k,1));% start point of max. trend segment
            op.max_trnd_en(k,1) =  Ye{i}{j}.trnd_seg_pts(op.max_trnd_seg(k,1)+1);% end point of max.trend segment
        else % if just one segment of trend-fit
            op.max_trnd(k,1) = Ye{i}{j}.trnd_mag(max_trnd_pos2,max_trnd_pos1);
            op.max_trnd_ser(k,1) = max_trnd_pos1;
            op.max_trnd_seg(k,1) = max_trnd_pos2;
            op.max_trnd_len(k,1) = Ye{i}{j}.trnd_seg_duration(op.max_trnd_seg(k,1));
            op.max_trnd_st(k,1) =  Ye{i}{j}.trnd_seg_pts(op.max_trnd_seg(k,1));% start point of max. trend segment
            op.max_trnd_en(k,1) =  Ye{i}{j}.trnd_seg_pts(op.max_trnd_seg(k,1)+1);% end point of max.trend segment
        end
        

        
        k=k+1;
    end
end

end

