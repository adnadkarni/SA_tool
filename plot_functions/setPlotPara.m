function setPlotPara(para, pl)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
numLines = length(pl);
for i=1:numLines
    pl(i).LineWidth = para.LineWidth;
end

ax = gca;
if ~isempty(para.position)
    ax.Position = para.position;
end
ax.FontSize = para.FontSize;
xlabel(para.xlabel);
ylabel(para.ylabel);
if (~isempty(para.xlim))
    xlim(para.xlim);
end
if (~isempty(para.ylim))
    ylim(para.ylim);
end

if (~isempty(para.facecolor))
    pl.FaceColor = para.facecolor;
end

if (~isempty(para.barwidth))
    pl.BarWidth = para.barwidth;
end

xticks(ax,para.xticks);
yticks(ax,para.yticks);

if ~isempty(para.TSnames)
    legend(para.TSnames, 'FontSize' , 8, 'Position', [0.82 0.63 0.15 0.25]);
end

end

