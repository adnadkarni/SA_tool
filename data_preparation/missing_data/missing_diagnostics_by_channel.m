function [ y ] = missing_diagnostics_by_channel( x, tp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ds_num_pts = length(x);
% If the input channel is itself incomplete

if isempty(x)
    y =[];
else
    if length(x) < ds_num_pts
        y.no_data = 100*(ds_num_pts-length(x))/ds_num_pts;
    else
        y.no_data = 0;
    end
    
    % type, total statistic
    switch tp
        case 1
            temp1 = (isnan(x) | x == 0);  % find nan or zero entried in a channel
            y.perc_nan = 100*sum(temp1)/ds_num_pts; % percentage over the size of channel
            temp2 = (x >= 4e5-100 & x <= 4e5+100);  % find at limit entried in a channel
            y.perc_max = 100*sum(temp2)/ds_num_pts; % percentage over the size of channel
            temp3 = (temp1 | temp2);        % all missing data in logical
            y.perc_all = max([y.perc_nan, y.perc_max, y.no_data]); % all missing data in percentage
            
            if sum(temp3) > 0
                y.freq  = missing_count_block( temp3 ); % find if the y data is random
                % or in blocks
            end
            
        case 2
            temp1 = [isnan(x) | x == 0];
            y.perc_nan = 100*sum(temp1)/ds_num_pts;
            temp2 = [abs(x) >= 1e3];
            y.perc_max = 100*sum(temp2)/ds_num_pts;
            temp3 = temp1 + temp2;
            y.perc_all = max([y.perc_nan, y.perc_max, y.no_data]);
            if sum(temp3)>0
                y.freq  = missing_count_block( temp3 );
            end
            
        case 3
            temp1 = [isnan(x) | x == 0];
            y.perc_nan = 100*sum(temp1)/ds_num_pts;
            temp2 = [abs(x) >= 5];
            y.perc_max = 100*sum(temp2)/ds_num_pts;
            temp3 = temp1 + temp2;
            y.perc_all = max([y.perc_nan, y.perc_max, y.no_data]);
            if sum(temp3)>0
                y.freq  = missing_count_block( temp3 );
            end
        case 4
            temp1 = [isnan(x) | x == 0];
            y.perc_nan = 100*sum(temp1)/ds_num_pts;
            y.perc_max = zeros(ds_num_pmu,1);
        case 5
            temp1 = [isnan(x) | x == 0 | isinf(x)];
            y.perc_nan = 100*sum(temp1)/ds_num_pts;
            temp2 = [x <= 45 | x >= 55];
            y.perc_max = 100*sum(temp2)/ds_num_pts;
            temp3 = temp1 + temp2;
            y.perc_all = max([y.perc_nan, y.perc_max, y.no_data]);
            if sum(temp3)>0
                y.freq  = missing_count_block( temp3 );
            end
        case 6
            temp1 = [isnan(x) | x == 0];
            y.perc_nan = 100*sum(temp1)/ds_num_pts;
            temp2 = [abs(x) <= 5];
            y.perc_max = 100*sum(temp2)/ds_num_pts;
            temp3 = temp1 + temp2;
            y.perc_all = max([y.perc_nan, y.perc_max, y.no_data]);
            if sum(temp3)>0
                y.freq  = missing_count_block( temp3 );
            end
    end
    
    y.perc_missing = [y.perc_nan,y.perc_max];
end
end

