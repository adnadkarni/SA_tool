function [M4] = extrapolateTrend(M1, M2, M3)
%The function extrapolates time series trends after the extrapolation
%trigger indicator is set.
% M1 - structure of filter output
% M2 - structure of event output

%% ------------------------------------------------------------------------
M4.numTAhead = 300; % how many seconds to extrapolate for
tstampAhead = [0:M4.numTAhead]'; % time stamps for the extrapolations (just number)
selectTs = find(M3);

y0 = M1.X;
M4.yAhead = y0(end,selectTs) + M2.trnd_mag(end,selectTs).*tstampAhead/60; % linear extrapolation

%% ------------------------------------------------------------------------
flagPlotExt = 0; % whether to plot results
limitMaxMin = [-600, 600];

if flagPlotExt == 1
    plot(M1.t_indx, M1.val(:,selectTs), 'LineWidth',1);
    hold on;
    plot(M1.t_indx, M1.X(:,selectTs), 'k', 'LineWidth',2);
    tAhead = (tstampAhead + M1.t_indx(end));
    plot(tAhead, M4.yAhead,'--k','LineWidth',2);
    tAll = [M1.t_indx;tAhead];
    plot(tAll,ones(length(tAll),2)*diag(limitMaxMin),'--r','LineWidth',1);
end

end

