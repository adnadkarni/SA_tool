function [ blck_sz ] = missing_count_block( y )
%The function determines if the missing data points are randomly missing or
%in blocks. If missing in blocks, the block sizes are calculated. This is
%done for the whole pmu channel data received as input.
%   Detailed explanation goes here
global ds_num_pts
global ds_num_pmu

count = 0;
blck_count = 0;
k=1;
i=1;
while (i<length(y))
    temp = y(i);
    count = 1;
    flg = 0;
    while(y(i+1)==y(i))
        count = count+1;
        i = i+1;
        if i==length(y)
            break;
        else flg = 1;
        end
    end
    if flg==1
        blck_count(k,1) = count;
        k = k+1;
    end
    
    if i==length(y)
        break;
    end
    i = i+1;
end

blck_sz(1) = sum(blck_count==1);   % count for only one measurement missing
blck_sz(2) = sum(blck_count > 5 & blck_count <= 25);  % count for block sizes upto 1 sec
blck_sz(3) = sum(blck_count> 25 & blck_count<1500); % count for block sizes upto 1 min
blck_sz(4) = sum(blck_count>=length(y)-100 & blck_count<=length(y)); % count for all data missing

end

