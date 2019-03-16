function plotResMineAll(yIn1, yIn2, yIn3, yIn4, yIn5)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% prepare parameters
indexPlotTS = yIn2.selectTS;
namePlotTS = yIn1.namePMU(indexPlotTS);

figure(1)
%%
intX = 200;
factScaleTS = 1e3;
subplot(2,3,1)
pl1 = plot(yIn1.indexTime,yIn1.val(:,indexPlotTS)/factScaleTS);
grid on;

para.Color = [];
para.LineWidth = 2*ones(length(indexPlotTS),1);
para.FontSize = 11;
para.LineSpec = 'o';
para.markerStatus = [];
para.markerEdgeColor = 'k';
para.markerFaceColor = 'r';
para.markerSize = 10;
para.markerIndices = [1:10:size(yIn1.val,1)];
para.ylim = [];
para.xlim = [yIn1.indexTime(1) yIn1.indexTime(end)];
para.xlabel = 'time (hh:mm:ss)';
para.ylabel = 'frequency (Hz)';
para.facecolor = [];
para.barwidth = [];
para.position = [0.13 0.58 0.65 0.34];
para.xticks = yIn1.indexTime([1:intX:size(yIn1.val,1)]);
para.xticklabels = [];
para.yticks = 'auto';
para.TSnames = namePlotTS;                                                  % pass only when legends are to be plotted
para.title = 'Hourly dataset';
setPlotPara(para, pl1)

%%
intX = 200;
subplot(2,3,4)
pl2 = bar(yIn3.indexEndTime, yIn3.statusLastSegTrend, 'k');
grid on;

para.Color = [];
para.LineWidth = 2;
para.FontSize = 11;
para.LineSpec = [];
para.MarkerIndices = [1:10:size(yIn1.val,1)];
para.ylim = [0 2];
para.xlim = [];
para.xlabel = 'time (hh:mm:ss)';
para.ylabel = 'status (Trend)';
para.position = [];
para.xticks = [1:10:size(yIn1.val,1)];
para.facecolor = [0 0 0];
para.barwidth = 0.4;
para.xticks = yIn1.indexTime([1:intX:size(yIn1.val,1)]);
para.xticklabels = [];
para.yticks = unique(yIn3.statusLastSegTrend);
para.TSnames = []; 
para.title = 'Trend status';
setPlotPara(para, pl2)

%%
subplot(2,3,6)
pl3 = bar(yIn4.indexEndTime, yIn4.statusSpike, 'k');
grid on;

para.Color = [];
para.LineWidth = 2;
para.FontSize = 11;
para.LineSpec = [];
para.MarkerIndices = [1:10:size(yIn1.val,1)];
para.ylim = [0 2];
para.xlim = [];
para.xlabel = 'time (hh:mm:ss)';
para.ylabel = 'status';
para.position = [];
para.xticks = [1:10:size(yIn1.val,1)];
para.facecolor = [0 0 0];
para.barwidth = 0.4;
para.xticks = yIn1.indexTime([1:intX:size(yIn1.val,1)]);
para.xticklabels = [];
para.yticks = unique(yIn4.statusSpike);
para.TSnames = [];
para.title = 'Spike status';
setPlotPara(para, pl3)

%%
subplot(2,3,5)
pl4 = bar(yIn5.indexEndTime, yIn5.statusLevelChange, 'k');
grid on;

para.Color = [];
para.LineWidth = 2;
para.FontSize = 11;
para.LineSpec = [];
para.MarkerIndices = [1:10:size(yIn1.val,1)];
para.ylim = [0 2];
para.xlim = [];
para.xlabel = 'time (hh:mm:ss)';
para.ylabel = 'status';
para.position = [];
para.xticks = [1:10:size(yIn1.val,1)];
para.facecolor = [0 0 0];
para.barwidth = 0.4;
para.xticks = yIn1.indexTime([1:intX:size(yIn1.val,1)]);
para.xticklabels = [];
para.yticks = unique(yIn5.statusLevelChange);
para.TSnames = [];
para.title = 'Level change status';
setPlotPara(para, pl4)

end
