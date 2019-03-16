function plotDemoLambda(A1, A2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

pl1 = plot(A1, A2);
grid on;


para.LineWidth = 2;
para.FontSize = 11;
para.LineSpec = [];
para.markerStatus = [];
para.markerEdgeColor = [];
para.markerFaceColor = [];
para.markerSize = 8;
para.markerIndices = [1:10:size(A1,1)];
para.ylim = [];
para.xlim = [A1(1) A1(end)];
para.xlabel = 'Time (hh:mm:ss)';
para.ylabel = 'Trend fit (MW)';
para.facecolor = [];
para.barwidth = [];
para.position = [];
para.xticks = A1([1:50:size(A1,1)]);
para.yticks = 'auto';
para.TSnames = [];                                                  % pass only when legends are to be plotted
setPlotPara(para, pl1);

end

