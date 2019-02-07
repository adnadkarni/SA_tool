function [outputArg1] = range_event_detect(results, Yo, Ye, pl_ip)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Calculate variance by window

for i=1:size(Yo,1)         % i = hour number
    for j=1:size(Yo{i},2)  % j = window number
        tmpo = Yo{i}{j};   % Yo of i,j
        tmpe = Ye{i}{j};   % Ye of i,j
        
        for k=1:size(tmpe.trnd_seg_pts,1)-1   % k = number of trnd segments in the window
            st(k) = tmpe.trnd_seg_pts(k);   % start of segment
            en(k) = tmpe.trnd_seg_pts(k+1)-1;  % end of segment
            for l=1:size(tmpo.U,2)           % l = number of time series
                rsd_seg = tmpo.U(st(k):en(k),l);   % residual of segment k
                Ye{i}{j}.Vrnc(l,k) = var(rsd_seg); % variance index
            end
        end
        Ye{i}{j}.V_chng = [st(2:end);en(2:end);abs(diff(Erng.Vrnc,1,2)./Erng.Vrnc(:,1:end-1))*100]; % change in variance    
    end
end

% Calculate change in variance of each trend-segment
outputArg1 = Ye;
end

