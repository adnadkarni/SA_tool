function plotResMineWin(yD, yP, ySt, resTr, resSpk, resLev, numWin)
%UNTITLED Summary of this function goes here

%% prepare parameters
indexPlotTS = [4,5,6];
numPlotTS = length(indexPlotTS);
namePlotTS = yD.nameTS(indexPlotTS);

intX = 200;
factScaleTS = 1e3;


figure(2)
%%
subplot(2,3,1);
pl1 = plot(yD.indexTime,...
    [yD.val(:,indexPlotTS), yD.X(:,indexPlotTS)] /factScaleTS);
grid on;


para.Color = {'b', 'r', 'm', 'k', 'k', 'k'};
para.LineWidth = [1,1,1,1,1,1];
para.FontSize = 11;
para.LineSpec = 'o';
para.markerStatus = [];
para.markerEdgeColor = 'k';
para.markerFaceColor = 'r';
para.markerSize = 10;
para.markerIndices = [1:10:size(yD.val,1)];
para.ylim = [];
para.xlim = [yD.indexTime(1) yD.indexTime(end)];
para.xlabel = 'time (hh:mm:ss)';
para.ylabel = 'voltage (kV)';
para.facecolor = [];
para.barwidth = [];
para.position = [];
para.xticks = yD.indexTime([1:intX/2-1:size(yD.val,1)]);
para.xticklabels = [];
para.yticks = 'auto';
para.TSnames = namePlotTS;                                                  % pass only when legends are to be plotted
para.title = 'Trend fit';
setPlotPara(para, pl1)

%%
subplot(2,3,2)
pl2 = plot(yD.indexTime,...
    [yD.val(:,indexPlotTS), yD.W(:,indexPlotTS)] /factScaleTS);
grid on;

para.Color = {'b', 'r', 'm', 'k', 'k', 'k'};
para.LineWidth = [1,1,1,1,1,1];
para.FontSize = 11;
para.LineSpec = 'o';
para.markerStatus = [];
para.markerEdgeColor = 'k';
para.markerFaceColor = 'r';
para.markerSize = 10;
para.markerIndices = [1:10:size(yD.val,1)];
para.ylim = [];
para.xlim = [yD.indexTime(1) yD.indexTime(end)];
para.xlabel = 'time (hh:mm:ss)';
para.ylabel = 'voltage (kV)';
para.facecolor = [];
para.barwidth = [];
para.position = [];
para.xticks = yD.indexTime([1:intX/2-1:size(yD.val,1)]);
para.xticklabels = [];
para.yticks = 'auto';
para.TSnames = [];                                                          % pass only when legends are to be plotted
para.title = 'Level fit';
setPlotPara(para, pl2)

%%
subplot(2,3,3)
pl3 = plot(yD.indexTime,...
    [yD.U(:,indexPlotTS)] /factScaleTS);
grid on;

para.Color = {'b', 'r', 'm',};
para.LineWidth = [1,1,1];
para.FontSize = 11;
para.LineSpec = 'o';
para.markerStatus = [];
para.markerEdgeColor = 'k';
para.markerFaceColor = 'r';
para.markerSize = 10;
para.markerIndices = [1:10:size(yD.val,1)];
para.ylim = [];
para.xlim = [yD.indexTime(1) yD.indexTime(end)];
para.xlabel = 'time (hh:mm:ss)';
para.ylabel = 'voltage (kV)';
para.facecolor = [];
para.barwidth = [];
para.position = [];
para.xticks = yD.indexTime([1:intX/2-1:size(yD.val,1)]);
para.xticklabels = [];
para.yticks = 'auto';
para.TSnames = [];                                                  % pass only when legends are to be plotted
para.title = 'Trend fit residual';
setPlotPara(para, pl3)

