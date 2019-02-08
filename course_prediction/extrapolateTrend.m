function [M3] = extrapolateTrend(M1, M2)
%The function extrapolates time series trends after the extrapolation
%trigger indicator is set.
% M1 - structure of filter output
% M2 - structure of event output

%% ------------------------------------------------------------------------
M3.numTAhead = 300; % how many seconds to extrapolate for
tstampAhead = [0:M3.numTAhead]'; % time stamps for the extrapolations (just number)

y0 = M1.X;
M3.yAhead = y0(end,:) + M2.trnd_mag(end,:).*tstampAhead/60; % linear extrapolation

%% ------------------------------------------------------------------------
flagPlotExt = 1; % whether to plot results
limitMaxMin = [-600, 600];

if flagPlotExt == 0
    plot(M1.t_indx, M1.val, 'LineWidth',1);
    hold on;
    plot(M1.t_indx, M1.X, 'k', 'LineWidth',2);
    tAhead = (tstampAhead + M1.t_indx(end));
    plot(tAhead, M3.yAhead,'--k','LineWidth',2);
    tAll = [M1.t_indx;tAhead];
    plot(tAll,ones(length(tAll),2)*diag(limitMaxMin),'--r','LineWidth',1);
end

end

