function [ Ye_tr ] = trend_statistics( Yo_tr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Identify trend segments, start and end points
trnd_chng_pts = [];
for i=1:length(Yo_tr.name)
    trnd_chng_pts = [trnd_chng_pts; find(abs(Yo_tr.Dx(:,i)) >= 5*std(Yo_tr.Dx(:,i)))];
end
Ye_tr.trnd_seg_pts = [1;unique(trnd_chng_pts)+1;Yo_tr.win_sz];

%% Identify trend magnitude and duration
trnd_seg_len = diff(Ye_tr.trnd_seg_pts);
trnd_seg_len(1) = trnd_seg_len(1)+1;
Ye_tr.trnd_seg_duration = trnd_seg_len*Yo_tr.ts;
Ye_tr.trnd_mag = Yo_tr.Fx(Ye_tr.trnd_seg_pts(2:end)-1,:)*60; %unit/min , Fx is already in per second

%% Calculate weighted trend
for i=1:length(Yo_tr.name)
    pos_trnd = find(Ye_tr.trnd_mag(:,i)>0);
    neg_trnd = find(Ye_tr.trnd_mag(:,i)<0);
    Ye_tr.trnd_wtd_p(i,1) =  Ye_tr.trnd_mag(pos_trnd,i)'*(Ye_tr.trnd_seg_duration(pos_trnd,1))/(Yo_tr.win_dur);
    Ye_tr.trnd_wtd_n(i,1) =  Ye_tr.trnd_mag(neg_trnd,i)'*(Ye_tr.trnd_seg_duration(neg_trnd,1))/(Yo_tr.win_dur);
    Ye_tr.trnd_wtd(i,1) =  Ye_tr.trnd_mag(:,i)'*(Ye_tr.trnd_seg_duration)/(Yo_tr.win_dur);
end

%% Identify spikes locations and magnitude
for i=1:length(Yo_tr.name)
    spk_indx{i,1} = detect_outlier(Yo_tr.U(:,i));  % gather spike points in each residual
end
Ye_tr.spk_indx_zm = unique(cell2mat(spk_indx)); % find unique spike sample indices
Ye_tr.spk_indx_zm = Ye_tr.spk_indx_zm(Ye_tr.spk_indx_zm ~= -999); % first will be -999
Ye_tr.spk_mag_zm = Yo_tr.U(Ye_tr.spk_indx_zm,:);  % unit - input unit

%% Calculate residual
Ye_tr.res_mean = mean(Yo_tr.U);
Ye_tr.res_std = std(Yo_tr.U);

end