%%
subplot(2,3,4)
if (resTr.statusLastSegTrend(numWin) == 1)
    pl4 = bar([[resTr.lastSegTrend(numWin(1),indexPlotTS)]'/factScaleTS,...
        [resTr.wtdAtInstTrend(numWin(1),indexPlotTS)]'/factScaleTS]);
    
    text(2,500,sprintf('trend duration = %d sec',...
        resTr.durLastSegTrend(numWin(1))));
    grid on;
    
    para.Color = [];
    para.LineWidth = [];
    para.FontSize = 11;
    para.LineSpec = 'o';
    para.markerStatus = [];
    para.markerEdgeColor = 'k';
    para.markerFaceColor = 'r';
    para.markerSize = 10;
    para.markerIndices = [1:10:size(yD.val,1)];
    para.ylim = [];
    para.xlim = [];
    para.xlabel = 'station name';
    para.ylabel = 'trend (kV/min)';
    para.facecolor = [];
    para.barwidth = [];
    para.position = [];
    para.xticks = [];
    para.xticklabels = namePlotTS;
    para.yticks = 'auto';
    para.TSnames = {'Last seg trend', 'Weighted trend'};                                                  % pass only when legends are to be plotted
    para.title = 'Trend magnitude';
    setPlotPara(para, pl4)
end
%%
subplot(2,3,5)
if (resLev.statusLevelChange(numWin) == 1)
    if (~isempty(ySt.indexTimeLevelChange))
        if (length(ySt.indexTimeLevelChange)== 1)
            yBarY = [ySt.magLevelChange(:, indexPlotTS); nan*ones(1,numPlotTS)]/factScaleTS;
        else
            yBarY = ySt.magLevelChange(:, indexPlotTS)/factScaleTS;
        end
    else
        yBarY = 0;
    end
    pl5 = bar(yBarY, 'grouped');
    
    grid on;
    
    para.Color = [];
    para.LineWidth = [];
    para.FontSize = 11;
    para.LineSpec = 'o';
    para.markerStatus = [];
    para.markerEdgeColor = 'k';
    para.markerFaceColor = 'r';
    para.markerSize = 10;
    para.markerIndices = [1:10:size(yD.val,1)];
    para.ylim = [];
    para.xlim = [];
    para.xlabel = 'time (hh:mm:ss)';
    para.ylabel = 'level-change (kV)';
    para.facecolor = [];
    para.barwidth = [];
    para.position = [];
    para.xticks = [];
    para.xticklabels = datestr(ySt.indexTimeLevelChange, 'HH:MM:SS');
    para.yticks = 'auto';
    para.TSnames = namePlotTS;                                                  % pass only when legends are to be plotted
    para.title = 'Level change magnitude';
    setPlotPara(para, pl5)
end
%%
subplot(2,3,6)

if (resSpk.statusSpike(numWin) == 1)
    y1 = resSpk.magNindexSpike{numWin,1};
    
    if (~isempty(y1))
        if (size(y1,1)== 1)
            yBarY = [y1(:, indexPlotTS); nan*ones(1,numPlotTS)]/factScaleTS;
        else
            yBarY = y1(:, indexPlotTS)/factScaleTS;
        end
    else
        yBarY = 0;
    end
    pl6 = bar(yBarY, 'grouped');
    
    grid on;
    
    para.Color = [];
    para.LineWidth = [];
    para.FontSize = 11;
    para.LineSpec = 'o';
    para.markerStatus = [];
    para.markerEdgeColor = 'k';
    para.markerFaceColor = 'r';
    para.markerSize = 10;
    para.markerIndices = [1:10:size(yD.val,1)];
    para.ylim = [];
    para.xlim = [];
    para.xlabel = 'time (hh:mm:ss)';
    para.ylabel = 'level-change (kV)';
    para.facecolor = [];
    para.barwidth = [];
    para.position = [];
    para.xticks = [];
    para.xticklabels = datestr(resSpk.magNindexSpike{numWin,2}, 'HH:MM:SS');
    para.yticks = 'auto';
    para.TSnames = namePlotTS;                                                  % pass only when legends are to be plotted
    para.title = 'Level change magnitude';
    setPlotPara(para, pl6)
end
end

