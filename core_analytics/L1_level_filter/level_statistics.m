function [ Ye_lev, Yo_lev] = level_statistics( Yo_lev, du0 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Identify levend segments, start and end points
level_chng_pts = [];
for i=1:length(Yo_lev.name)
    level_chng_pts = [level_chng_pts; find(abs(Yo_lev.Fx(:,i)) >= du0)];
end
Ye_lev.level_seg_pts = [1;unique(level_chng_pts)+1;Yo_lev.dsamp_win_sz];

% Adjust level-segments
for i=1:length(Ye_lev.level_seg_pts)-1
    st_pt = Ye_lev.level_seg_pts(i);
    en_pt = Ye_lev.level_seg_pts(i+1);
    
    for j=1:size(Yo_lev.X,2)
        Yo_lev.X(st_pt:en_pt,j) = mean(Yo_lev.val(st_pt:en_pt,j)).*ones(en_pt-st_pt+1,1);
    end
end
Yo_lev.Fx = diff(Yo_lev.X);

% Identify level magnitude and duration
Ye_lev.level_seg_duration = diff(Ye_lev.level_seg_pts)*Yo_lev.ts*Yo_lev.dsamp_rate; % in seconds
Ye_lev.level_mag = Yo_lev.Fx(Ye_lev.level_seg_pts(2:end)-1,:);

% Calculate weighted levend
for i=1:length(Yo_lev.name)
    pos_level = find(Ye_lev.level_mag(:,i)>0);
    neg_level = find(Ye_lev.level_mag(:,i)<0);
end

% Identify spikes locations
spk_indx = [];
for i=1:length(Yo_lev.name)
    spk_indx = [spk_indx;find(abs(Yo_lev.U(:,i)) >= 5*std(Yo_lev.U(:,i)))];
end
Ye_lev.spk_pts = unique(spk_indx);

% Identify spike magnitude
Ye_lev.spk_mag = Yo_lev.U(Ye_lev.spk_pts,:);

% Calculate residual
Ye_lev.res_mean = mean(Yo_lev.U);
Ye_lev.res_std = std(Yo_lev.U);

end

