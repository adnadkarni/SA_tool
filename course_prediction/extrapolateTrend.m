function [M4] = extrapolateTrend(M1, M2, M3)
%The function extrapolates time series trends after the extrapolation
%trigger indicator is set.
% M1 - structure of filter output
% M2 - structure of event output

M4.limitMaxMin = [-600, 600];
M4.selectTsForExp = M3;

%% Course prediction
M4.numTAhead = 600; % how many seconds to extrapolate for
M4.tstampAhead = [1:M4.numTAhead]'; % time stamps for the extrapolations (just number)
M4.selectTs = find(M3);

y0 = M1.X;
M4.yAhead(:,M4.selectTs) = y0(end,M4.selectTs) + M2.trnd_mag(end,M4.selectTs).*M4.tstampAhead/60; % linear extrapolation


%% Time to limit
indexNegTr = M4.selectTs(M2.trnd_mag(end,M4.selectTs) < 0 );
indexPosTr = M4.selectTs(M2.trnd_mag(end,M4.selectTs) >= 0 );

M4.t2Lim(indexNegTr,1) = (M4.limitMaxMin(1) - y0(end,indexNegTr))./M2.trnd_mag(end,indexNegTr);
M4.t2Lim(indexPosTr,1) = (M4.limitMaxMin(2) - y0(end,indexPosTr))./M2.trnd_mag(end,indexPosTr);

%% Generate course prediction report
numSelectTs = length(M4.selectTs);

M4.cpTab = table(M1.name(M4.selectTs), M2.trnd_mag(end,M4.selectTs)', M4.t2Lim(M4.selectTs),...
    M2.trnd_seg_duration(end)*ones(numSelectTs,1), M1.t_indx(end)*ones(numSelectTs,1),...
    'VariableNames', {'Name', 'MWperMin', 'Min2Limit', 'Duration', 'time'} ) ;


%% Plot course prediction
flagPlotExt = 0; % whether to plot results

if flagPlotExt == 1
    close all;
    plotExtrapolate(M1, M4);
end

end

